// Favoured Soul passive abilities.
// Resist 3 elements, DR, Weapon Focus/Spec

#include "prc_alterations"
#include "prc_alterations"

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
	
	// Only need to do this once
	if (GetCreatureWingType(oPC) == nWings) return;
	
	SetCreatureWingType(nWings, oPC);
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
    		
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,    oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BASTARD_SWORD   );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_BATTLE_AXE      );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_CLUB            );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DAGGER          );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DART            );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DIRE_MACE       );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DOUBLE_AXE      );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_DWAXE           );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_AXE       );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_GREAT_SWORD     );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HALBERD         );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HAND_AXE        );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW  );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_HEAVY_FLAIL     );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KAMA            );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KATANA          );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_KUKRI           );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW  );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_FLAIL     );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_HAMMER    );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LIGHT_MACE      );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONG_SWORD      );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_LONGBOW         );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_MORNING_STAR    );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_RAPIER          );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCIMITAR        );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SCYTHE          );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORT_SWORD     );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHORTBOW        );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SHURIKEN        );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SICKLE          );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SLING           );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_SPEAR           );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_STAFF           );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_THROWING_AXE    );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD);
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WAR_HAMMER      );
    		if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC))	nBaseItem = FocusToWeapProf(FEAT_WEAPON_FOCUS_WHIP            );
   
       		int nProf = StringToInt(Get2DACache("baseitems", "ReqFeat0", nBaseItem));
       		if (nProf == FEAT_WEAPON_PROFICIENCY_EXOTIC) nIprop = IP_CONST_FEAT_WEAPON_PROF_EXOTIC;
       		else if (nProf == FEAT_WEAPON_PROFICIENCY_MARTIAL) nIprop = IP_CONST_FEAT_WEAPON_PROF_MARTIAL;
       		
       		// Finally, apply it
       		if(!GetHasFeat(nProf, oPC)) IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	}
    
    	// Do Weapon spec
    	if (nClass >= 12)
    	{
    		    if(GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,    oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD,    FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE,       FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_CLUB,             FEAT_WEAPON_SPECIALIZATION_CLUB);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DAGGER,           FEAT_WEAPON_SPECIALIZATION_DAGGER);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DART,             FEAT_WEAPON_SPECIALIZATION_DART);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DIRE_MACE,        FEAT_WEAPON_SPECIALIZATION_DIRE_MACE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE,       FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_DWAXE,            FEAT_WEAPON_SPECIALIZATION_DWAXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_AXE,        FEAT_WEAPON_SPECIALIZATION_GREAT_AXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD,      FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HALBERD,          FEAT_WEAPON_SPECIALIZATION_HALBERD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HAND_AXE,         FEAT_WEAPON_SPECIALIZATION_HAND_AXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW,   FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL,      FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KAMA,             FEAT_WEAPON_SPECIALIZATION_KAMA);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KATANA,           FEAT_WEAPON_SPECIALIZATION_KATANA);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_KUKRI,            FEAT_WEAPON_SPECIALIZATION_KUKRI);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW,   FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL,      FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER,     FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE,       FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONG_SWORD,       FEAT_WEAPON_SPECIALIZATION_LONG_SWORD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_LONGBOW,          FEAT_WEAPON_SPECIALIZATION_LONGBOW);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_MORNING_STAR,     FEAT_WEAPON_SPECIALIZATION_MORNING_STAR);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_RAPIER,           FEAT_WEAPON_SPECIALIZATION_RAPIER);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCIMITAR,         FEAT_WEAPON_SPECIALIZATION_SCIMITAR);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SCYTHE,           FEAT_WEAPON_SPECIALIZATION_SCYTHE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD,      FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHORTBOW,         FEAT_WEAPON_SPECIALIZATION_SHORTBOW);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SHURIKEN,         FEAT_WEAPON_SPECIALIZATION_SHURIKEN);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SICKLE,           FEAT_WEAPON_SPECIALIZATION_SICKLE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SLING,            FEAT_WEAPON_SPECIALIZATION_SLING);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_SPEAR,            FEAT_WEAPON_SPECIALIZATION_SPEAR);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_STAFF,            FEAT_WEAPON_SPECIALIZATION_STAFF);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_THROWING_AXE,     FEAT_WEAPON_SPECIALIZATION_THROWING_AXE);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD, FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD);
		    if(GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER,       FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER);
    		    if(GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)) AddWS(oPC, oSkin, IP_CONST_FEAT_WEAPON_SPECIALIZATION_WHIP,             FEAT_WEAPON_SPECIALIZATION_WHIP);
    	}
}
