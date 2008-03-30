/*
   ----------------
   Fool's Strike

   tob_stsn_folstrk
   ----------------

   05/12/07 by Stratovarius
*/ /** @file

    Fool's Strike

    Setting Sun (Counter)
    Level: Swordsage 8
    Prerequisite: Three Setting Sun maneuvers
    Initiation Action: 1 swift action
    Range: Melee attack
    Target: One creature

    A creature strikes, but you turn the blow straight back at it.
    
    Make an opposed attack roll against the targeted creature. If you succeed, he damages himself rather than you.
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
    	object oInitWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
    	object oTargetWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
    	int nBase   = GetBaseAttackBonus(oTarget);
    	SetBaseAttackBonus(nBase - 1, oTarget);
    	if (DEBUG) DoDebug("tob_stsn_folstrk: GetBaseAttackBonus returns " + IntToString(nBase));
    	int nInit   = GetAttackBonus(oTarget, oInitiator, oInitWeap) + d20();
    	int nTarget = GetAttackBonus(oInitiator, oTarget, oTargetWeap) + d20();
    	
	if (nInit >= nTarget)
    	{
		// Deal damage to himself
		effect eDam = GetAttackDamage(oTarget, oTarget, oInitWeap, GetWeaponBonusDamage(oTargetWeap, oTarget), GetMagicalBonusDamage(oTarget));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);		
        }
        else
        {
		// Foes attacks as normal     
		PerformAttack(oInitiator, oTarget, eNone, 0.0, 0, 0, 0, "Hit", "Miss");
        }
        
        DelayCommand(6.0, RestoreBaseAttackBonus(oTarget));
    }
}