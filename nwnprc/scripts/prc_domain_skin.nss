// Written by Stratovarius
// Applies the cast domain feats to the hide

#include "prc_inc_domain"

void AddDomainPower(object oPC, object oSkin)
{
	if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WAR_DOMAIN        ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_STRENGTH_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PROTECTION_DOMAIN ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DEATH_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC))		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DESTRUCTION_DOMAIN),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC))		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EVIL_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_GOOD_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HEALING_DOMAIN    ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_KNOWLEDGE_DOMAIN  ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SUN_DOMAIN        ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TRAVEL_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DARKNESS_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_METAL_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_STORM_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DWARF_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ORC_DOMAIN        ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TIME_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CHARM_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME, oPC))		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLS_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RUNE_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FATE_DOMAIN       ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DOMINATION_DOMAIN ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_UNDEATH_DOMAIN    ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE, oPC))		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FAMILY_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HALFLING_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ILLUSION_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HATRED_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_NOBILITY_DOMAIN   ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RETRIBUTION_DOMAIN),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_GNOME_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ELF_DOMAIN        ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RENEWAL_DOMAIN    ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS, oPC)) 		AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TYRANNY_DOMAIN    ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC)) 	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ),oSkin);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC))	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_BLIGHTBRINGER     ),oSkin);
}



void main()
{

	object oPC = OBJECT_SELF;
    	object oSkin = GetPCSkin(oPC);
    	
    	FloatingTextStringOnCreature("PRC Domain Skin is running", oPC, FALSE);
    
    	// The prereq variables use 0 as true and 1 as false, becuase they are used in class prereqs
    	// It uses allspell because there are some feats that allow a wizard or other arcane caster to take domains.
    	if (!GetHasFeat(FEAT_CHECK_DOMAIN_SLOTS))
    	{
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CHECK_DOMAIN_SLOTS),oSkin);
    	    FloatingTextStringOnCreature("The PC does not have Check Domain Slots, adding", oPC, FALSE);
    	}
    	if (GetLocalInt(oPC, "PRC_AllSpell1") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_ONE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_ONE),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell2") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_TWO))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_TWO),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell3") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_THREE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_THREE),oSkin);   
    	if (GetLocalInt(oPC, "PRC_AllSpell4") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FOUR))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FOUR),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell5") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FIVE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FIVE),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell6") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SIX))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SIX),oSkin);  
    	if (GetLocalInt(oPC, "PRC_AllSpell7") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SEVEN))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SEVEN),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell8") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_EIGHT))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_EIGHT),oSkin);
    	if (GetLocalInt(oPC, "PRC_AllSpell9") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_NINE))
    	    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_NINE),oSkin); 
    	    
    	// Puts the domain power feats on the skin for the appropriate domains.    
	AddDomainPower(oPC, oSkin);
}