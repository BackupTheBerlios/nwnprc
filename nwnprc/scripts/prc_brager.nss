//::///////////////////////////////////////////////
//:: Battlerager
//:: prc_brager.nss
//:://////////////////////////////////////////////
//:: Applies Ferocious Prowess Bonus
//:://////////////////////////////////////////////
//:: Created By: Lockindal
//:: Created On: July 23, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"

void AddFerociousProwess(object oPC)
{
	int iAtk = 1;
	int iDam = 1;
	
	if(GetHasFeat(FEAT_FEROCIOUS_PROW, oPC))
	{
		effect eDam = EffectDamageIncrease(iDam, DAMAGE_TYPE_NEGATIVE);
		effect eAtk = EffectAttackIncrease(iAtk);
	
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oPC, HoursToSeconds(24));
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtk, oPC, HoursToSeconds(24));
		SetLocalInt(oPC, "BRageProw", iAtk);
	}
}

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int iEquip = GetLocalInt(oPC, "ONEQUIP");
    
	AddFerociousProwess(oPC);
}
