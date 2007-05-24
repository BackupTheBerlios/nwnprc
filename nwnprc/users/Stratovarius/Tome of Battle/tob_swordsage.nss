//::///////////////////////////////////////////////
//:: Swordsage class abilities
//:: tob_swordsage.nss
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: May 15, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
	int nArmour = GetItemACBase(oArmour);
	int nClass = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);

	if (GetLevelByClass(CLASS_TYPE_MONK, oPC) > 0)
	{
		SetCompositeBonus(oSkin, "SwordsageACBonus", 0, ITEM_PROPERTY_AC_BONUS);
	//	SendMessageToPC(oPC, "Setting to 0. Disabled.");
	}
	else if ((4 > nArmour && nArmour > 0) && nClass >= 2) // Light Armour only
	{
		SetCompositeBonus(oSkin, "SwordsageACBonus", GetAbilityModifier(ABILITY_WISDOM, oPC), ITEM_PROPERTY_AC_BONUS);
	}
}