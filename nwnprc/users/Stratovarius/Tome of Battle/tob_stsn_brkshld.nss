/*
   ----------------
   Strike of the Broken Shield

   tob_stsn_brkshld
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Strike of the Broken Shield

    Setting Sun (Strike)
    Level: Swordsage 4
    Prerequisite: Two Setting Sun maneuvers
    Initiation Action: 1 Standard action
    Range: Melee Attack.
    Target: One Creature.
    Save: Reflex partial; see text

    You study your opponent and deliver an attack precisely aimed to ruin his defenses
    and force him to scramble for balance. While he struggles to ready himself, he becomes
    more vulnerable to your attack.
    
    You make an attack that deals 4d6 extra damage. If it connects, the target must save or be 
    flatfooted for one round.
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
    	effect eNone;
    	
	PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, d6(4), 0, FALSE, "Strike of the Broken Shield Hit", "Strike of the Broken Shield Miss");
	if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
    	{
    		// Saving Throw
    		if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (14 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator)))
    		{
			AssignCommand(oTarget, ClearAllActions(TRUE));
		}
        }
    }
}