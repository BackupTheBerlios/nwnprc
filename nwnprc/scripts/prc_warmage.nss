#include "prc_alterations"

// Armour and Shield combined, up to Medium/Light shield.
void ReducedASF(object oCreature)
{
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
	object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
	object oSkin = GetPCSkin(oCreature);
	int nAC = GetBaseAC(oArmor);
	int nClass = GetLevelByClass(CLASS_TYPE_WARMAGE, oCreature);
	int iBonus = GetLocalInt(oSkin, "WarmageArmourCasting");
	int nASF = -1;
	itemproperty ip;
	
	// First thing is to remove old ASF (in case armor is changed.)
	if (iBonus != -1)
		RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, iBonus, 1, "WarmageArmourCasting");
	
	// As long as they meet the requirements, just give em max ASF reduction
	// I know it could cause problems if they have increased ASF, but thats unlikely
	if (5 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD && nClass >= 8)
		nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;	
	else if (3 >= nAC && GetBaseItemType(oShield) != BASE_ITEM_TOWERSHIELD && GetBaseItemType(oShield) != BASE_ITEM_LARGESHIELD && nClass >= 1)
		nASF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;			

	// Apply the ASF to the skin.
	ip = ItemPropertyArcaneSpellFailure(nASF); 
	
	AddItemProperty(DURATION_TYPE_PERMANENT, ip, oSkin);
	SetLocalInt(oSkin, "WarmageArmourCasting", nASF);
}  

void main()
{
	object oPC = OBJECT_SELF;

	// Warmage can cast in light/Medium armour.
	if (GetIsPC(oPC)) ReducedASF(oPC);
}
