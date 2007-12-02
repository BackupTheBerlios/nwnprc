
#include "prc_inc_dragsham"
#include "prc_compan_inc"
#include "pnp_shft_poly"

void main()
{
	// Create a new skin on the PC.
	object oArmor = GetPCSkin(OBJECT_SELF);
	int nDSLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN);
	
	// For Draconic Resolve
	if(GetHasFeat(FEAT_DRAGONSHAMAN_RESOLVE, OBJECT_SELF))
	{
		IPSafeAddItemProperty(oArmor, 
	          ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	        IPSafeAddItemProperty(oArmor, 
	          ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SLEEP), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	        IPSafeAddItemProperty(oArmor, 
	          ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), 
	          0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}
	
	
	// For Draconic Armor - Since this has several steps, use nested loop		
	if(GetHasFeat(FEAT_DRAGONSHAMAN_ARMOR, OBJECT_SELF))
	{
		if(nDSLevel >= 37)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 7, ITEM_PROPERTY_AC_BONUS);
		}
		else if(nDSLevel >= 32)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 6, ITEM_PROPERTY_AC_BONUS);
		}
		else if(nDSLevel >= 27)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 5, ITEM_PROPERTY_AC_BONUS);
		}
		else if(nDSLevel >= 22)
		{
			// AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(3), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 4, ITEM_PROPERTY_AC_BONUS);
		}
		else if(nDSLevel >= 17)
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
			//AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(1), oArmor);
			SetCompositeBonus(oArmor, "ScaleThicken", 1, ITEM_PROPERTY_AC_BONUS);
		}
	}
	
	//For Energy Immunity
	if(GetHasFeat(FEAT_DRAGONSHAMAN_ENERGY_IMMUNITY, OBJECT_SELF))
	{
		if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_FIRE)
		{
			IPSafeAddItemProperty(oArmor, 
	                 ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	                 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_ELECTRICAL)
		{
			IPSafeAddItemProperty(oArmor, 
	                 ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	                 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_ACID)
		{
			IPSafeAddItemProperty(oArmor, 
	                 ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ACID, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	                 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
		else if(GetDragonDamageType(OBJECT_SELF) == DAMAGE_TYPE_COLD)
		{
			IPSafeAddItemProperty(oArmor, 
	                 ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), 
	                 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
		}
	}
	
	//For the wings
	int nWingType = CREATURE_WING_TYPE_DRAGON;
        if(GetPRCSwitch(MARKER_PRC_COMPANION))
        {
            nWingType = GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, OBJECT_SELF)     ? PRC_COMP_WING_TYPE_DRAGON_BLACK :
                        GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, OBJECT_SELF)      ? PRC_COMP_WING_TYPE_DRAGON_BLUE :
                        GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, OBJECT_SELF)     ? PRC_COMP_WING_TYPE_DRAGON_BRASS :
                        GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, OBJECT_SELF)    ? PRC_COMP_WING_TYPE_DRAGON_BRONZE :
                        GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, OBJECT_SELF)    ? PRC_COMP_WING_TYPE_DRAGON_COPPER :
                        GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, OBJECT_SELF)      ? PRC_COMP_WING_TYPE_DRAGON_GOLD :
                        GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, OBJECT_SELF)     ? PRC_COMP_WING_TYPE_DRAGON_GREEN :
                        GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, OBJECT_SELF)    ? PRC_COMP_WING_TYPE_DRAGON_SILVER :
                        GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, OBJECT_SELF)     ? PRC_COMP_WING_TYPE_DRAGON_WHITE :
                        GetHasFeat(FEAT_DRAGONSHAMAN_RED, OBJECT_SELF)       ? CREATURE_WING_TYPE_DRAGON :
                        CREATURE_WING_TYPE_NONE;
         }
         if(GetHasFeat(FEAT_DRAGONSHAMAN_WINGS, OBJECT_SELF))
         {
             SetCompositeBonus(oArmor, "WingBonus", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
             DoWings(OBJECT_SELF, nWingType);
         }
}