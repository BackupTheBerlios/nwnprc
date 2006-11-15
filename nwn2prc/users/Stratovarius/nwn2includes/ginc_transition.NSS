//::///////////////////////////////////////////////////////////////////////////
//::
//::	ginc_transition
//::
//::	Global include for transitions.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 3/2/06
// ChazM 3/3/06 - parameterized GatherPartyTransition(), added IsPartyGathered()
// DBR 4/9/6 - Changed to message box for "Gather party"
// BMA-OEI 5/01/06 - Changed IsPartyGathered() to check all party members
// BMA-OEI 6/14/06 - Added SinglePartyTransition()
// ChazM 6/22/06 - Temporarily set gather radius really large.
// BMA-OEI 6/24/06 - Moved nw_g0_transition code into AttemptAreaTransition()
// BMA-OEI 7/04/06 - Check to Remove Dominated On Transition

//void main(){}

#include "ginc_effect"
#include "x2_inc_switches"


const float fGATHER_RADIUS = 200.0f;
const string VAR_GLOBAL_GATHER_PARTY = "bGATHER_PARTY_TRAN";


void AttemptAreaTransition( object oObject, object oDestination );
void ReportPartyGather( object oPCF );
int IsPartyGathered( object oPC );
void GatherPartyTransition( object oPC, object oTransitionTarget );
void SinglePartyTransition( object oPC, object oDestination );


// Standard NWN2 area transition code
void AttemptAreaTransition( object oObject, object oDestination )
{
	// BMA-OEI 7/04/06 - Check if in group and using group campaign flag
	if ( GetGlobalInt(CAMPAIGN_SWITCH_REMOVE_DOMINATED_ON_TRANSITION) == TRUE )
	{
		if ( ( GetIsPC(oObject) == TRUE ) || ( GetFactionEqual(oObject, GetFirstPC()) == TRUE ) )
		{
			int nRemoved = 0;
			object oFM = GetFirstFactionMember( oObject, FALSE );
			while ( GetIsObjectValid(oFM) == TRUE )
			{
				nRemoved = nRemoved + RemoveEffectsByType( oFM, EFFECT_TYPE_DOMINATED );
				oFM = GetNextFactionMember( oObject, FALSE );
			}
			
			if ( nRemoved > 0 )
			{
				// Abort transition if domianted effect was found and removed
				return;
			}
		}
	}
	
	// k_mod_load.nss campaign setting - override "Gather Party" transition
	// TODO: What if oClicker is NPC?
	if ( GetGlobalInt( VAR_GLOBAL_GATHER_PARTY ) == 1 )
	{
		GatherPartyTransition( oObject, oDestination );
		return;
	}
	
	if ( GetIsPartyTransition( OBJECT_SELF ) == TRUE )
	{
		SinglePartyTransition( oObject, oDestination );
	}
	else
	{
		AssignCommand( oObject, JumpToObject( oDestination ) );
	}
}

// Complain that party needs to be gathered!
void ReportPartyGather(object oPCF)
{
	CloseGUIScreen(oPCF, "SCREEN_MESSAGEBOX_DEFAULT");
	
	DelayCommand(
		0.1,
		DisplayMessageBox(
			oPCF,	// Display a message box for this PC
			161846, // string ref to display
			"", 	// Message to display
			"", 	// Callback for clicking the OK button
			"", 	// Callback for clicking the Cancel button
			FALSE, 	// display the Cancel button
			"SCREEN_MESSAGEBOX_DEFAULT", // Display the tutorial message box	
			-1, 	// OK string ref
			"", 	// OK string
			-1, 	// Cancel string ref
			""  	// Cancel string
		)
	);
}	

// Check if party is gathered ( alive, not in conversation, and nearby )
int IsPartyGathered( object oPC )
{
	object oArea = GetArea( oPC );
	
	object oFM = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		// For all members in the area
		if ( GetArea( oFM ) == oArea )
		{
			if ( ( GetIsDead( oFM ) == TRUE ) || 
				 ( IsInConversation( oFM ) == TRUE ) ||
				 ( GetDistanceBetween( oFM, oPC ) >= fGATHER_RADIUS ) )
			{
				return ( FALSE );
			}
		}

		oFM = GetNextFactionMember( oPC, FALSE );
	}

	return ( TRUE );
}

// Transition to oTransitionTarget if oPC's party is gathered ( alive, not in conversation, and nearby )
// Otherwise, ask oPC to first gather the party.
void GatherPartyTransition( object oPC, object oTransitionTarget )
{
	if ( ( GetIsPC( oPC ) == FALSE ) ||
		 ( GetIsDead( oPC ) == TRUE ) ||
		 ( IsInConversation( oPC ) == TRUE ) )
	{
		return;
	}
	
	if ( IsPartyGathered( oPC ) == FALSE )
	{
		ReportPartyGather( oPC );
		return;
	}
		
	SinglePartyTransition( oPC, oTransitionTarget );	
}

// Forces oPC's faction to be alive and commandable before sending
// them to oDestination via JumpPartyToArea().
void SinglePartyTransition( object oPC, object oDestination )
{
	effect eRes = EffectResurrection();

	// For each party member, revive and set commandable
	object oFM = GetFirstFactionMember( oPC, FALSE );
	while ( GetIsObjectValid( oFM ) == TRUE )
	{
		SetCommandable( TRUE );
		ApplyEffectToObject( DURATION_TYPE_INSTANT, eRes, oFM );		
		oFM = GetNextFactionMember( oPC, FALSE );
	}

	// Transition and trigger FiredFromPartyTransition()
	JumpPartyToArea( oPC, oDestination );	
}