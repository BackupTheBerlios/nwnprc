#include "prc_spell_const"
#include "prc_sp_func"
#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nSpellID = GetLocalInt(oPC, "EF_SPELL_CURRENT");
	effect eNone;

	// should be in melee range
	if (!GetIsInMeleeRange(oTarget, oPC))
	{
		SendMessageToPC(oPC, "You are not close enough to your target to attack!");
		// move into range so we can attack next round
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}

	if (!GetIsUnarmed(oPC))
	{
		SendMessageToPC(oPC, "You need to be unarmed for this ability!");
		// be nice and have you get a normal full attack round
		PerformAttackRound(oTarget, oPC, eNone);
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}
	
	if (!PRCGetHasSpell(nSpellID, oPC))
	{
		SendMessageToPC(oPC, "No uses or preperations left for selected spell!");
		// be nice and have you get a normal full attack round
		PerformAttackRound(oTarget, oPC, eNone);
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}

	if (!IsTouchSpell(nSpellID) && !GetHasFeat(FEAT_EF_HOLD_RAY, oPC))
	{
		SendMessageToPC(oPC, "Selected spell is not a touch spell!");
		// be nice and have you get a normal full attack round
		PerformAttackRound(oTarget, oPC, eNone);
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}

	if (!IsTouchSpell(nSpellID) && !IsRaySpell(nSpellID) && GetHasFeat(FEAT_EF_HOLD_RAY, oPC))
	{
		SendMessageToPC(oPC, "Selected spell is not a touch or ray spell!");
		// be nice and have you get a normal full attack round
		PerformAttackRound(oTarget, oPC, eNone);
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}
		
	// expend stunning fist use
	if (!ExpendStunfistUses(oPC, 1))
	{
		// be nice and have you get a normal full attack round
		PerformAttackRound(oTarget, oPC, eNone);
		AssignCommand(oPC, ActionAttack(oTarget));
		return;
	}
	
	// expend spell use
	PRCDecrementRemainingSpellUses(oPC, nSpellID);

	// setup for holding the charge
	int iOldHold = GetLocalInt(oPC, PRC_SPELL_HOLD);
	int iOldHoldRay = GetLocalInt(oPC, "PRC_SPELL_HOLD_RAY");
	SetLocalInt(oPC, PRC_SPELL_HOLD, TRUE);
	SetLocalInt(oPC, "PRC_EF_ARCANE_FIST", TRUE);
	SetLocalInt(oPC, PRC_CASTERCLASS_OVERRIDE, GetFirstArcaneClass(oPC));

	SendMessageToPC(oPC, "Arcane Fist:" + IntToString(nSpellID));

	// run spell script to hold charge
	RunImpactScript(oPC, nSpellID, 0);

	SetLocalInt(oPC, PRC_SPELL_HOLD, iOldHold);
	DeleteLocalInt(oPC, "PRC_EF_ARCANE_FIST");
	DeleteLocalInt(oPC, PRC_CASTERCLASS_OVERRIDE);

	PerformAttackRound(oTarget, oPC, eNone);
	AssignCommand(oPC, ActionAttack(oTarget, TRUE));
}
