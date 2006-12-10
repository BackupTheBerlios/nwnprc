
#include "prc_inc_dragsham"

void main()
{
	// Clear the current PCSkin to remove any existing bonuses.
	RemovePCSkin();
	// Create a new skin on the PC.
	object oArmor = GetPCSkin();
	int nDSLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN);
	
	// For Draconic Resolve
	if(GetHasFeat(FEAT_DRAGONSHAMAN_RESOLVE, OBJECT_SELF))
	{
		if(GetLocalInt(oArmor, "DraconicResolve") == TRUE)
			return;
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oArmor);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP), oArmor);
		AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), oArmor);
		SetLocalInt(oArmor, "DraconicResolve", TRUE);
	}
	
	// For Draconic Armor - Since this has several steps, use nested loop		
	if(GetHasFeat(FEAT_DRAGONSHAMAN_ARMOR, OBJECT_SELF))
	{
		if(nDSLevel >= 17)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 3, ITEM_PROPERTY_AC_BONUS);
		}
		else if(nDSLevel >= 12)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(2), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 2, ITEM_PROPERTY_AC_BONUS);			
		}
		else
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 1, ITEM_PROPERTY_AC_BONUS);
		}
	}
	if(GetHasFeat(FEAT_DRAGONSHAMAN_ENERGY_IMMUNITY, OBJECT_SELF))
	{
		if(GetLocalInt(oArmor, "DraconicImmunity") == TRUE)
			return;
		if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_FIRE)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), oArmor);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_ELECTRICAL)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), oArmor);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_ACID)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), oArmor);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_COLD)
		{
			AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), oArmor);
		}
		SetLocalInt(oArmor, "DraconicImmunity", TRUE);
	}
}