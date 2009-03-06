#include "tob_inc_move"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
	if (!PreManeuverCastCode())
	{
		// If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
		return;
	}

	// End of Spell Cast Hook

	object oInitiator    = OBJECT_SELF;
	object oTarget       = PRCGetSpellTargetObject();
	int nLevel;
	int nSpellId 	     = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");  // Spell to be sacrificed
	int nRealSpellId     = (UseNewSpellBook(oInitiator)) ? GetLocalInt(oInitiator, "JPM_REAL_SPELL_CURRENT") : nSpellId;
	int nID 	     = GetSpellId();  //spell being cast
	struct maneuver move = EvaluateManeuver(oInitiator, oTarget);


	if(DEBUG) DoDebug(IntToString(move.bCanManeuver));
	if(move.bCanManeuver)
	{
		// This adds 1 caster level to all spells
		SetLocalInt(oInitiator, "ToB_JPM_MystP", 1);

		effect eLink = EffectLinkEffects(EffectACIncrease(2, AC_DODGE_BONUS), EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));

		if(nID = MOVE_MYSTIC_PHOENIX_AUG && PRCGetSpellUsesLeft(nRealSpellId, oInitiator) >= 1)
		{
			if(DEBUG) DoDebug("PRCGetSpellUsesLeft: " + IntToString(PRCGetSpellUsesLeft(nSpellId, oInitiator)));    	
			if(UseNewSpellBook(oInitiator))
			{
				int nClass  = GetFirstArcaneClass(oInitiator);
				nLevel  = GetSpellLevel(oInitiator , nSpellId, nClass);
				//AMS function
				if(DEBUG) DoDebug("RemoveSpellUse nSpellId: " + IntToString(nRealSpellId) + " class: " + IntToString(nClass));
				RemoveSpellUse(oInitiator, nSpellId, nClass);
			}
			else
			{
				nLevel = PRCGetSpellLevel(oInitiator, nSpellId);
				if(DEBUG) DoDebug("nSpellId: " + IntToString(nSpellId));
				PRCDecrementRemainingSpellUses(oInitiator, nSpellId);			
			}
			if(nLevel > 5) nLevel = 5;
			effect eRed  = EffectDamageReduction(nLevel * 2, DAMAGE_POWER_NORMAL);
			eLink = EffectLinkEffects(VersusAlignmentEffect(eRed, ALIGNMENT_ALL, ALIGNMENT_GOOD), eLink);
			eLink = EffectLinkEffects(VersusAlignmentEffect(eRed, ALIGNMENT_ALL, ALIGNMENT_NEUTRAL), eLink);
		}

		eLink = ExtraordinaryEffect(eLink);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}