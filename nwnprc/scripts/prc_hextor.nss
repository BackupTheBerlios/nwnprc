//::///////////////////////////////////////////////
//:: Fist of Hextor
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"


/// Applies the Fist of Hextor Damage ///
void AddBrutalStrikeDam(object oPC)
{
	int iDam;



	if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
	{
	iDam = DAMAGE_BONUS_4;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
	{
	iDam = DAMAGE_BONUS_3;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
	{
	iDam = DAMAGE_BONUS_2;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
	{
	iDam = DAMAGE_BONUS_1;
	}

	if(GetLocalInt(oPC, "HexBSDam") == iDam) return;
	effect eDam = EffectDamageIncrease(iDam, DAMAGE_TYPE_NEGATIVE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oPC, HoursToSeconds(24));
	SetLocalInt(oPC, "HexBSDam", iDam);
}


/// Applies the Fist of Hextor Attack ///
void AddBrutalStrikeAtk(object oPC)
{
	int iAtk;



	if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
	{
	iAtk = 4;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
	{
	iAtk = 3;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
	{
	iAtk = 2;
	}
	else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
	{
	iAtk = 1;
	}

	if(GetLocalInt(oPC, "HexBSAtk") == iAtk) return;
	effect eAtk = EffectAttackIncrease(iAtk);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtk, oPC, HoursToSeconds(24));
	SetLocalInt(oPC, "HexBSAtk", iAtk);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    AddBrutalStrikeDam(oPC);
    AddBrutalStrikeAtk(oPC);

}