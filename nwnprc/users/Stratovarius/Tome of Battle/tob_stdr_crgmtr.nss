/*
   ----------------
   Charging Minotaur

   tob_stdr_crgmtr
   ----------------

   30/03/07 by Stratovarius
*/ /** @file

    Charging Minotaur

    Stone Dragon (Strike)
    Level: Crusader 1, Swordsage 1, Warblade 1
    Initiation Action: 1 Full-Round Action
    Range: Melee Attack
    Target: One Creature

    You charge at your foe, blasting him with such power that he stumbles back.
    
    Make a Bull Rush attack as part of a charge. You take no AoOs for this action.
    If you succeed on the strength check, you deal 2d6 + Str bludgeoning damage,
    and the target is pushed back 5 feet, and possibly more.
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
    	// Charge and Bull rush are all taken care of in this function
	int nSucceed = DoCharge(oInitiator, oTarget, FALSE, FALSE, TRUE, 0, FALSE, FALSE);
	if (nSucceed)
	{
		// Deal the damage
		effect eDamage = EffectDamage(d6(2) + GetAbilityModifier(ABILITY_STRENGTH, oInitiator), DAMAGE_TYPE_BLUDGEONING);
		effect eLink = (eDamage, EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
	}
    }
}