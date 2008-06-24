// Favoured Soul passive abilities.
// Resist 3 elements, DR, Weapon Focus/Spec

#include "prc_inc_wpnrest"
#include "pnp_shft_poly"

void ResistElement(object oPC, object oSkin, int iLevel, int iType, string sVar)
{
  if(GetLocalInt(oSkin, sVar) == iLevel) return;

  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,iType,GetLocalInt(oSkin, sVar));

  DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(iType, iLevel), oSkin));
  SetLocalInt(oSkin, sVar, iLevel);
}

void DamageReduction(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "FavouredSoulDR") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "FavouredSoulDR"), IP_CONST_DAMAGESOAK_10_HP, 1, "FavouredSoulDR");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(iLevel, IP_CONST_DAMAGESOAK_10_HP), oSkin);
    SetLocalInt(oSkin, "FavouredSoulDR", iLevel);
}

void SetWings(object oPC)
{
    // Neutral wing type
    int nWings = CREATURE_WING_TYPE_BIRD;
    int nAlign = GetAlignmentGoodEvil(oPC);
    if (nAlign == ALIGNMENT_EVIL) nWings = CREATURE_WING_TYPE_DEMON;
    else if (nAlign == ALIGNMENT_GOOD) nWings = CREATURE_WING_TYPE_ANGEL;
    //use this wrapper to make sure it interacts with polymorph etc correctly
    DoWings(oPC, nWings);   
}

void AddWS(object oPC,object oSkin,int ip_feat_crit,int nFeat)
{
    //if (GetLocalInt(oSkin, "ManAcriT"+IntToString(ip_feat_crit))) return;
    // Do not add multiple instances of the same bonus feat iprop, it lags the game
    if(GetHasFeat(nFeat,oPC))
        return;
    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(ip_feat_crit), 0.0f,
                          X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void main()
{
        //Declare main variables.
        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        string sVar = "FavouredSoulResistElement";
        int nClass = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC);
    
        if (GetHasFeat(FEAT_FAVOURED_SOUL_ACID, oPC))
        {
            sVar += "Acid";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ACID, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_COLD, oPC))
        {
            sVar += "Cold";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_COLD, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_ELEC, oPC))
        {
            sVar += "Elec";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ELECTRICAL, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_FIRE, oPC))
        {
            sVar += "Fire";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_FIRE, sVar);
        }
        if (GetHasFeat(FEAT_FAVOURED_SOUL_SONIC, oPC))
        {
            sVar += "Sonic";
            ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_SONIC, sVar);
        }  
    
        if (nClass >= 17) SetWings(oPC);
        if (nClass >= 20) DamageReduction(oPC, oSkin, IP_CONST_DAMAGEREDUCTION_3);
        
        // This gives them proficiency in the chosen weapon
        if (nClass >= 3)
        {
            int nBaseItem;
            int nIprop;
            
            if(GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BASTARD_SWORD   );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BATTLE_AXE      );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_CLUB            );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DAGGER          );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DART            );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DIRE_MACE       );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DOUBLE_AXE      );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DWAXE           );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_AXE       );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_SWORD     );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HALBERD         );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HAND_AXE        );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW  );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_FLAIL     );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KAMA            );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KATANA          );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KUKRI           );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW  );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_FLAIL     );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_HAMMER    );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_MACE      );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONG_SWORD      );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONGBOW         );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_MORNING_STAR    );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_RAPIER          );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCIMITAR        );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCYTHE          );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORT_SWORD     );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORTBOW        );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHURIKEN        );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SICKLE          );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SLING           );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SPEAR           );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_STAFF           );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_THROWING_AXE    );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WAR_HAMMER      );
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WHIP            );
   
            if(!IsProficient(oPC, nBaseItem))
            {
                nIprop = GetWeaponProfIPFeat(GetWeaponProfFeatByType(nBaseItem));
                IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            }
        }
    
        // Do Weapon spec
        if (nClass >= 12)
        {
            if(GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE,       FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB,             FEAT_WEAPON_SPECIALIZATION_CLUB);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER,           FEAT_WEAPON_SPECIALIZATION_DAGGER);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DART,             FEAT_WEAPON_SPECIALIZATION_DART);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE,        FEAT_WEAPON_SPECIALIZATION_DIRE_MACE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE,       FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE,            FEAT_WEAPON_SPECIALIZATION_DWAXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE,        FEAT_WEAPON_SPECIALIZATION_GREAT_AXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD,      FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD,          FEAT_WEAPON_SPECIALIZATION_HALBERD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE,         FEAT_WEAPON_SPECIALIZATION_HAND_AXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,   FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL,      FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA,             FEAT_WEAPON_SPECIALIZATION_KAMA);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA,           FEAT_WEAPON_SPECIALIZATION_KATANA);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI,            FEAT_WEAPON_SPECIALIZATION_KUKRI);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,   FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL,      FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,     FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE,       FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD,       FEAT_WEAPON_SPECIALIZATION_LONG_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONGBOW,          FEAT_WEAPON_SPECIALIZATION_LONGBOW);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR,     FEAT_WEAPON_SPECIALIZATION_MORNING_STAR);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER,           FEAT_WEAPON_SPECIALIZATION_RAPIER);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR,         FEAT_WEAPON_SPECIALIZATION_SCIMITAR);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE,           FEAT_WEAPON_SPECIALIZATION_SCYTHE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD,      FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORTBOW,         FEAT_WEAPON_SPECIALIZATION_SHORTBOW);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHURIKEN,         FEAT_WEAPON_SPECIALIZATION_SHURIKEN);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE,           FEAT_WEAPON_SPECIALIZATION_SICKLE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SLING,            FEAT_WEAPON_SPECIALIZATION_SLING);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR,            FEAT_WEAPON_SPECIALIZATION_SPEAR);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF,            FEAT_WEAPON_SPECIALIZATION_STAFF);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE,     FEAT_WEAPON_SPECIALIZATION_THROWING_AXE);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,       FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER);
            else if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP,             FEAT_WEAPON_SPECIALIZATION_WHIP);
        }
}
