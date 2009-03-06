#include "tob_inc_move"
#include "tob_movehook"
#include "prc_alterations"
#include "inc_newspellbook"

// Helper functions
void DoDamage(object oInitiator, int nDice, int nClass)
{
	if(DEBUG) DoDebug("Got to AOE damage");

	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator), FALSE, OBJECT_TYPE_CREATURE, GetPosition(oInitiator));
        if(DEBUG) DoDebug("tob_jpm_fireb: First target is: " + DebugObject2Str(oTarget));

	while(GetIsObjectValid(oTarget))
	{
		if(oTarget != oInitiator)
		{
			int nDamage = d6(nDice);
			int nDC = 14 + GetAbilityModifier(GetAbilityScoreForClass(nClass, oInitiator));

			nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE);

			effect eLink = EffectDamage(nDamage/2, DAMAGE_TYPE_FIRE);
				eLink = EffectLinkEffects(eLink, EffectDamage(nDamage/2, DAMAGE_TYPE_MAGICAL));
				eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_FLAME_M));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
		}
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator), FALSE, OBJECT_TYPE_CREATURE, GetPosition(oInitiator));
        if(DEBUG) DoDebug("tob_jpm_fireb: Next target is: " + DebugObject2Str(oTarget));
	}
}

void DoLoop(object oInitiator, int nDice, int nClass)
{
	if(DEBUG) DoDebug("Dice: " + IntToString(nDice));
	DelayCommand(RoundsToSeconds(10), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(9), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(8), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(7), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(6), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(5), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(4), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(3), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(2), DoDamage(oInitiator, nDice, nClass));
	DelayCommand(RoundsToSeconds(1), DoDamage(oInitiator, nDice, nClass));
}

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
	int nDice;
	int nSpellId 	     = GetLocalInt(oInitiator, "JPM_SPELL_CURRENT");  // Spell to be sacrificed
	int nRealSpellId     = (UseNewSpellBook(oInitiator)) ? GetLocalInt(oInitiator, "JPM_REAL_SPELL_CURRENT") : nSpellId;
	int nID 	     = GetSpellId();  //spell being cast
	struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

	if(DEBUG) DoDebug(IntToString(move.bCanManeuver));
	if(move.bCanManeuver)
	{
		if(DEBUG) DoDebug("PRCGetSpellUsesLeft: " + IntToString(PRCGetSpellUsesLeft(nRealSpellId, oInitiator)));    	
		// See if they want augmented stance
		if(nID = JPM_SPELL_FIREBIRD_AUGMENTED && PRCGetSpellUsesLeft(nRealSpellId, oInitiator) >= 1)
		{
			int nClass = GetFirstArcaneClass(oInitiator);

			if(DEBUG) DoDebug("UseNewSpellBook: " + IntToString(UseNewSpellBook(oInitiator)));    	
			if(UseNewSpellBook(oInitiator))
			{
				nDice  = GetSpellLevel(oInitiator , nSpellId, nClass);
				if(DEBUG) DoDebug("nDice: " + IntToString(nDice));

				if(DEBUG) DoDebug("RemoveSpellUse nSpellId: " + IntToString(nRealSpellId) + " class: " + IntToString(nClass));
				RemoveSpellUse(oInitiator, nSpellId, nClass);
				DoLoop(oInitiator, nDice, nClass);
			}
			else
			{
				nDice = PRCGetSpellLevel(oInitiator, nSpellId);
				if(DEBUG) DoDebug("nDice: " + IntToString(nDice));

				if(DEBUG) DoDebug("nSpellId: " + IntToString(nSpellId));
				PRCDecrementRemainingSpellUses(oInitiator, nSpellId);
			}
			DoLoop(oInitiator, nDice, nClass);
		}
		// This adds 3 caster levels when using a fire spell
		SetLocalInt(oInitiator, "ToB_JPM_FireB", TRUE);

		effect eLink = EffectLinkEffects(EffectDamageResistance(DAMAGE_TYPE_FIRE, 10), EffectVisualEffect(VFX_DUR_ROOTED_TO_SPOT));
		       eLink = ExtraordinaryEffect(eLink);

		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}