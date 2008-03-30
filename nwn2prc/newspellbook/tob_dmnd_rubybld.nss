/*
   ----------------
   Ruby Nightmare Blade

   tob_dmnd_rubybld
   ----------------

   19/08/07 by Stratovarius
*/ /** @file

    Ruby Nightmare Blade

    Diamond Mind (Strike)
    Level: Swordsage 4, Warblade 4
    Prerequisite: Two Diamond Mind Maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    With a moment's thought, you instantly perceive the deadliest place to strike your enemy
    as you study her defences, note gaps in her armour, and read subtle but important clues
    in how she carries herself or maintains her fighting stance.
    
    You make a Concentration check against the target's AC. If you succeed, the target
    takes double normal damage. If you fail, you take a -2 penalty on the attack.
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
        	SetLocalInt(oTarget, "NightmareBlade", 2);
        }
	PerformAttack(oTarget, oInitiator, eNone, 0.0, nAB, 0, 0, "Ruby Nightmare Blade Hit", "Ruby Nightmare Blade Miss");
	DelayCommand(1.0, DeleteLocalInt(oTarget, "NightmareBlade"));
    }
}