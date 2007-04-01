/*
   ----------------
   Clinging Shadow Strike

   tob_sdhd_clngshd
   ----------------

   31/03/07 by Stratovarius
*/ /** @file

    Clinging Shadow Strike

    Shadow Hand (Strike)
    Level: Swordsage 1
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature
    Saving Throw: Fortitude Partial.

    You weapon transforms into solid darkness. When it strikes home,
    it discharges in a swirling orb of shadow that engulfs your foe's eyes.
    
    Your attack deals an additional 1d6 damage. If the foe fails a Fort save vs 11 + Wisdom modifier
    the foe suffers a 20% miss chance for one round.
    This is a supernatural maneuver.
*/

#include "tob_inc_tobfunc"
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
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	int nDamage = d6();
    	int nDamageType = DAMAGE_TYPE_MAGICAL;
    	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, nDamage, nDamageType, FALSE, "Sapphire Nightmare Blade Hit", "Sapphire Nightmare Blade Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (11 + GetAbilityModifier(ABILITY_WISDOM, oInitiator)))
    		{
			effect eLink = ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_HEAD_EVIL));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			eLink = ExtraordinaryEffect(EffectMissChance(20));
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
		}
        }
    }
}