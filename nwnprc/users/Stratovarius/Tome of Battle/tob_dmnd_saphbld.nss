/*
   ----------------
   Sapphire Nightmare Blade

   tob_dmnd_saphbld
   ----------------

   04/09/07 by Tenjac
*/ /** @file Sapphire Nightmare Blade

Diamond Mind (Strike)
Level: Swordsage 1, Warblade 1
Initiation Action: 1 Standard Action
Range: Melee Attack
Target: One Creature

You study your enemy for a brief moment, watching his defensive
maneuvers and making a strike timed to take advantage of a lull in his vigilance.

The sapphire nightmare blade is one of the most basic, but important,
maneuvers that a Diamond Mind adept studies. It illustrates that a
keen mind can pierce even the toughest defenses.

You attempt a Concentration check as part of this maneuver, using the
target creature's AC as the DC of the check. You then make a single
melee attack against your target. The attack is also part of this 
maneuver.  If your Concentration check succeeds, the target is flat-footed
against your attack, and you deal an extra 1d6 points of damage. If your check
fails, your attack is made with a -2 penalty and deals normal damage.
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
        int nDC = GetDefenderAC(oTarget, oInitiator);
        int nAB = -2;
        if (GetIsSkillSuccessful(oInitiator, SKILL_CONCENTRATION, nDC)) 
        {
                nAB = 0;
                AssignCommand(oTarget, ClearAllActions(TRUE));
                PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, 0, 0, FALSE, "Sapphire Nightmare Blade Hit", "Sapphire Nightmare Blade Miss");
        }
    }
}