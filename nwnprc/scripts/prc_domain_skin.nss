// Written by Stratovarius
// Applies the cast domain feats to the hide

#include "prc_inc_domain"

void AddDomainPower(object oPC, object oSkin)
{
    if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC))           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WAR_DOMAIN        ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_STRENGTH_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DEATH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PROTECTION_DOMAIN ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION, oPC))   IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DESTRUCTION_DOMAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DEATH_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_EVIL_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DESTRUCTION_DOMAIN),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_GOOD_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING, oPC))       IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_HEALING_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_EVIL_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE, oPC))     IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_KNOWLEDGE_DOMAIN  ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_GOOD_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HEALING_DOMAIN    ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC))    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PROTECTION_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_KNOWLEDGE_DOMAIN  ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_STRENGTH_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC))           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SUN_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TRAVEL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SUN_DOMAIN        ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TRAVEL_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC))           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WAR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DARKNESS_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DARKNESS_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_STORM_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_METAL_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_METAL_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_STORM_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DWARF_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ORC_DOMAIN        ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY, oPC))       IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TYRANNY_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION, oPC))    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DOMINATION_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TIME_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH, oPC))       IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_UNDEATH_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CHARM_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_TIME_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLS_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DWARF_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RUNE_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_CHARM_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FATE_DOMAIN       ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF, oPC))           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_ELF_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_DOMINATION_DOMAIN ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_FAMILY_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_UNDEATH_DOMAIN    ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_FATE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_FAMILY_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_GNOME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HALFLING_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_ILLUSION_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ILLUSION_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_HATRED_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_HATRED_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_HALFLING_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_NOBILITY_DOMAIN   ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY, oPC))      IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_NOBILITY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RETRIBUTION_DOMAIN),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC))         IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC, oPC))           IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_ORC_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_GNOME_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL, oPC))       IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_RENEWAL_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ELF_DOMAIN        ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC))   IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_RETRIBUTION_DOMAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_RENEWAL_DOMAIN    ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE, oPC))          IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_RUNE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS, oPC))        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SPELLS_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_TYRANNY_DOMAIN    ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC))    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ),oSkin);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC)) IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_BLIGHTBRINGER     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);//AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_BLIGHTBRINGER     ),oSkin);
}


void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if(DEBUG) FloatingTextStringOnCreature("PRC Domain Skin is running", oPC, FALSE);

    // The prereq variables use 0 as true and 1 as false, becuase they are used in class prereqs
    // It uses allspell because there are some feats that allow a wizard or other arcane caster to take domains.
    if (!GetHasFeat(FEAT_CHECK_DOMAIN_SLOTS))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_CHECK_DOMAIN_SLOTS),oSkin);
        if(DEBUG) FloatingTextStringOnCreature("The PC does not have Check Domain Slots, adding", oPC, FALSE);
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