//::///////////////////////////////////////////////
//:: Name     Shifter PnP functions
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Functions used by the shifter class to better simulate the PnP rules

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "nw_o0_itemmaker"
#include "nw_i0_spells"
#include "prc_inc_function"

//shift from quickslot info
void QuickShift(object oPC, int iQuickSlot);
//asign form to your quick slot
void SetQuickSlot(object oPC, int iIndex, int iQuickSlot, int iEpic);
// Determine the level of the Shifter needed to take on
// oTargets shape.
// Returns 1-10 for Shifter level, 11+ for Total levels
int GetShifterLevelRequired(object oTarget);
// Can the shifter (oPC) assume the form of the target
// return Values: TRUE or FALSE
int GetValidShift(object oPC, object oTarget);
// Determine if the oCreature can wear certain equipment
// nInvSlot INVENTORY_SLOT_*
// Return values: TRUE or FALSE
int GetCanFormEquip(object oCreature, int nInvSlot);
// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature);
// Translastes a creature name to a resref for use in createobject
// returns a resref string
string GetResRefFromName(object oPC, string sName);
// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature);
// Determines the APPEARANCE_TYPE_* for the PC
// based on the players RACIAL type
int GetTrueForm(object oPC);

//is inventory full if yes then CanShift = false else CanShift = true
int CanShift(object oPC);

// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
// Return values: TRUE or FALSE
int SetShiftEpic(object oPC, object oTarget);
// Transforms the oPC back to thier true form if they are shifted
// Return values: TRUE or FALSE
void SetShiftTrueForm(object oPC);
// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
int SetShiftFromTemplateValidate(object oPC, string sTemplate, int iEpic);

// Extra item functions
// Copys all the item properties from the target to the destination
void CopyAllItemProperties(object oDestination,object oTarget);
// Gets all the ability modifires from the creature objects inv
// use IP_CONTS_ABILITY_*
int GetAllItemsAbilityModifier(object oTarget, int nAbility);
// Removes all the item properties from the item
void RemoveAllItemProperties(object oItem);
// Gets an IP_CONST_FEAT_* from FEAT_*
// returns -1 if the feat is not available
int GetIPFeatFromFeat(int nFeat);
// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oTarget);

// Removes leftover aura effects
void RemoveAuraEffect( object oPC );
// Adds a creature to the list of valid GWS shift possibilities
void RecognizeCreature( object oPC, string sTemplate, string sCreatureName );
// Checks to see if the specified creature is a valid GWS shift choice
int IsKnownCreature( object oPC, string sTemplate );
// Shift based on position in the known array
// oTemplate is either the epic or normal template
void ShiftFromKnownArray(int nIndex,int iEpic, object oPC);
//delete form from spark
void DeleteFromKnownArray(int nIndex, object oPC);

// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
// this is 3 stage
// these 3 scripts replace the origanel setshift script
// (setshift_03 is almost all of the origenal setshift script)
void SetShift(object oPC, object oTarget);
void SetShift_02(object oPC, object oTarget, object oASPC);
void SetShift_03(object oPC, object oTarget, object oASPC);



int CanShift(object oPC)
{
	int iOutcome = FALSE;
	object oItem = CreateItemOnObject("pnp_shft_tstpkup", oPC);
	if (GetItemPossessor(oItem) == oPC)
	{
		iOutcome = TRUE;
	}
	else
	{
		SendMessageToPC(oPC, "Your inventory is to full to allow you to unshift.");
		SendMessageToPC(oPC, "Please make room enough for an armour sized item and then try again.");
	}

	DestroyObject(oItem);

    //there are issues with shifting will polymorphed
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eType = GetEffectType(eEff);
        if (eType == EFFECT_TYPE_POLYMORPH)
        {
			SendMessageToPC(oPC, "Shifting when polymorphed has been disabled.");
			SendMessageToPC(oPC, "Please unpolymorph first");
			return FALSE;
        }
        eEff = GetNextEffect(oPC);
    }

	return iOutcome;
}

void QuickShift(object oPC, int iQuickSlot)
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int iMaxIndex = GetLocalInt(oMimicForms, "num_creatures");
    int iIndex = GetLocalArrayInt(oMimicForms, "QuickSlotIndex", iQuickSlot);
    int iEpic = GetLocalArrayInt(oMimicForms, "QuickSlotEpic", iQuickSlot);
    if(!(iIndex>iMaxIndex))
        ShiftFromKnownArray(iIndex, iEpic, oPC);
}

void SetQuickSlot(object oPC, int iIndex, int iQuickSlot, int iEpic)
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    SetLocalArrayInt(oMimicForms,"QuickSlotIndex",iQuickSlot,iIndex);
    SetLocalArrayInt(oMimicForms,"QuickSlotEpic",iQuickSlot,iEpic);
}

// Transforms the oPC into the oTarget
// Assumes oTarget is already a valid target
// starts here and goes to SetShift_02 then SetShift_03

// stage 1:
//   create the clone of the PC to get ability scores from later
//   make the clone an invi model so it dont apper
//   if the shifter if already shifted call unshift to run after this stage ends
//   call next stage to start after this stage ends
void SetShift(object oPC, object oTarget)
{
    int i=0;
    object oLimbo=GetObjectByTag("Limbo",i);
    location lLimbo;
    while (i < 100)
    {
        if (GetIsObjectValid(oLimbo))
        {
            if (GetName(oLimbo)=="Limbo")
            {
                i = 2000;
                vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
                lLimbo = Location(oLimbo, vLimbo, 0.0f);
            }
        }
        i++;
        object oLimbo=GetObjectByTag("Limbo",i);
    }
    //create copy of the PC for getting base ability scores
    object oASPC;
    if (i>=2000)
    {
        oASPC = CopyObject(oPC, lLimbo, OBJECT_INVALID, "pnp_shifter_deleteme");
    }
    else
    {
        oASPC = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, "pnp_shifter_deleteme");
    }

//    //set appearance to invis so it dont show up when scripts run thro
//    SetCreatureAppearanceType(oASPC,APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
    DelayCommand(0.1,SetShift_02(oPC, oTarget, oASPC));

    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    int iTemp = GetLocalInt(oHidePC,"nPCShifted");

    if (iTemp)
    {
        DelayCommand(0.0, SetShiftTrueForm(oPC));
    }


}

// stage 1 end:
//   the clone is made
//   the shifter is unshifted if need be
//   and the next stage is called

// stage 2:
//   strip the clone of all items and ability effects(spells,etc)
//   call stage 3 to start after this stage ends
void SetShift_02(object oPC, object oTarget, object oASPC)
{


    object oItem;
    int nSlot;

    for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
    {
        oItem=GetItemInSlot(nSlot, oASPC);
        //remove if valid
        if (GetIsObjectValid(oItem))
        {
//            AssignCommand(oASPC, DestroyObject(oItem,0.0));
            DestroyObject(oItem,0.0);
        }
    }
    // remove all effect on the clone so
    // we can determine the ability scores
    effect eEff = GetFirstEffect(oASPC);
    while(GetIsEffectValid(eEff))
    {
        RemoveEffect(oASPC,eEff);
        eEff = GetNextEffect(oASPC);
    }

    DelayCommand(0.1,SetShift_03(oPC, oTarget, oASPC));
}

// stage 2 end:
//   the clone is strip of all items and effects and is just a base copy of you
//   stage 3 is run

// stage 3:
//   this is most of what the old SetShift script did
//   the changes are:
//     base ability scores are read from your clone
//     no check for if shifted is needed and has been removed
//     the epic ability item is done here (if epicshifter var is 1)
//     both oTarget and oASPC are destryed in this script
void SetShift_03(object oPC, object oTarget, object oASPC)
{

    //get all the creature items from the target
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oTarget);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oTarget);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oTarget);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oTarget);

    //get all the creature items from the pc
    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);


    // Force the PC to equip the creature items if the PC does not have one
    if (!GetIsObjectValid(oHidePC))
    {
        oHidePC = CopyObject(oHide,GetLocation(oPC),oPC);
        // Some NPCs dont have hides, create a generic on on the pc
        if (!GetIsObjectValid(oHidePC))
        {
            oHidePC = CreateItemOnObject("shifterhide",oPC);
        }
        // Need to ID the stuff before we can put it on the PC
        SetIdentified(oHidePC,TRUE);
        AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR));
    }
    else // apply the hide effects to the PCs hide
    {
        // Make sure we start with a clean hide
        ScrubPCSkin(oPC,oHidePC);
		//RemoveAllItemProperties(oHidePC);
        CopyAllItemProperties(oHidePC,oHide);
        DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR)));

    }
    if (!GetIsObjectValid(oWeapCR))
	{
		DestroyObject(oWeapCRPC, 1.0);
	}
	else
	{
		if (!GetIsObjectValid(oWeapCRPC))
		{
			oWeapCRPC = CopyObject(oWeapCR,GetLocation(oPC),oPC);
			SetIdentified(oWeapCRPC,TRUE);
			AssignCommand(oPC,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R));
		}
		else // apply effects to the item
		{
			// Make sure we start with a clean weapon
			RemoveAllItemProperties(oWeapCRPC);
			CopyAllItemProperties(oWeapCRPC,oWeapCR);
		    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R)));
		}
	}
    if (!GetIsObjectValid(oWeapCL))
	{
		DestroyObject(oWeapCLPC, 1.0);
	}
	else
	{
		if (!GetIsObjectValid(oWeapCLPC))
		{
			oWeapCLPC = CopyObject(oWeapCL,GetLocation(oPC),oPC);
			SetIdentified(oWeapCLPC,TRUE);
			AssignCommand(oPC,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L));
		}
		else // apply effects to the item
		{
			// Make sure we start with a clean weapon
			RemoveAllItemProperties(oWeapCLPC);
			CopyAllItemProperties(oWeapCLPC,oWeapCL);
		    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L)));
		}
	}
    if (!GetIsObjectValid(oWeapCB))
	{
		DestroyObject(oWeapCBPC, 1.0);
	}
	else
	{
		if (!GetIsObjectValid(oWeapCBPC))
		{
			oWeapCBPC = CopyObject(oWeapCB,GetLocation(oPC),oPC);
			SetIdentified(oWeapCBPC,TRUE);
			AssignCommand(oPC,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B));
		}
		else // apply effects to the item
		{
			// Make sure we start with a clean weapon
			RemoveAllItemProperties(oWeapCBPC);
			CopyAllItemProperties(oWeapCBPC,oWeapCB);
			DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B)));
		}
	}

    // Get the Targets str, dex, and con
    int nTStr = GetAbilityScore(oTarget,ABILITY_STRENGTH);
    int nTDex = GetAbilityScore(oTarget,ABILITY_DEXTERITY);
    int nTCon = GetAbilityScore(oTarget,ABILITY_CONSTITUTION);

//    SendMessageToPC(oPC,"target Str,dex,con" + IntToString(nTStr) + "," + IntToString(nTDex) + "," + IntToString(nTCon));

    // Get the PCs str, dex, and con from the clone
    int nPCStr = GetAbilityScore(oASPC,ABILITY_STRENGTH);
    int nPCDex = GetAbilityScore(oASPC,ABILITY_DEXTERITY);
    int nPCCon = GetAbilityScore(oASPC,ABILITY_CONSTITUTION);

//    SendMessageToPC(oPC,"Pc Str,dex,con" + IntToString(nPCStr) + "," + IntToString(nPCDex) + "," + IntToString(nPCCon));


    // Get the deltas
    int nStrDelta = nTStr - nPCStr;
    int nDexDelta = nTDex - nPCDex;
    int nConDelta = nTCon - nPCCon;

//    SendMessageToPC(oPC,"delta Str,dex,con" + IntToString(nStrDelta) + "," + IntToString(nDexDelta) + "," + IntToString(nConDelta));

    // Cap max to +12 til they can fix it and -10 for the low value
    if (nStrDelta > 12)
        nStrDelta = 12;
    if (nStrDelta < -10)
        nStrDelta = -10;
    if (nDexDelta > 12)
        nDexDelta = 12;
    if (nDexDelta < -10)
        nDexDelta = -10;
    if (nConDelta > 12)
        nConDelta = 12;
    if (nConDelta < -10)
        nConDelta = -10;

    // Big problem with <0 to abilities, if they have immunity to ability drain
    // the - to the ability wont do anything

    // Apply these boni to the creature hide
    if (nStrDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,nStrDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_STR,nStrDelta*-1),oHidePC);
    if (nDexDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,nDexDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_DEX,nDexDelta*-1),oHidePC);
    if (nConDelta > 0)
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,nConDelta),oHidePC);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CON,nConDelta*-1),oHidePC);


    // Apply the natural AC bonus to the hide
    // First get the AC from the target
    int nTAC = GetAC(oTarget);
    nTAC -= GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
    // All creatures have 10 base AC
    nTAC -= 10;
    int i;
    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        nTAC -= GetItemACValue(GetItemInSlot(i,oTarget));
    }

    if (nTAC > 0)
    {
        effect eAC = EffectACIncrease(nTAC,AC_NATURAL_BONUS);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eAC),oPC);
    }

    // Apply any feats the target has to the hide as a bonus feat
    for (i = 0; i< 500; i++)
    {
        if (GetHasFeat(i,oTarget))
        {
            int nIP =  GetIPFeatFromFeat(i);
            if(nIP != -1)
            {
                itemproperty iProp = ItemPropertyBonusFeat(nIP);
                AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oHidePC);
            }

        }
    }

    // If they dont have the natural spell feat they can only cast spells in certain shapes
    if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_NATURALSPELL,oPC))
    {
        if (!GetCanFormCast(oTarget))
        {
            // remove the ability from the PC to cast
            effect eNoCast = EffectSpellFailure();
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eNoCast),oPC);
        }
    }

    // If the creature is "harmless" give it a perm invis for stealth
    if(GetIsCreatureHarmless(oTarget))
    {
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect(eInvis),oPC);
    }


    // Change the Appearance of the PC
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC);
    //get the appearance of oTarget
    int iAppearance = GetLocalInt(oTarget,"Appearance");
    if (iAppearance>0)
        SetCreatureAppearanceType(oPC,iAppearance);
    else
        SetCreatureAppearanceType(oPC,GetAppearanceType(oTarget));

    // For spells to make sure they now treat you like the new race
    SetLocalInt(oPC,"RACIAL_TYPE",GetRacialType(oTarget)+1);

    // PnP rules say the shifter would heal as if they rested
    effect eHeal = EffectHeal(GetHitDice(oPC)*d4());
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eHeal,oPC);

    //epic shift
    if (GetLocalInt(oPC,"EpicShift"))
    {
        // Create some sort of usable item to represent monster spells
        object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
        if (!GetIsObjectValid(oEpicPowersItem))
            oEpicPowersItem = CreateItemOnObject("epicshifterpower",oPC);
        SetItemSpellPowers(oEpicPowersItem,oTarget);
    }

    // Set a flag on the PC to tell us that they are shifted
    SetLocalInt(oHidePC,"nPCShifted",TRUE);
    //clear epic shift var
    SetLocalInt(oPC,"EpicShift",0);

    //remove oTarget if it is from the template
    int iDeleteMe = GetLocalInt(oTarget,"pnp_shifter_deleteme");
    if (iDeleteMe==1)
    {
        // Remove the temporary creature
        AssignCommand(oTarget,SetIsDestroyable(TRUE,FALSE,FALSE));
        SetPlotFlag(oTarget,FALSE);
        SetImmortal(oTarget,FALSE);
        DestroyObject(oTarget);
    }
    //remove your clone
    AssignCommand(oASPC,SetIsDestroyable(TRUE,FALSE,FALSE));
    SetPlotFlag(oASPC,FALSE);
    SetImmortal(oASPC,FALSE);
    DestroyObject(oASPC);

    //re-equid creature items to get correct ip feats
    //(some were staying on even when they had been removed from the hide)
    //oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    //oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    //oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    //oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
    //mast not unequid the items, this would crash the game
    //but re-equiping the items when they are already equiped will
    //recheck what is on the hide
    //DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR)));
    //DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R)));
    //DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L)));
    //DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B)));

    // Reset any PRC feats that might have been lost from the shift
    EvalPRCFeats(oPC);

}

// stage 3 end:
//   both the clone and the target are distroyed(target only if not mimic target)
//   all effects and item propertys are applyed to you and your hide/cweapons


void RecognizeCreature( object oPC, string sTemplate, string sCreatureName )
{

    // Only add new ones
    if (IsKnownCreature(oPC,sTemplate))
        return;

    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    if ( !GetIsObjectValid(oMimicForms) )
        oMimicForms = CreateItemOnObject( "sparkoflife", oPC );

    SetPlotFlag(oMimicForms, TRUE);
    SetDroppableFlag(oMimicForms, FALSE);
    SetItemCursedFlag(oMimicForms, FALSE);

    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );

    SetLocalArrayString( oMimicForms, "shift_choice", num_creatures, sTemplate );
    SetLocalArrayString( oMimicForms, "shift_choice_name", num_creatures, sCreatureName );//added thi line to store the name as well as the resref
    SetLocalInt( oMimicForms, "num_creatures", num_creatures+1 );


//SendMessageToPC(oPC,"Num Creatures = "+IntToString(num_creatures+1));
}

int IsKnownCreature( object oPC, string sTemplate )
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;
    string cmp;

    for ( i=0; i<num_creatures; i++ )
    {
        cmp = GetLocalArrayString( oMimicForms, "shift_choice", i );
        if ( TestStringAgainstPattern( cmp, sTemplate ) )
        {
            return TRUE;
        }
    }
    return FALSE;
}

void DeleteFromKnownArray(int nIndex, object oPC)
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;

    for ( i=nIndex; i<(num_creatures-1); i++ )
    {
        SetLocalArrayString( oMimicForms, "shift_choice", i,GetLocalArrayString( oMimicForms, "shift_choice", i+1 ));
        SetLocalArrayString( oMimicForms, "shift_choice_name", i,GetLocalArrayString( oMimicForms, "shift_choice_name", i+1 ));
    }
    SetLocalInt( oMimicForms, "num_creatures", num_creatures-1 );
}

// Shift based on position in the known array
void ShiftFromKnownArray(int nIndex,int iEpic, object oPC)
{
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );

    // Find the name
    string sResRef = GetLocalArrayString( oMimicForms, "shift_choice", nIndex );
    if (iEpic == FALSE)
    {
        // Force a normal shift
        SetShiftFromTemplateValidate(oPC,sResRef,FALSE);
    }
    else // epic shift
    {
        SetShiftFromTemplateValidate(oPC,sResRef,TRUE);
    }
}


// Remove "dangling" aura effects on trueform shift
// Now only removes things it should remove (i.e., auras)
void RemoveAuraEffect( object oPC )
{
    if ( GetHasSpellEffect(SPELLABILITY_AURA_BLINDING, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_BLINDING, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_COLD, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_COLD, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_ELECTRICITY, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_ELECTRICITY, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FEAR, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_FIRE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_FIRE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_MENACE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_MENACE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_PROTECTION, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_PROTECTION, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_STUN, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_STUN, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNEARTHLY_VISAGE, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNNATURAL, oPC) )
        RemoveSpellEffects( SPELLABILITY_AURA_UNNATURAL, oPC, oPC );
    if ( GetHasSpellEffect(SPELLABILITY_DRAGON_FEAR, oPC) )
        RemoveSpellEffects( SPELLABILITY_DRAGON_FEAR, oPC, oPC );
}


void CopyAllItemProperties(object oDestination,object oTarget)
{
    itemproperty iProp = GetFirstItemProperty(oTarget);

    while (GetIsItemPropertyValid(iProp))
    {
        AddItemProperty(GetItemPropertyDurationType(iProp), iProp, oDestination);
        iProp = GetNextItemProperty(oTarget);
    }
}

int GetAllItemsAbilityModifier(object oTarget, int nAbility)
{
    // Go through all the equipment and add it all up
    int nRetValue = 0;
    object oItem;
    itemproperty iProp;
    int i;

    for (i=0; i < NUM_INVENTORY_SLOTS; i++)
    {
        oItem = GetItemInSlot(i,oTarget);

        if (GetIsObjectValid(oItem))
        {
            iProp = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(iProp))
            {
                //SendMessageToPC(oTarget,"In while loop for " + GetName(oItem));
                if (ITEM_PROPERTY_ABILITY_BONUS == GetItemPropertyType(iProp))
                {
                    if (nAbility == GetItemPropertySubType(iProp))
                    {
                        nRetValue += GetItemPropertyCostTableValue(iProp);
                    }
                }
                iProp = GetNextItemProperty(oItem);
            }
        }

    }
    return nRetValue;
}

void RemoveAllItemProperties(object oItem)
{
    itemproperty iProp = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(iProp))
    {

//        SendMessageToPC(GetItemPossessor(oItem),"item prop type-" + IntToString(GetItemPropertyType(iProp)));

        RemoveItemProperty(oItem,iProp);
        iProp = GetNextItemProperty(oItem);

    }
    // for a skin and prcs to get their feats back
    DeletePRCLocalInts(oItem);
}

// Gets an IP_CONST_FEAT_* from FEAT_*
// -1 is an invalid IP_CONST_FEAT
int GetIPFeatFromFeat(int nFeat)
{
    switch (nFeat)
    {
    case FEAT_ALERTNESS:
        return IP_CONST_FEAT_ALERTNESS;
    case FEAT_AMBIDEXTERITY:
        return IP_CONST_FEAT_AMBIDEXTROUS;
    case FEAT_ARMOR_PROFICIENCY_HEAVY:
        return IP_CONST_FEAT_ARMOR_PROF_HEAVY;
    case FEAT_ARMOR_PROFICIENCY_LIGHT:
        return IP_CONST_FEAT_ARMOR_PROF_LIGHT;
    case FEAT_ARMOR_PROFICIENCY_MEDIUM:
        return IP_CONST_FEAT_ARMOR_PROF_MEDIUM;
    case FEAT_CLEAVE:
        return IP_CONST_FEAT_CLEAVE;
    case FEAT_COMBAT_CASTING:
        return IP_CONST_FEAT_COMBAT_CASTING;
    case FEAT_DODGE:
        return IP_CONST_FEAT_DODGE;
    case FEAT_EXTRA_TURNING:
        return IP_CONST_FEAT_EXTRA_TURNING;
    case FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE:
        return IP_CONST_FEAT_IMPCRITUNARM;
    case FEAT_IMPROVED_KNOCKDOWN:
    case FEAT_KNOCKDOWN:
        return IP_CONST_FEAT_KNOCKDOWN;
    case FEAT_POINT_BLANK_SHOT:
        return IP_CONST_FEAT_POINTBLANK;
    case FEAT_POWER_ATTACK:
    case FEAT_IMPROVED_POWER_ATTACK:
        return IP_CONST_FEAT_POWERATTACK;
    case FEAT_SPELL_FOCUS_ABJURATION:
    case FEAT_EPIC_SPELL_FOCUS_ABJURATION:
    case FEAT_GREATER_SPELL_FOCUS_ABJURATION:
        return IP_CONST_FEAT_SPELLFOCUSABJ;
    case FEAT_SPELL_FOCUS_CONJURATION:
    case FEAT_EPIC_SPELL_FOCUS_CONJURATION:
    case FEAT_GREATER_SPELL_FOCUS_CONJURATION:
        return IP_CONST_FEAT_SPELLFOCUSCON;
    case FEAT_SPELL_FOCUS_DIVINATION:
    case FEAT_EPIC_SPELL_FOCUS_DIVINATION:
    case FEAT_GREATER_SPELL_FOCUS_DIVINIATION:
        return IP_CONST_FEAT_SPELLFOCUSDIV;
    case FEAT_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT:
    case FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT:
        return IP_CONST_FEAT_SPELLFOCUSENC;
    case FEAT_SPELL_FOCUS_EVOCATION:
    case FEAT_EPIC_SPELL_FOCUS_EVOCATION:
    case FEAT_GREATER_SPELL_FOCUS_EVOCATION:
        return IP_CONST_FEAT_SPELLFOCUSEVO;
    case FEAT_SPELL_FOCUS_ILLUSION:
    case FEAT_EPIC_SPELL_FOCUS_ILLUSION:
    case FEAT_GREATER_SPELL_FOCUS_ILLUSION:
        return IP_CONST_FEAT_SPELLFOCUSILL;
    case FEAT_SPELL_FOCUS_NECROMANCY:
    case FEAT_EPIC_SPELL_FOCUS_NECROMANCY:
    case FEAT_GREATER_SPELL_FOCUS_NECROMANCY:
        return IP_CONST_FEAT_SPELLFOCUSNEC;
    case FEAT_SPELL_PENETRATION:
    case FEAT_EPIC_SPELL_PENETRATION:
    case FEAT_GREATER_SPELL_PENETRATION:
        return IP_CONST_FEAT_SPELLPENETRATION;
    case FEAT_TWO_WEAPON_FIGHTING:
    case FEAT_IMPROVED_TWO_WEAPON_FIGHTING:
        return IP_CONST_FEAT_TWO_WEAPON_FIGHTING;
    case FEAT_WEAPON_FINESSE:
        return IP_CONST_FEAT_WEAPFINESSE;
    case FEAT_WEAPON_PROFICIENCY_EXOTIC:
        return IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
    case FEAT_WEAPON_PROFICIENCY_MARTIAL:
        return IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
    case FEAT_WEAPON_PROFICIENCY_SIMPLE:
        return IP_CONST_FEAT_WEAPON_PROF_SIMPLE;
    case FEAT_IMPROVED_UNARMED_STRIKE:
        return IP_CONST_FEAT_WEAPSPEUNARM;

    // Some undefined ones
    case FEAT_DISARM:
        return 28;
    case FEAT_HIDE_IN_PLAIN_SIGHT:
        return 31;
    case FEAT_MOBILITY:
        return 27;
    case FEAT_RAPID_SHOT:
        return 30;
    case FEAT_SHIELD_PROFICIENCY:
        return 35;
    case FEAT_SNEAK_ATTACK:
        return 32;
    case FEAT_USE_POISON:
        return 36;
    case FEAT_WHIRLWIND_ATTACK:
        return 29;
    case FEAT_WEAPON_PROFICIENCY_CREATURE:
        return 38;
        // whip disarm is 37
    }
    return (-1);
}

// Determines if the target creature has a certain type of spell
// and sets the powers onto the object item
void SetItemSpellPowers(object oItem, object oCreature)
{
    itemproperty iProp;
    int total_props = 0; //max of 8 properties on one item

    //first, auras--only want to allow one aura power to transfer
    if ( GetHasSpell(SPELLABILITY_AURA_BLINDING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(750,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(751,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_ELECTRICITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(752,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(753,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(754,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_MENACE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(755,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_PROTECTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(756,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(757,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNEARTHLY_VISAGE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(758,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_AURA_UNNATURAL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(759,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, bolts
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(760,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(761,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(762,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(763,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(764,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(765,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(766,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(767,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(768,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(769,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(770,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(771,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(772,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(773,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(774,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_KNOCKDOWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(775,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(776,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(777,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(778,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(779,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SHARDS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(780,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(781,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(782,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_BOLT_WEB, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(783,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //now, cones
    if ( GetHasSpell(SPELLABILITY_CONE_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(784,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(785,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(786,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(787,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(788,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(789,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_CONE_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(790,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //various petrify attacks
    if ( GetHasSpell(SPELLABILITY_BREATH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(791,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(792,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_TOUCH_PETRIFY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(793,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //dragon stuff (fear aura, breaths)
    if ( GetHasSpell(SPELLABILITY_DRAGON_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(796,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_ACID, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(400,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(401,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(402,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(403,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(404,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(405,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(698, oCreature) && (total_props <= 7) ) //NEGATIVE
    {
        iProp = ItemPropertyCastSpell(794,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_PARALYZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(406,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLEEP, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(407,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_SLOW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(408,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_DRAGON_BREATH_WEAKEN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(409,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(771, oCreature) && (total_props <= 7) ) //PRISMATIC
    {
        iProp = ItemPropertyCastSpell(795,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //gaze attacks
    if ( GetHasSpell(SPELLABILITY_GAZE_CHARM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(797,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_CONFUSION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(798,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(799,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(800,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_CHAOS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(801,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_EVIL, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(802,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_GOOD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(803,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DESTROY_LAW, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(804,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOMINATE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(805,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(806,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(807,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(808,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_GAZE_STUNNED, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(809,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //miscellaneous abilities
    if ( GetHasSpell(SPELLABILITY_GOLEM_BREATH_GAS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(810,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HELL_HOUND_FIREBREATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(811,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_KRENSHAR_SCARE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(812,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //howls
    if ( GetHasSpell(SPELLABILITY_HOWL_CONFUSE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(813,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DAZE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(814,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(815,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_DOOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(816,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_FEAR, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(817,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_PARALYSIS, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(818,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_SONIC, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(819,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_HOWL_STUN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(820,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //pulses
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CHARISMA, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(821,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_CONSTITUTION, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(822,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_DEXTERITY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(823,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_INTELLIGENCE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(824,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_STRENGTH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(825,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_ABILITY_DRAIN_WISDOM, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(826,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_COLD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(827,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DEATH, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(828,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DISEASE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(829,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_DROWN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(830,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_FIRE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(831,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_HOLY, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(832,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LEVEL_DRAIN, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(833,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_LIGHTNING, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(834,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_NEGATIVE, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(835,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_POISON, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(836,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_SPORES, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(837,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_PULSE_WHIRLWIND, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(838,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //monster summon abilities
    if ( GetHasSpell(SPELLABILITY_SUMMON_SLAAD, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(839,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(SPELLABILITY_SUMMON_TANARRI, oCreature) && (total_props <= 7) )
    {
        iProp = ItemPropertyCastSpell(840,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //abilities without const refs
    if ( GetHasSpell(552, oCreature) && (total_props <= 7) ) //PSIONIC CHARM
    {
        iProp = ItemPropertyCastSpell(841,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(551, oCreature) && (total_props <= 7) ) //PSIONIC MINDBLAST
    {
        iProp = ItemPropertyCastSpell(842,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(713, oCreature) && (total_props <= 7) ) //MINDBLAST 10M
    {
        iProp = ItemPropertyCastSpell(843,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(741, oCreature) && (total_props <= 7) ) //PSIONIC BARRIER
    {
        iProp = ItemPropertyCastSpell(844,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(763, oCreature) && (total_props <= 7) ) //PSIONIC CONCUSSION
    {
        iProp = ItemPropertyCastSpell(845,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(731, oCreature) && (total_props <= 7) ) //BEBILITH WEB
    {
        iProp = ItemPropertyCastSpell(846,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(736, oCreature) && (total_props <= 7) ) //BEHOLDER EYES
    {
        iProp = ItemPropertyCastSpell(847,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(770, oCreature) && (total_props <= 7) ) //CHAOS SPITTLE
    {
        iProp = ItemPropertyCastSpell(848,IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(757, oCreature) && (total_props <= 7) ) //SHADOWBLEND
    {
        iProp = ItemPropertyCastSpell(849,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ( GetHasSpell(774, oCreature) && (total_props <= 7) ) //DEFLECTING FORCE
    {
        iProp = ItemPropertyCastSpell(850,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    //some spell-like abilities
    if ((GetHasSpell(SPELL_DARKNESS,oCreature) ||
        GetHasSpell(SPELLABILITY_AS_DARKNESS,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DARKNESS_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_DISPLACEMENT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPLACEMENT_9,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if ((GetHasSpell(SPELLABILITY_AS_INVISIBILITY,oCreature) ||
        GetHasSpell(SPELL_INVISIBILITY,oCreature)) &&
        total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_INVISIBILITY_3,IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
    if (GetHasSpell(SPELL_WEB,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_WEB_3,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }
// Shifter should not get spells, even at epic levels
/*    if (GetHasSpell(SPELL_MAGIC_MISSILE,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_MAGIC_MISSILE_5,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FIREBALL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIREBALL_10,IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_CONE_OF_COLD,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CONE_OF_COLD_9,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_LIGHTNING_BOLT,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_LIGHTNING_BOLT_10,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_CURE_CRITICAL_WOUNDS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_CURE_CRITICAL_WOUNDS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HEAL,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HEAL_11,IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FINGER_OF_DEATH,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FINGER_OF_DEATH_13,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_FIRE_STORM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_FIRE_STORM_13,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HAMMER_OF_THE_GODS,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HAMMER_OF_THE_GODS_12,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_GREATER_DISPELLING,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_GREATER_DISPELLING_7,IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_DISPEL_MAGIC,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_10,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
/*    if (GetHasSpell(SPELL_HARM,oCreature) && total_props <= 7)
    {
        iProp = ItemPropertyCastSpell(IP_CONST_CASTSPELL_HARM_11,IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY);
        AddItemProperty(DURATION_TYPE_PERMANENT,iProp,oItem);
        total_props++;
    }*/
}


// Determines the level of the shifter class needed to take on
// oTargets shape.
// Returns 1-10 for Shifter level
// 1000 means they can never take the shape
int GetShifterLevelRequired(object oTarget)
{
    // Target Information
    int nTSize = GetCreatureSize(oTarget);
    int nTRacialType = MyPRCGetRacialType(oTarget);

    int nLevelRequired = 0;

    // Size validation
    switch (nTSize)
    {
    case CREATURE_SIZE_HUGE:
        if (nLevelRequired < 7)
            nLevelRequired = 7;
        break;
    case CREATURE_SIZE_TINY:
    case CREATURE_SIZE_LARGE:
        if (nLevelRequired < 3)
            nLevelRequired = 3;
        break;
    case CREATURE_SIZE_MEDIUM:
    case CREATURE_SIZE_SMALL:
        if (nLevelRequired < 1)
            nLevelRequired = 1;
        break;
    }

    // Type validation
    switch (nTRacialType)
    {
    case RACIAL_TYPE_FEY:
    case RACIAL_TYPE_SHAPECHANGER:
        nLevelRequired = 1000;
        break;
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_ELEMENTAL:
        if (nLevelRequired < 9)
            nLevelRequired = 9;
        break;
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_UNDEAD:
        if (nLevelRequired < 8)
            nLevelRequired = 8;
        break;
    case RACIAL_TYPE_DRAGON:
        if (nLevelRequired < 7)
            nLevelRequired = 7;
        break;
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_OOZE:
        if (nLevelRequired < 6)
            nLevelRequired = 6;
        break;
    case RACIAL_TYPE_MAGICAL_BEAST:
        if (nLevelRequired < 5)
            nLevelRequired = 5;
        break;
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_VERMIN:
        if (nLevelRequired < 4)
            nLevelRequired = 4;
        break;
    case RACIAL_TYPE_BEAST:
//    case RACIAL_TYPE_PLANT:
        if (nLevelRequired < 3)
            nLevelRequired = 3;
        break;
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
        if (nLevelRequired < 2)
            nLevelRequired = 2;
        break;
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
        // all level 1 forms
        if (nLevelRequired < 1)
            nLevelRequired = 1;
        break;
    }
    if (GetHasFeat(SHIFTER_BLACK_LIST,oTarget))
	{
		nLevelRequired = 1000;
	}
    return nLevelRequired;
}

// Can the shifter (oPC) assume the form of the target
// return Values: TRUE or FALSE
int GetValidShift(object oPC, object oTarget)
{
    int iInvalid = 0;

    // Valid Monster?
    if (!GetIsObjectValid(oTarget))
        return FALSE;
    // Valid PC
    if (!GetIsObjectValid(oPC))
        return FALSE;

    // Cant mimic a PC
    if (GetIsPC(oTarget))
        return FALSE;

    // Target Information
    int nTHD = GetHitDice(oTarget);

    // PC Info
    int nPCHD = GetHitDice(oPC);
    int nPCShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);

    // Check the shifter level required
    int nPCShifterLevelsRequired = GetShifterLevelRequired(oTarget);
    if (nPCShifterLevel < nPCShifterLevelsRequired)
    {
        if (nPCShifterLevelsRequired == 1000)
        {
            SendMessageToPC(oPC,"You can never take on that form" );
            return FALSE;
        }
        else
            SendMessageToPC(oPC,"You need " + IntToString(nPCShifterLevelsRequired-nPCShifterLevel) + " more shifter levels before you can take on that form" );
        iInvalid = 1;
    }

    // HD check (cant take any form that has more HD then the shifter)
    if (nTHD > nPCHD)
    {
        SendMessageToPC(oPC,"You need " + IntToString(nTHD-nPCHD) + " more character levels before you can take on that form" );
        iInvalid = 1;
    }

    //if checks failed return false
    if (iInvalid == 1)
    {
        //this way both of the texts come up if they are needed
        //so you dont just get 1 if your need both
        return FALSE;
    }
    //else if all checks past return true
    return TRUE;

}

// Determine if the oCreature has the ability to cast spells
// Return values: TRUE or FALSE
int GetCanFormCast(object oCreature)
{
    int nTRacialType = MyPRCGetRacialType(oCreature);

    // Need to have hands, and the ability to speak

    switch (nTRacialType)
    {
    case RACIAL_TYPE_ABERRATION:
    case RACIAL_TYPE_MAGICAL_BEAST:
    case RACIAL_TYPE_VERMIN:
    case RACIAL_TYPE_BEAST:
    case RACIAL_TYPE_ANIMAL:
    case RACIAL_TYPE_OOZE:
//    case RACIAL_TYPE_PLANT:
        // These forms can't cast spells
        return FALSE;
        break;
    case RACIAL_TYPE_SHAPECHANGER:
    case RACIAL_TYPE_ELEMENTAL:
    case RACIAL_TYPE_DRAGON:
    case RACIAL_TYPE_OUTSIDER:
    case RACIAL_TYPE_UNDEAD:
    case RACIAL_TYPE_CONSTRUCT:
    case RACIAL_TYPE_GIANT:
    case RACIAL_TYPE_HUMANOID_MONSTROUS:
    case RACIAL_TYPE_DWARF:
    case RACIAL_TYPE_ELF:
    case RACIAL_TYPE_GNOME:
    case RACIAL_TYPE_HALFELF:
    case RACIAL_TYPE_HALFLING:
    case RACIAL_TYPE_HALFORC:
    case RACIAL_TYPE_HUMAN:
    case RACIAL_TYPE_HUMANOID_ORC:
    case RACIAL_TYPE_HUMANOID_REPTILIAN:
    case RACIAL_TYPE_FEY:
        break;
    }

    return TRUE;
}

// Translastes a creature name to a resref for use in createobject
// returns a resref string
string GetResRefFromName(object oPC, string sName)
{
    //now that i have added the name of the criter to the spark
    //i have changed this function to search that list for a match
    object oMimicForms = GetItemPossessedBy( oPC, "sparkoflife" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int i;
    string cmp;

    for ( i=0; i<num_creatures; i++ )
    {
        cmp = GetLocalArrayString( oMimicForms, "shift_choice_name", i );
        if ( TestStringAgainstPattern( cmp, sName ) )
        {
            return GetLocalArrayString( oMimicForms, "shift_choice", i );

        }
    }
    return "";
}

// Determines if the oCreature is harmless enough to have
// special effects applied to the shifter
// Return values: TRUE or FALSE
int GetIsCreatureHarmless(object oCreature)
{
    string sCreatureName = GetName(oCreature);

    // looking for small < 1 CR creatures that nobody looks at twice

    if ((sCreatureName == "Chicken") ||
        (sCreatureName == "Falcon") ||
        (sCreatureName == "Hawk") ||
        (sCreatureName == "Raven") ||
        (sCreatureName == "Bat") ||
        (sCreatureName == "Dire Rat") ||
        (sCreatureName == "Will-O'-Wisp") ||
        (sCreatureName == "Rat") ||
        (GetChallengeRating(oCreature) < 1.0 ))
        return TRUE;
    else
        return FALSE;
}

int GetTrueForm(object oPC)
{
    int nRace = GetRacialType(OBJECT_SELF);
    int nPCForm;
    switch (nRace)
    {
    case RACIAL_TYPE_DWARF:
        nPCForm = APPEARANCE_TYPE_DWARF;
        break;
    case RACIAL_TYPE_ELF:
        nPCForm = APPEARANCE_TYPE_ELF;
        break;
    case RACIAL_TYPE_GNOME:
        nPCForm = APPEARANCE_TYPE_GNOME;
        break;
    case RACIAL_TYPE_HALFELF:
        nPCForm = APPEARANCE_TYPE_HALF_ELF;
        break;
    case RACIAL_TYPE_HALFLING:
        nPCForm = APPEARANCE_TYPE_HALFLING;
        break;
    case RACIAL_TYPE_HALFORC:
        nPCForm = APPEARANCE_TYPE_HALF_ORC;
        break;
    case RACIAL_TYPE_HUMAN:
        nPCForm = APPEARANCE_TYPE_HUMAN;
        break;
    }
    return nPCForm;
}


// Transforms the oPC into the oTarget using the epic rules
// Assumes oTarget is already a valid target
int SetShiftEpic(object oPC, object oTarget)
{

    SetLocalInt(oPC,"EpicShift",1); //this makes the setshift_3 script do the epic shifter stuff that used to be here

    SetShift(oPC, oTarget);

    return TRUE;
}


// Creates a temporary creature for the shifter to shift into
// Validates the shifter is able to become that creature based on level
// Return values: TRUE or FALSE
// the epic version of this script was rolled into this 1 with the
// addition of the iEpic peramiter
int SetShiftFromTemplateValidate(object oPC, string sTemplate, int iEpic)
{
	if (!CanShift(oPC))
	{
		return FALSE;
	}
    int bRetValue = FALSE;
    int in_list = IsKnownCreature( oPC, sTemplate );

    if (iEpic==TRUE)
    {
        if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1, oPC))
            return FALSE;
        else
            DecrementRemainingFeatUses(oPC,FEAT_PRESTIGE_SHIFTER_EGWSHAPE_1); //we are good to go with the shift
    }
    else
    {
        if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC))
            return FALSE;
        else
            DecrementRemainingFeatUses(oPC,FEAT_PRESTIGE_SHIFTER_GWSHAPE_1); //we are good to go with the shift
    }
    if (!GetHasFeat(FEAT_PRESTIGE_SHIFTER_GWSHAPE_1, oPC))  //if your out of GWS
    {
        if (GetHasFeat(FEAT_WILD_SHAPE, oPC)) //and you have DWS left
        {
            if(GetLocalInt(oPC, "DWS") == 1) //and you wont to change then over to GWS
            {
                IncrementRemainingFeatUses(oPC,FEAT_PRESTIGE_SHIFTER_GWSHAPE_1); // +1 GWS
                DecrementRemainingFeatUses(oPC,FEAT_WILD_SHAPE); //-1 DWS
            }
        }
    }
    int i=0;
    object oLimbo=GetObjectByTag("Limbo",i);
    location lLimbo;
    while (i < 100)
    {
        if (GetIsObjectValid(oLimbo))
        {
            if (GetName(oLimbo)=="Limbo")
            {
                i = 2000;
                vector vLimbo = Vector(0.0f, 0.0f, 0.0f);
                lLimbo = Location(oLimbo, vLimbo, 0.0f);
            }
        }
        i++;
        object oLimbo=GetObjectByTag("Limbo",i);
    }
    object oTarget;
    if (i>=2000)
    {
        oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,lLimbo);
    }
    else
    {
        oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));
    }
    // Create the obj from the template
//    object oTarget = CreateObject(OBJECT_TYPE_CREATURE,sTemplate,GetLocation(oPC));

    if (!GetIsObjectValid(oTarget))
    {
        SendMessageToPC(oPC,"Not a valid creature");
    }
    if ( !in_list )
    {
        SendMessageToPC( oPC, "You have not mimiced this creature yet" );
    }

    // Make sure the PC can take on that form
    if (GetValidShift(oPC, oTarget) && in_list )
    {
        //get the appearance before changing it
        SetLocalInt(oTarget,"Appearance",GetAppearanceType(oTarget));
        //set appearance to invis so it dont show up when scripts run thro
        SetCreatureAppearanceType(oTarget,APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
        //set oTarget for deletion
        SetLocalInt(oTarget,"pnp_shifter_deleteme",1);
        //Shift the PC to it
        bRetValue = TRUE;
        if (iEpic==TRUE)
            SetShiftEpic (oPC, oTarget);
        else
            SetShift(oPC,oTarget);
    }
    return bRetValue;
}


// Transforms the oPC back to thier true form if they are shifted
void SetShiftTrueForm(object oPC)
{
    // Remove all the creature equipment and destroy it
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
    object oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    object oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);

    // Do not move or destroy the objects, it will crash the game
    if (GetIsObjectValid(oHide))
    {
        // Remove all the abilities of the object
        ScrubPCSkin(oPC,oHide);
//        RemoveAllItemProperties(oHide);
    // Debug
        //CopyItem(oHide,oPC,TRUE);
    }

    if (GetIsObjectValid(oWeapCR))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCR);
    }
    if (GetIsObjectValid(oWeapCL))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCL);
    }
    if (GetIsObjectValid(oWeapCB))
    {
        // Remove all the abilities of the object
        RemoveAllItemProperties(oWeapCB);
    }
    // if the did an epic form remove the special powers
    object oEpicPowersItem = GetItemPossessedBy(oPC,"EpicShifterPowers");
    if (GetIsObjectValid(oEpicPowersItem))
    {
        RemoveAllItemProperties(oEpicPowersItem);
        RemoveAuraEffect( oPC );
    }


    // Spell failure was done through an effect
    // AC was done via an effect
    // invis was done via an effect
    // we will look for and remove them
    effect eEff = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEff))
    {
        int eDurType = GetEffectDurationType(eEff);
        int eSubType = GetEffectSubType(eEff);
        int eType = GetEffectType(eEff);
        //all three effects are permanent and supernatural
        if ((eDurType == DURATION_TYPE_PERMANENT) && (eSubType == SUBTYPE_SUPERNATURAL) )
        {
            switch (eType)
            {
                case EFFECT_TYPE_SPELL_FAILURE:
                case EFFECT_TYPE_INVISIBILITY:
                case EFFECT_TYPE_AC_INCREASE:
                    RemoveEffect(oPC,eEff);
                    break;
            }
        }
        if (eType == EFFECT_TYPE_POLYMORPH)
        {
        	RemoveEffect(oPC,eEff);
        }
        eEff = GetNextEffect(oPC);
    }

    // Change the PC back to TRUE form
    SetCreatureAppearanceType(oPC,GetTrueForm(oPC));
    // Set race back to unused
    SetLocalInt(oPC,"RACIAL_TYPE",0);

	// Reset any PRC feats that might have been lost from the shift
	EvalPRCFeats(oPC);
	SetLocalInt(oHide,"nPCShifted",FALSE);

}


