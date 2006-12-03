//\/////////////////////////////////////////////////////////////////////////////
//
//  nwn2_inc_spells
//
//  Spell related utility functions for NWN2
//
//  (c) Obsidian Entertainment Inc., 2005
//
//\/////////////////////////////////////////////////////////////////////////////
// 10/23/06 - BDF(OEI): modified ApplyHostileSongEffectsToArea() to never affect
//	friendlies, regardless of Hardcore difficulty

#include "nw_i0_spells"
#include "x0_i0_spells"
#include "nwn2_inc_metmag" // JLR - OEI 08/24/05 -- Metamagic changes

// AFW-OEI 05/09/2006: String Ref constants for various text feedback for spells.
int STR_REF_FEEDBACK_SPELL_FAILED		=  3734;
int STR_REF_FEEDBACK_SPELL_INVALID_TARGET	= 83384;
int STR_REF_FEEDBACK_NO_MORE_TURN_ATTEMPTS	= 40550;
int STR_REF_FEEDBACK_NO_MORE_BARDSONG_ATTEMPTS = 85587;

const float METEOR_SWARM_SPELL_DURATION = 6.0;
const string RESREF_DEFAULT_WAYPOINT = "nw_waypoint001";

	
string GenerateUniqueSpellDCString( int nSpellID, object oCaster )
{
    return "NWN2_SPELL_SAVE_DC_" + IntToString(nSpellID) + GetName(oCaster);
}


void SaveDelayedSpellInfo( int nSpellID, object oTarget, object oCaster, int nDC )
{
	SetLocalInt( oTarget, GenerateUniqueSpellDCString(nSpellID, oCaster), nDC );
}

void RemoveDelayedSpellInfo( int nSpellID, object oTarget, object oCaster )
{
    DeleteLocalInt( oTarget, GenerateUniqueSpellDCString(nSpellID, oCaster) );
}

int GetDelayedSpellInfoSaveDC( int nSpellID, object oTarget, object oCaster )
{
	return GetLocalInt( oTarget, GenerateUniqueSpellDCString(nSpellID, oCaster) );
}


void RemoveSpellEffectsFromCaster( int nSpellID, object oTarget, object oCaster, int bMagicalEffectsOnly = TRUE )
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        if (GetEffectSpellId(eEff) == nSpellID)
        {
            if (GetEffectSubType(eEff) != SUBTYPE_MAGICAL && bMagicalEffectsOnly)
            {
                // ignore
            }
            else
            {
                RemoveEffect(oTarget,eEff);
            }
        }
        eEff = GetNextEffect(oTarget);
    }
}

//\/////////////////////////////////////////////////////////////////////////////
// HasSizeIncreasingSpellEffect
//\/////////////////////////////////////////////////////////////////////////////
// Created By:   Brock Heinz
// Created On:   08/10/05
// Description: 
// Argument: 
// Returns
//\/////////////////////////////////////////////////////////////////////////////
int HasSizeIncreasingSpellEffect( object oTarget )
{
	if ( GetHasSpellEffect( SPELL_ENLARGE_PERSON, oTarget ) )
		return TRUE;

	if ( GetHasSpellEffect( SPELL_RIGHTEOUS_MIGHT, oTarget ) )
		return TRUE;

	return FALSE;
}


//\/////////////////////////////////////////////////////////////////////////////
// IsTargetValidForDelayedSpellEffect
//\/////////////////////////////////////////////////////////////////////////////
// Created By:   Brock Heinz
// Created On:   08/10/05
// Description: 
// Argument: 
// Returns
//\/////////////////////////////////////////////////////////////////////////////
int IsTargetValidForDelayedSpellEffect( int nSpellID, object oTarget, object oCaster )
{
    if ( !GetHasSpellEffect(nSpellID, oTarget) )
    {
        RemoveDelayedSpellInfo( nSpellID, oTarget, oCaster );
        return FALSE;
    }

    if( !GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget) )
    {
        RemoveDelayedSpellInfo( nSpellID, oTarget, oCaster );
        return FALSE;
    }

    if ( GetIsDead(oCaster) || GetIsDead(oTarget) )
    {
        RemoveDelayedSpellInfo( nSpellID, oTarget, oCaster );
        return FALSE;
    }

    return TRUE;
}

// -------------------------------------------------------------------
// General math helpers
int ClampInt( int nValue, int nMin, int nMax )
{
    if ( nValue < nMin )
        return nMin;

    if ( nValue > nMax )
        return nMax;

    return nValue;
}


float ClampFloat( float flValue, float flMin, float flMax )
{
    if ( flValue < flMin )
        return flMin;

    if ( flValue > flMax )
        return flMax;

    return flValue;
}
// -------------------------------------------------------------------






void RemovePermanencySpells(object oTarget)
{
    // We are applying a new Spell:Permanency Effect, get rid of any old ones!
    int nMetaMagic = GetMetaMagicFeat();
    if ( nMetaMagic & METAMAGIC_PERMANENT )
    {
        RemoveEffectsFromSpell(oTarget, SPELL_BLINDSIGHT);
        RemoveEffectsFromSpell(oTarget, SPELL_DARKVISION);
        RemoveEffectsFromSpell(oTarget, SPELL_ENDURE_ELEMENTS);
        RemoveEffectsFromSpell(oTarget, SPELL_ENLARGE_PERSON);
        RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);
        // Alignment is tricky, because it is a master spell...
//        RemoveEffectsFromSpell(oTarget, SPELL_PROTECTION_FROM_ALIGNMENT);
        RemoveEffectsFromSpell(oTarget, SPELL_PROTECTION_FROM_EVIL);
        RemoveEffectsFromSpell(oTarget, SPELL_PROTECTION_FROM_GOOD);
        RemoveEffectsFromSpell(oTarget, SPELL_PROTECTION_FROM_ARROWS);
        RemoveEffectsFromSpell(oTarget, SPELL_RESISTANCE);
        RemoveEffectsFromSpell(oTarget, SPELL_SEE_INVISIBILITY);
    }
}

	


// Callback for DispelMagicWithCallback called 
// from Devour Magic
void DevourDispelCallback( object oCaster )
{
	int 	nHitpoints 	= GetCasterLevel(oCaster) * 2;
	effect	eHitPoints 	= EffectTemporaryHitpoints( nHitpoints );
	float	fDuration 	= 1.0f * 60.0f; // 1 minute
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHitPoints, oCaster, fDuration);
}


// Callback for DispelMagicWithCallback called 
// from Voracious Dispelling
void VoraciousDispelCallback( object oTarget, object oCaster )
{
	int		nDamage	= GetCasterLevel( oCaster ) / 2;
	effect	eDmg	= EffectDamage( nDamage );
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
}

void NullDispelCallback()
{
	// I wish we could pass NULL as actions
}

///////////////////////////////////////////////////////////////////////////////
// PilferMagicCallback
///////////////////////////////////////////////////////////////////////////////
// Created By:	Andrew Woo (AFW-OEI)
// Created On:	08/07/2006
// Description:  Callback for DispelMagicWithCallback called from Pilfer Magic.
///////////////////////////////////////////////////////////////////////////////
void PilferMagicCallback( object oCaster )
{
	effect eAttackBonus = EffectAttackIncrease(2);
	effect eSaveBonus   = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
	effect eLink	    = EffectLinkEffects(eAttackBonus, eSaveBonus);
	float  fDuration 	= RoundsToSeconds(10); // 10 rounds
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
}

///////////////////////////////////////////////////////////////////////////////
// DispelMagicWithCallback
///////////////////////////////////////////////////////////////////////////////
// Created By:	Brock Heinz
// Created On:	09/06/2005
// Description:  This is a modified form of spellsDispelMagic(). That function 
//	has a built in random delay, which we don't want. However, we DO want to
//  run some other functions if any spells are removed
///////////////////////////////////////////////////////////////////////////////
void DispelMagicWithCallback( object oTarget, object oCaster, int nCasterLevel, effect eVis, effect eImpac, int bAll, int nSpellID )
{
    //--------------------------------------------------------------------------
    // Don't dispel magic on petrified targets
    // this change is in to prevent weird things from happening with 'statue'
    // creatures. Also creature can be scripted to be immune to dispel
    // magic as well.
    //--------------------------------------------------------------------------
    if ( GetHasEffect(EFFECT_TYPE_PETRIFY, oTarget) == TRUE || 
		 GetLocalInt(oTarget, "X1_L_IMMUNE_TO_DISPEL") == 10)
    {
        return;
    }

    effect eDispel;

    //--------------------------------------------------------------------------
    // Fire hostile event only if the target is hostile, OR if we will be 
	// damaging it... 
    //--------------------------------------------------------------------------
	if (nSpellID != SPELL_I_DEVOUR_MAGIC)	// Devour Magic is not hostile, everything else can be.
	{
	    if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	    {
	
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));
	    }
	    else
	    {
	        SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
	    }
	}
	
    //--------------------------------------------------------------------------
    // Unfortunately, you can't pass an action as a parameter in a user 
	// function, so we have to be somewhat retarded about this....
    //--------------------------------------------------------------------------
	switch ( nSpellID )
	{
		case SPELL_I_VORACIOUS_DISPELLING:
			if (bAll == TRUE )        eDispel = EffectDispelMagicAll(nCasterLevel, VoraciousDispelCallback( oTarget, oCaster ) );
		    else				      eDispel = EffectDispelMagicBest(nCasterLevel, VoraciousDispelCallback( oTarget, oCaster ) );
			break;
		case SPELL_I_DEVOUR_MAGIC:
			if (bAll == TRUE )        eDispel = EffectDispelMagicAll(nCasterLevel, DevourDispelCallback( oCaster ) );
		    else				      eDispel = EffectDispelMagicBest(nCasterLevel, DevourDispelCallback( oCaster ) );
			break;
		case SPELLABILITY_PILFER_MAGIC:	// Pilfer magic only takes out a single effect.
			eDispel = EffectDispelMagicBest(nCasterLevel, PilferMagicCallback(oCaster));
			break;
		default:
			if (bAll == TRUE )        eDispel = EffectDispelMagicAll(nCasterLevel, NullDispelCallback() );
		    else				      eDispel = EffectDispelMagicBest(nCasterLevel, NullDispelCallback() );
			break;
    }

    

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);
}


///////////////////////////////////////////////////////////////////////////////
// GetCanBardSing
///////////////////////////////////////////////////////////////////////////////
// Created By:	Brock Heinz
// Created On:	09/09/2005
// Description:	Used to determine if the bard can use a song feat. If s/he 
//				can, it returns TRUE. If s/he can't, it will display an
//				error string and return FALSE;
///////////////////////////////////////////////////////////////////////////////
int GetCanBardSing( object oBard )
{
    if ( GetHasEffect(EFFECT_TYPE_SILENCE, oBard))
    {
        FloatingTextStrRefOnCreature(85764, oBard); // * You can not use this feat while silenced *
        return FALSE;
    }

    if ( GetHasEffect(EFFECT_TYPE_PARALYZE, oBard)	||
 		 GetHasEffect(EFFECT_TYPE_STUNNED, oBard)	||
		 GetHasEffect(EFFECT_TYPE_SLEEP, oBard)		||
		 GetHasEffect(EFFECT_TYPE_PETRIFY, oBard) )
		
	{
 		FloatingTextStrRefOnCreature(112849, oBard ); // * You can not use this feat at this time *
		return FALSE;
	}

	return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
// GetIsObjectValidSongTarget
///////////////////////////////////////////////////////////////////////////////
// Created By:	Brock Heinz
// Created On:	09/09/2005
// Description:	Used to determine if the object is a valid target for a song. 
//				Note that this only checks to see if they can hear the bard
//				If s/he can, it returns TRUE. If s/he can't, it will return 
//				FALSE;
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: added the check to see if the target is dead
int GetIsObjectValidSongTarget( object oTarget )
{
 
    if (GetHasEffect(EFFECT_TYPE_DEAF,OBJECT_SELF))
    {
		// it can't hear me
        return FALSE;
    }

	if ( GetRacialType( oTarget ) == RACIAL_TYPE_INVALID )	
	{
		// It's a harmonica
		return FALSE;	
	}

	if ( GetIsDead(oTarget) )	
	{
		return FALSE;
	}

	return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
// ApplySongDurationFeatMods
///////////////////////////////////////////////////////////////////////////////
// Created By:	Brock Heinz
// Created On:	09/09/2005
// Description:	Returns a modified duration (assumed to be rounds), based
//				any feats or other items the bard has
///////////////////////////////////////////////////////////////////////////////
int ApplySongDurationFeatMods( int nDuration, object oBard )
{

    if(GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(FEAT_LINGERING_SONG)) 
    {
        nDuration += 5;
    }

	return nDuration;
}


///////////////////////////////////////////////////////////////////////////////
// GetHasMatchingEffect
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/06/2006:
// Description:	Find an Effect that matches given info...
///////////////////////////////////////////////////////////////////////////////
int GetHasMatchingEffect( int nEffectType, int nEffectSubType, object oTarget = OBJECT_SELF )
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffectType)
        {
             return TRUE;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}


///////////////////////////////////////////////////////////////////////////////
// FindEffectSpellId
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/06/2006:
// Description:	Find the Effect matching a type, and return the associated SpellId...
///////////////////////////////////////////////////////////////////////////////
int FindEffectSpellId( int nEffectType, object oTarget = OBJECT_SELF )
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffectType)
        {
             return GetEffectInteger(eCheck, 0);
        }
        eCheck = GetNextEffect(oTarget);
    }
    return -1;
}


///////////////////////////////////////////////////////////////////////////////
// RemoveBardSongSingingEffect
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/11/2006:
// Description:	Find the singing effect if it exists, and destroy it
///////////////////////////////////////////////////////////////////////////////
void RemoveBardSongSingingEffect( object oTarget, int nSpellId )
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == EFFECT_TYPE_BARDSONG_SINGING)
        {
             if(GetEffectInteger(eCheck, 0) == nSpellId)
             {
                 RemoveEffect(oTarget, eCheck);
                 return;
             }
        }
        eCheck = GetNextEffect(oTarget);
    }
}


///////////////////////////////////////////////////////////////////////////////
// AttemptNewSong
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/06/2006:
// Description:	Remove old Song if there is one...
///////////////////////////////////////////////////////////////////////////////
int AttemptNewSong( object oCaster, int bIsPersistent = FALSE )
{
    int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING, oCaster);

    // First, try to break the old one...
    if(nSingingSpellId != -1)
    {
        // Remove it...
        RemoveBardSongSingingEffect(oCaster, nSingingSpellId);
    }

    if(bIsPersistent)
    {
        // Only start it up if we weren't cancelling it...
        if(nSingingSpellId != GetSpellId())
        {
            // Now add new singing Effect
            effect eBardSong = EffectBardSongSinging(GetSpellId());
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBardSong, oCaster);
            return TRUE;
        }
        return FALSE;
    }

    return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
// ApplyFriendlySongEffectsToArea
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/05/2006:
// Description:	Does the actual application of linked effects to targets
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with GetIsObjectValidSongTarget
//::	which unifies those checks into a single function; added spellsIsTarget for filtering targets
void ApplyFriendlySongEffectsToArea( object oCaster, int nSpellId, float fDuration, float fRadius, effect eLink )
{
    //int nLevel      = GetLevelByClass(CLASS_TYPE_BARD);
    //SpeakString("Level: " + IntToString(nLevel) + " Ranks: " + IntToString(nRanks));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
		
	// AFW-OEI 07/17/2006: Because the caster will already have the EFFECT_BARDSONG_SINGING
	//	effect on him, we need to do some shenanigans to see if that's the only effect
	//	w/ that bardsong ID.  If it is, we need to apply the bonuses for the first time.
	int bCasterAlreadyHasBardsongEffects = FALSE;
	effect eCheck = GetFirstEffect(oCaster);
	while(GetIsEffectValid(eCheck))
	{
		if (GetEffectSpellId(eCheck) == nSpellId &&
			GetEffectType(eCheck) != EFFECT_TYPE_BARDSONG_SINGING)
		{
			//SpeakString("nwn2_inc_spells::ApplyFriendlySongEffectToArea(): Has bardsong effects other than BARDSONG_SINGING.");	// DEBUG
			bCasterAlreadyHasBardsongEffects = TRUE;
			break;
		}
		eCheck = GetNextEffect(oCaster);
	}
	
    while(GetIsObjectValid(oTarget))
    {
		//if ( !GetIsDead(oTarget) )	// 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
        	if( (!GetHasSpellEffect(nSpellId,oTarget)) || 
				(oTarget == oCaster && !bCasterAlreadyHasBardsongEffects) )
	        {
	             //if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))	// this check is now taken care of in GetIsObjectValidSongTarget
	             //{
					//if(oTarget == oCaster || GetIsFriend(oTarget) || GetFactionEqual(oTarget))
					if ( spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) )
	                {
		                //Fire cast spell at event for the specified target
		                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
	                    eLink = SetEffectSpellId( eLink, nSpellId );
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                }
	            //}
	        }
	        else
	        {
	            // Refresh the duration
	            RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
	        }
		}
	    oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    }
}


///////////////////////////////////////////////////////////////////////////////
// ApplyFriendlySongEffectsToParty
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/06/2006:
// Description:	Does the actual application of linked effects to the entire party
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with GetIsObjectValidSongTarget
//::	which unifies those checks into a single function 
void ApplyFriendlySongEffectsToParty( object oCaster, int nSpellId, float fDuration, effect eLink )
{
    object oLeader = GetFactionLeader( oCaster );
    int bPCOnly    = FALSE;
    object oTarget = GetFirstFactionMember( oLeader, bPCOnly );
    while ( GetIsObjectValid( oTarget ) )
    {
		//if ( !GetIsDead(oTarget) )	// 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
	        //if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
	        //{
	            if(!GetHasSpellEffect(nSpellId,oTarget))
	            {
	                //Fire cast spell at event for the specified target
	                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
	
	                //Apply the VFX impact and effects
	                eLink            = SetEffectSpellId( eLink, nSpellId );
	                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
	            }
	            else
	            {
	                // Refresh the duration, *IFF doesn't already have the effect!*
	                RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
	            }
	        //}
		}
		
        oTarget = GetNextFactionMember( oLeader, bPCOnly );
    }
}


///////////////////////////////////////////////////////////////////////////////
// ApplyFriendlySongEffectsToTarget
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/06/2006:
// Description:	Does the actual application of linked effects to a specific target
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with GetIsObjectValidSongTarget
//::	which unifies those checks into a single function; added spellsIsTarget for filtering targets
void ApplyFriendlySongEffectsToTarget( object oCaster, int nSpellId, float fDuration, effect eLink )
{
    object oTarget = GetSpellTargetObject();

    effect eVis    = ExtraordinaryEffect( EffectVisualEffect(VFX_DUR_BARD_SONG) );

    effect eImpact = ExtraordinaryEffect( EffectVisualEffect(VFX_IMP_HEAD_SONIC) );
    effect eFNF    = ExtraordinaryEffect( EffectVisualEffect(VFX_FNF_LOS_NORMAL_30) );
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(oCaster));

    if(GetIsObjectValid(oTarget))
    {
		//if ( !GetIsDead(oTarget) )	// 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
	        if(!GetHasSpellEffect(nSpellId,oTarget))
	        {
	             //if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
	             //{
	                //Fire cast spell at event for the specified target
	                SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
	
	                if(oTarget == oCaster)
	                {
	                    effect eLinkBard = ExtraordinaryEffect( EffectLinkEffects(eLink, eVis) );
	                    eLinkBard        = SetEffectSpellId( eLinkBard, nSpellId );
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkBard, oTarget, fDuration);
	                }
	                //else if(GetIsFriend(oTarget) || GetFactionEqual(oTarget))
					else if ( spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster) )
	                {
	                    eLink            = SetEffectSpellId( eLink, nSpellId );
	                    eImpact          = SetEffectSpellId( eImpact, nSpellId );
	                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
	                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                }
	            //}
	        }
	        else
	        {
	            // Refresh the duration
	            RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
	        }
		}
    }
}


///////////////////////////////////////////////////////////////////////////////
// ApplyHostileSongEffectsToArea
///////////////////////////////////////////////////////////////////////////////
// Created By:	Jesse Reynolds (JLR-OEI)
// Created On:	04/05/2006:
// Description:	Does the actual application of linked effects to targets
///////////////////////////////////////////////////////////////////////////////
//:: 8/14/06 - BDF-OEI: replaced some conditionals with GetIsObjectValidSongTarget
//::	which unifies those checks into a single function; added spellsIsTarget for filtering targets
///////////////////////////////////////////////////////////////////////////////
//:: 10/23/06 - BDF-OEI: changed the filter parameter in spellsIsTarget from
//		STANDARDHOSTILE to SELECTIVEHOSTILE; the old way was applying effects
//		to friendlies in Hardcore difficulty, but that's not really what
//		bard songs are all about.
void ApplyHostileSongEffectsToArea( object oCaster, int nSpellId, float fDuration, float fRadius, effect eLink, int nSaveType = -1, int nSaveDC = 0 )
{
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));

    while(GetIsObjectValid(oTarget))
    {
		//if ( !GetIsDead(oTarget) )	// 7/31/06 - BDF: added this check to avoid applying effects to corpses
		if ( GetIsObjectValidSongTarget(oTarget) )
		{
	        if(!GetHasSpellEffect(nSpellId,oTarget))
	        {
	             //if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
	             //{
	                //if(!GetIsFriend(oTarget) && !GetFactionEqual(oTarget))
					if ( spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster) )	// 10/23/06 - BDF(OEI): was STANDARDHOSTILE
	                {
	                    //Fire cast spell at event for the specified target
	                    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellId, FALSE));
	
	                    // Make Save to negate
	                    if ((nSaveType == -1) || !MySavingThrow(nSaveType, oTarget, nSaveDC ))
	                    {
	                        eLink            = SetEffectSpellId( eLink, nSpellId );
	                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	                    }
	                }
	            //}
	        }
	        else
	        {
	            // Refresh the duration
	            RefreshSpellEffectDurations(oTarget, nSpellId, fDuration);
	        }
		}
		
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    }
}

// 7/13/06 - BDF: this helper function takes care of the default graphical appearance of the spell Meteor Swarm; 
void ExecuteDefaultMeteorSwarmBehavior( object oTarget, location lTarget )
{
	// Major variables
	location lCaster = GetLocation( OBJECT_SELF );
    int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;
    effect eVis = EffectVisualEffect( VFX_HIT_SPELL_METEOR_SWARM );
	float fTravelTime;
	float fLocationDistance;
	location lAhead, lBehind, lLeft, lRight, lFlankingLeft, lFlankingRight, lAheadLeft, lAheadRight;
	object oAheadWP, oBehindWP, oLeftWP, oRightWP, oFlankingLeftWP, oFlankingRightWP, oAheadLeftWP, oAheadRightWP;
	int bDestroyoTarget = FALSE;
	
	if ( !GetIsObjectValid(oTarget) )	// Just in case the object that was passed isn't valid (i.e. when targeting the ground)
	{
		// Create the waypoint that will act as the centerpoint for the projectile swarm
		oTarget = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lTarget );
		bDestroyoTarget = TRUE;
	}
	
	float fDelay = 6.0f / IntToFloat(8);	// 6.0 is the duration of the bombardment; 
											// 8 is the number of meteors that will spawn regardless of targets
	float fDelay2 = 0.0f;
		
	lAhead = GetAheadLocation( oTarget );
	lBehind = GetBehindLocation( oTarget );
	lRight = GetRightLocation( oTarget );
	lLeft = GetLeftLocation( oTarget );
	lAheadLeft = GetAheadLeftLocation( oTarget );
	lAheadRight = GetAheadRightLocation( oTarget );
	lFlankingLeft = GetFlankingLeftLocation( oTarget );
	lFlankingRight = GetFlankingRightLocation( oTarget );

	fTravelTime = GetProjectileTravelTime( lCaster, lAhead, nPathType );
	oAheadWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lAhead );
	DelayCommand( fDelay2, SpawnSpellProjectile(OBJECT_SELF, oAheadWP, lCaster, lAhead, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAhead) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lBehind, nPathType );
	oBehindWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lBehind );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oBehindWP, lCaster, lBehind, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lBehind) );	
	
	fTravelTime = GetProjectileTravelTime( lCaster, lLeft, nPathType );
	oLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oLeftWP, lCaster, lLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLeft) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lRight, nPathType );
	oRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lRight );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oRightWP, lCaster, lRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lRight) );

	fTravelTime = GetProjectileTravelTime( lCaster, lAheadLeft, nPathType );
	oAheadLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lAheadLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oAheadLeftWP, lCaster, lAheadLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAheadLeft) );

	fTravelTime = GetProjectileTravelTime( lCaster, lAheadRight, nPathType );
	oAheadRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lAheadLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oAheadRightWP, lCaster, lAheadRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lAheadRight) );

	fTravelTime = GetProjectileTravelTime( lCaster, lFlankingLeft, nPathType );
	oFlankingLeftWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lFlankingLeft );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oFlankingLeftWP, lCaster, lFlankingLeft, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lFlankingLeft) );
	
	fTravelTime = GetProjectileTravelTime( lCaster, lFlankingRight, nPathType );
	oFlankingRightWP = CreateObject( OBJECT_TYPE_WAYPOINT, RESREF_DEFAULT_WAYPOINT, lFlankingRight );
	DelayCommand( (fDelay2 += fDelay), SpawnSpellProjectile(OBJECT_SELF, oFlankingRightWP, lCaster, lFlankingRight, SPELL_METEOR_SWARM, nPathType) );
	DelayCommand( (fDelay2 + fTravelTime), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lFlankingRight) );
	
	// Cleanup the placeholder waypoints
	if ( bDestroyoTarget )	
	{
		DelayCommand( (fDelay2 += 0.1f), DestroyObject(oTarget) );
	}
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oBehindWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oRightWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oFlankingLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oFlankingRightWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadLeftWP) );
	DelayCommand( (fDelay2 += 0.1f), DestroyObject(oAheadRightWP) );
}

// 7/13/06 - BDF: this helper function determine the number of meteors to spawn; 
int GetNumMeteorSwarmProjectilesToSpawnA( location lCenterOfAOE )
{
	float fRadiusSize;
	int i;
	int nCounter = 0;	
	location lTargetLocation;
	object oTarget;
		
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lCenterOfAOE );
		
	while ( GetIsObjectValid(oTarget) )
	{
		lTargetLocation = GetLocation(oTarget);	
		
		if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5))
			{			
				if ( GetDistanceBetweenLocations(lTargetLocation, lCenterOfAOE) <= (RADIUS_SIZE_VAST / 3.0f) )
				{
					nCounter = nCounter + 2;
					SetLocalInt(oTarget, "MeteorSwarmCentralTarget", 1);
				}
				
				else if ( GetDistanceBetweenLocations(lTargetLocation, lCenterOfAOE) <= (RADIUS_SIZE_VAST / 2.0f) )
				{
					nCounter = nCounter+1;
					SetLocalInt(oTarget, "MeteorSwarmNormalTarget", 1);					
				}
				
				else
				{
					nCounter++;						
				}					
			}	
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_VAST, lCenterOfAOE );
	}
		
	if ( nCounter == 0 )	
	{
		return 1;
	}
		
	return nCounter;
}

int GetNumMeteorSwarmProjectilesToSpawnB( location lCenterOfAOE )
{
	float fRadiusSize;
	int i;
	int nCounter = 0;	
	location lTargetLocation;
	object oTarget;
		
	oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lCenterOfAOE );
			
	while ( GetIsObjectValid(oTarget) )
	{
		if ( spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
		{
			if (!MyResistSpell(OBJECT_SELF, oTarget, 0.5))
			{
				if ( GetLocation(OBJECT_SELF) == lCenterOfAOE )
				{	
					if (GetDistanceBetween(oTarget, OBJECT_SELF) > 2.0)
					{
            			nCounter++;
					}
				}
										
				else
				{
					nCounter++;
				}					
			}	
		}
		
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, lCenterOfAOE );	
	}
		
	if ( nCounter == 0 )	
	{
		return 1;
	}
			
	return nCounter;
}

///////////////////////////////////////////////////////////////////////////////
// ApplyFatigue
///////////////////////////////////////////////////////////////////////////////
// Created By:	Andrew Woo (AFW-OEI)
// Created On:	08/08/2006
// Description:	Applies a "fatigue" effect to the target (oTarget), which lasts
//	nFatigueDuration rounds.  You can delay the fatigue application by fDelay
//	seconds.
///////////////////////////////////////////////////////////////////////////////
void ApplyFatigue(object oTarget, int nFatigueDuration, float fDelay = 0.0f)
{
	//SpeakString("Entering ApplyFatigue");

	// Only apply fatigue ifyou're not resting.
	// This is to keep you from getting fatigued if you rest while raging.
	if( !GetIsResting() )
	{
		//SpeakString("Actually applying fatigue effect in ApplyFatigue");
		
		// Create the fatigue penalty
		effect eFatigueStrPenalty = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
		effect eFatigueDexPenalty = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
		effect eFatigueMovePenalty = EffectMovementSpeedDecrease(10);	// 10% decrease
		
		effect eFatigue = EffectLinkEffects (eFatigueStrPenalty, eFatigueDexPenalty);
		eFatigue = EffectLinkEffects(eFatigue, eFatigueMovePenalty);
		eFatigue = ExtraordinaryEffect(eFatigue);
		
		float fFatigueDuration = RoundsToSeconds(nFatigueDuration);
		
		DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFatigue, oTarget, fFatigueDuration));
	}
}
//void main() {}