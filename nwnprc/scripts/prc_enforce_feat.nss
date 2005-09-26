/*
   ----------------
   prc_enforce_feat
   ----------------

   7/25/04 by Stratovarius

   This script is used to enforce the proper selection of bonus feats
   so that people cannot use epic bonus feats and class bonus feats to
   select feats they should not be allowed to. Only contains the Red Wizard,
   but more, such as the Mage Killer and Fist of Hextor, will be added later.
*/


#include "prc_class_const"
#include "prc_feat_const"
#include "prc_alterations"
#include "prc_inc_sneak"

//  Prevents a Man at Arms from taking improved critical 
//  in a weapon that he does not have focus in.
int ManAtArmsFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Red Wizard feats
// that are used to determine restricted and specialist
// spell schools. You must have two restricted and one specialist.
int RedWizardFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Mage Killer
// Bonus Save feats.
int MageKiller(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Fist of Hextor
// Brutal Strike feats.
int Hextor(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Vile feats
// and prevents illegal stacking of them
int VileFeats(object oPC = OBJECT_SELF);

// Enforces the proper selection of the Ultimate Ranger feats
// and prevents illegal use of bonus feats.
int UltiRangerFeats(object oPC = OBJECT_SELF);

// Stops non-Orcs from taking the Blood of the Warlord
// Feat, can be expanded later.
int Warlord(object oPC = OBJECT_SELF);

// Stops PCs from having more than one Elemental Savant Class
// as its supposed to be only one class, not 8.
int ElementalSavant(object oPC = OBJECT_SELF);

// Enforces Genasai taking the proper elemental domain
int GenasaiFocus(object oPC = OBJECT_SELF);

// Prevents a player from taking Lingering Damage without
// have 8d6 sneak attack
int LingeringDamage(object oPC = OBJECT_SELF);

// check for server restricted feats/skills
int PWSwitchRestructions(object oPC = OBJECT_SELF);

// Applies when a Marshal can select a Major or Minor Aura
int MarshalAuraLimit(object oPC = OBJECT_SELF);

// Stops people from taking feats they cannot use because of caster levels.
int CasterFeats(object oPC = OBJECT_SELF);

// Enforces the MoS bonus domains.
int MasterOfShrouds(object oPC = OBJECT_SELF);

// Stops people from taking the blightbringer domain, since its prestige
int Blightbringer(object oPC = OBJECT_SELF);

// ---------------
// BEGIN FUNCTIONS
// ---------------

int ManAtArmsFeats(object oPC = OBJECT_SELF)
{
     int bReturnVal = TRUE;
     int iNumImpCrit = 0;
     int iMaA = GetLevelByClass(CLASS_TYPE_MANATARMS, oPC);
     
     // only continue if they are a MaA taking level 3
     if(iMaA != 3) return bReturnVal;
     
     // if they have improved crit and not weapon focus in that weapon
     // time to relevel... can only take imp crit if they have the weapon focus
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_BASTARD_SWORD,    oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,    oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_BATTLE_AXE,       oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_CLUB,             oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE,         oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE,         oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DAGGER,           oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DART,             oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DIRE_MACE,        oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DOUBLE_AXE,       oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_DWAXE,            oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_AXE,        oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_GREAT_SWORD,      oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HALBERD,          oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HAND_AXE,         oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW,   oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL,      oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KAMA,             oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KATANA,           oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_KUKRI,            oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW,   oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL,      oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER,     oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LIGHT_MACE,       oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONG_SWORD,       oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_LONGBOW,          oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MORNING_STAR,     oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_RAPIER,           oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SCIMITAR,         oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SCYTHE,           oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORT_SWORD,      oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHORTBOW,         oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SHURIKEN,         oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SICKLE,           oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SLING,            oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_SPEAR,            oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_STAFF,            oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_THROWING_AXE,     oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD, oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE,   oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE,   oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_WAR_HAMMER,       oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }
     
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_MINDBLADE, oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_MINDBLADE, oPC)){
        iNumImpCrit++;
        bReturnVal = FALSE;
        
        // If they are a soulknife, their weapon could be granting them another ImpCrit as bonus feat
        if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) == "prc_sk_mblade_" ||
           GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)), 14) == "prc_sk_mblade_")
            iNumImpCrit--;
     }

     // if they have an improved crit without having the weapon focus
     // or if they do not have 4 improved critical feats chosen
     if(bReturnVal != TRUE || iNumImpCrit < 4)
     {
          FloatingTextStringOnCreature("You must choose 4 improved critical feats for weapons which you have weapon focus in.  Please reselect your feats.", oPC, FALSE);     
     }
     
     return bReturnVal;  
}

int RedWizardFeats(object oPC = OBJECT_SELF)
{

     int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oPC);
     int iRWRes;
     int iRWSpec;
     
     if((GetHasFeat(FEAT_RW_TF_ABJ, oPC) && GetHasFeat(2265, oPC))
        || (GetHasFeat(FEAT_RW_TF_CON, oPC) && GetHasFeat(2266, oPC))
        || (GetHasFeat(FEAT_RW_TF_DIV, oPC) && GetHasFeat(2267, oPC))
        || (GetHasFeat(FEAT_RW_TF_ENC, oPC) && GetHasFeat(2268, oPC))
        || (GetHasFeat(FEAT_RW_TF_EVO, oPC) && GetHasFeat(2269, oPC))
        || (GetHasFeat(FEAT_RW_TF_ILL, oPC) && GetHasFeat(2270, oPC))
        || (GetHasFeat(FEAT_RW_TF_NEC, oPC) && GetHasFeat(2271, oPC))
        || (GetHasFeat(FEAT_RW_TF_TRS, oPC) && GetHasFeat(2272, oPC)))
      {

           FloatingTextStringOnCreature("You cannot select an Opposition School as a Tattoo Focus. Please reselect your feats.", oPC, FALSE);
           return FALSE;
      }


      iRWSpec  +=    (GetHasFeat(FEAT_RW_TF_ABJ, oPC))
               +     (GetHasFeat(FEAT_RW_TF_CON, oPC))
               +     (GetHasFeat(FEAT_RW_TF_DIV, oPC))
               +     (GetHasFeat(FEAT_RW_TF_ENC, oPC))
               +     (GetHasFeat(FEAT_RW_TF_EVO, oPC))
               +     (GetHasFeat(FEAT_RW_TF_ILL, oPC))
               +     (GetHasFeat(FEAT_RW_TF_NEC, oPC))
               +     (GetHasFeat(FEAT_RW_TF_TRS, oPC));

      if (iRWSpec > 1)
      {

           FloatingTextStringOnCreature("You may only have one Tattoo Focus. Please reselect your feats.", oPC, FALSE);
           return FALSE;
      }


     if (iRedWizard > 0)
     {
          iRWRes      += (GetHasFeat(FEAT_RW_RES_ABJ, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_CON, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_DIV, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_ENC, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_EVO, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_ILL, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_NEC, oPC))
                   +     (GetHasFeat(FEAT_RW_RES_TRS, oPC));


          if (iRWRes != 2)
          {
               FloatingTextStringOnCreature("You must have 2 Restricted Schools. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }
          if((GetHasFeat(FEAT_RW_RES_ABJ, oPC) && GetHasFeat(2265, oPC))
            || (GetHasFeat(FEAT_RW_RES_CON, oPC) && GetHasFeat(2266, oPC))
            || (GetHasFeat(FEAT_RW_RES_DIV, oPC) && GetHasFeat(2267, oPC))
            || (GetHasFeat(FEAT_RW_RES_ENC, oPC) && GetHasFeat(2268, oPC))
            || (GetHasFeat(FEAT_RW_RES_EVO, oPC) && GetHasFeat(2269, oPC))
            || (GetHasFeat(FEAT_RW_RES_ILL, oPC) && GetHasFeat(2270, oPC))
            || (GetHasFeat(FEAT_RW_RES_NEC, oPC) && GetHasFeat(2271, oPC))
            || (GetHasFeat(FEAT_RW_RES_TRS, oPC) && GetHasFeat(2272, oPC)))
          {

               FloatingTextStringOnCreature("You cannot select an Opposition School as a Restricted School. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }          
     }
     return TRUE;
}


int MageKiller(object oPC = OBJECT_SELF)
{

     int iMK = (GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) + 1) / 2;

     int iRef = 0;
     int iFort = 0;
     int iMKSave = 0;

     if (iMK > 0)
     {

     iRef +=        GetHasFeat(FEAT_MK_REF_15, oPC) +
               GetHasFeat(FEAT_MK_REF_14, oPC) +
               GetHasFeat(FEAT_MK_REF_13, oPC) +
               GetHasFeat(FEAT_MK_REF_12, oPC) +
               GetHasFeat(FEAT_MK_REF_11, oPC) +
               GetHasFeat(FEAT_MK_REF_10, oPC) +
               GetHasFeat(FEAT_MK_REF_9, oPC) +
               GetHasFeat(FEAT_MK_REF_8, oPC) +
               GetHasFeat(FEAT_MK_REF_7, oPC) +
               GetHasFeat(FEAT_MK_REF_6, oPC) +
               GetHasFeat(FEAT_MK_REF_5, oPC) +
               GetHasFeat(FEAT_MK_REF_4, oPC) +
               GetHasFeat(FEAT_MK_REF_3, oPC) +
               GetHasFeat(FEAT_MK_REF_2, oPC) +
               GetHasFeat(FEAT_MK_REF_1, oPC);

     iFort +=  GetHasFeat(FEAT_MK_FORT_15, oPC) +
               GetHasFeat(FEAT_MK_FORT_14, oPC) +
               GetHasFeat(FEAT_MK_FORT_13, oPC) +
               GetHasFeat(FEAT_MK_FORT_12, oPC) +
               GetHasFeat(FEAT_MK_FORT_11, oPC) +
               GetHasFeat(FEAT_MK_FORT_10, oPC) +
               GetHasFeat(FEAT_MK_FORT_9, oPC) +
               GetHasFeat(FEAT_MK_FORT_8, oPC) +
               GetHasFeat(FEAT_MK_FORT_7, oPC) +
               GetHasFeat(FEAT_MK_FORT_6, oPC) +
               GetHasFeat(FEAT_MK_FORT_5, oPC) +
               GetHasFeat(FEAT_MK_FORT_4, oPC) +
               GetHasFeat(FEAT_MK_FORT_3, oPC) +
               GetHasFeat(FEAT_MK_FORT_2, oPC) +
               GetHasFeat(FEAT_MK_FORT_1, oPC);

     iMKSave = iRef + iFort;
/*
     FloatingTextStringOnCreature("Mage Killer Level: " + IntToString(iMK), oPC, FALSE);
     FloatingTextStringOnCreature("Reflex Save Level: " + IntToString(iRef), oPC, FALSE);
     FloatingTextStringOnCreature("Fortitude Save Level: " + IntToString(iFort), oPC, FALSE);
*/
     if (iMK != iMKSave)
     {
          FloatingTextStringOnCreature("You must select an Improved Save Feat. Please reselect your feats.", oPC, FALSE);
          return FALSE;
     }

     }
     return TRUE;
}

int Hextor(object oPC = OBJECT_SELF)
{

     int iHextor = GetLevelByClass(CLASS_TYPE_HEXTOR, oPC);

     int iAtk = 0;
     int iDam = 0;
     int iTotal = 0;
     int iCheck;

     if (iHextor > 0)
     {

     iAtk +=        GetHasFeat(FEAT_BSTRIKE_A12, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A11, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A10, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A9, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A8, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A7, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A6, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A5, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A4, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A3, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A2, oPC) +
               GetHasFeat(FEAT_BSTRIKE_A1, oPC);

     iDam +=        GetHasFeat(FEAT_BSTRIKE_D12, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D11, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D10, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D9, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D8, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D7, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D6, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D5, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D4, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D3, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D2, oPC) +
               GetHasFeat(FEAT_BSTRIKE_D1, oPC);

     iTotal = iAtk + iDam;

     if (iTotal == 12 && iHextor > 29) { iCheck = TRUE; }
     else if (iTotal == 11 && iHextor > 26 && iHextor < 30) { iCheck = TRUE; }
     else if (iTotal == 10 && iHextor > 23 && iHextor < 27) { iCheck = TRUE; }
     else if (iTotal == 9 && iHextor > 20 && iHextor < 24) { iCheck = TRUE; }
     else if (iTotal == 8 && iHextor > 19 && iHextor < 21) { iCheck = TRUE; }
     else if (iTotal == 7 && iHextor > 16 && iHextor < 20) { iCheck = TRUE; }
     else if (iTotal == 6 && iHextor > 13 && iHextor < 17) { iCheck = TRUE; }
     else if (iTotal == 5 && iHextor > 10 && iHextor < 14) { iCheck = TRUE; }
     else if (iTotal == 4 && iHextor > 9 && iHextor < 11) { iCheck = TRUE; }
     else if (iTotal == 3 && iHextor > 6 && iHextor < 10) { iCheck = TRUE; }
     else if (iTotal == 2 && iHextor > 3 && iHextor < 7) { iCheck = TRUE; }
     else if (iTotal == 1 && iHextor > 0) { iCheck = TRUE; }
     else { iCheck = FALSE; }

/*
     FloatingTextStringOnCreature("Fist of Hextor Level: " + IntToString(iHextor), oPC, FALSE);
     FloatingTextStringOnCreature("Brutal Strike Attack Level: " + IntToString(iAtk), oPC, FALSE);
     FloatingTextStringOnCreature("Brutal Strike Damage Level: " + IntToString(iDam), oPC, FALSE);
*/
     if (iCheck != TRUE)
     {

          FloatingTextStringOnCreature("You must select a Brutal Strike Feat. Please reselect your feats.", oPC, FALSE);
               return FALSE;
     }

     }
     return TRUE;
}


int GenasaiFocus(object oPC)
{
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_AIR_GEN))
   {
       if (!GetHasFeat(FEAT_AIR_DOMAIN_POWER, oPC))
       {

        FloatingTextStringOnCreature("You must have the Air Domain as an Air Genasai.", oPC, FALSE);
               return FALSE;
       }
   }
   else if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_EARTH_GEN))
   {
       if (!GetHasFeat(FEAT_EARTH_DOMAIN_POWER, oPC))
       {

        FloatingTextStringOnCreature("You must have the Earth Domain as an Earth Genasai.", oPC, FALSE);
               return FALSE;
       }
   }
   else if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_FIRE_GEN))
   {
       if (!GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC))
       {

        FloatingTextStringOnCreature("You must have the Fire Domain as an Fire Genasai.", oPC, FALSE);
               return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && (GetRacialType(oPC) == RACIAL_TYPE_WATER_GEN))
   {
       if (!GetHasFeat(FEAT_WATER_DOMAIN_POWER, oPC))
       {

        FloatingTextStringOnCreature("You must have the Water Domain as an Water Genasai.", oPC, FALSE);
               return FALSE;
       }
   }
     return TRUE;
}


int ElementalSavant(object oPC)
{
   if (GetLevelByClass(CLASS_TYPE_ES_ACID, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_ES_COLD, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC) > 0)
       {
            FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
            return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_ES_COLD, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_ES_ACID, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_ES_COLD, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_ACID, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_ES_COLD, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_ES_ACID, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;       
       }
   }
   if (GetLevelByClass(CLASS_TYPE_DIVESA, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_DIVESC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESE, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESF, oPC) > 0)
       {
            FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
            return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_DIVESC, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_DIVESA, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESE, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESF, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_DIVESE, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_DIVESC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESA, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESF, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;
       }
   }
   if (GetLevelByClass(CLASS_TYPE_DIVESF, oPC))
   {
       if (GetLevelByClass(CLASS_TYPE_DIVESC, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESE, oPC) > 0 
              || GetLevelByClass(CLASS_TYPE_DIVESA, oPC) > 0)
       {
           FloatingTextStringOnCreature("You may only have one Elemental Savant class.", oPC, FALSE);
           return FALSE;       
       }
   }
     return TRUE;
}


int VileFeats(object oPC = OBJECT_SELF)
{

     int iDeform = GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC) + GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC);
     int iThrall = GetHasFeat(FEAT_THRALL_TO_DEMON, oPC) + GetHasFeat(FEAT_DISCIPLE_OF_DARKNESS, oPC);


          if (iDeform > 1)
          {
               FloatingTextStringOnCreature("You may only have one Deformity. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }


          if (iThrall > 1)
          {

               FloatingTextStringOnCreature("You may only worship Demons or Devils, not both. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }
     return TRUE;
}

int Warlord(object oPC = OBJECT_SELF)
{
          if (GetHasFeat(FEAT_BLOOD_OF_THE_WARLORD, oPC) && (MyPRCGetRacialType(oPC) != RACIAL_TYPE_HALFORC)
                  && (MyPRCGetRacialType(oPC) != RACIAL_TYPE_HUMANOID_ORC))
          {
               FloatingTextStringOnCreature("You must be of orcish blood to take this feat. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }
     return TRUE;
}

int Ethran(object oPC = OBJECT_SELF)
{
          if (GetHasFeat(FEAT_ETHRAN, oPC) && (GetGender(oPC) != GENDER_FEMALE))
          {

               FloatingTextStringOnCreature("You must be Female to take this feat. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }
     return TRUE;
}

int UltiRangerFeats(object oPC = OBJECT_SELF)
{

     int iURanger = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER, oPC);
     int iAbi = 0, iFE = 0, Ability = 0;

     if (iURanger > 0)
     {
          iFE     +=     (GetHasFeat(FEAT_UR_FE_DWARF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ELF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GNOME, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFING, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFELF, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HALFORC, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_HUMAN, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ABERRATION, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ANIMAL, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_BEAST, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_CONSTRUCT, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_DRAGON, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GOBLINOID, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_MONSTROUS, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ORC, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_REPTILIAN, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_ELEMENTAL, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_FEY, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_GIANT, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_MAGICAL_BEAST, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_OUTSIDER, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_SHAPECHANGER, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_UNDEAD, oPC))
                   +     (GetHasFeat(FEAT_UR_FE_VERMIN, oPC));

          iAbi    +=     (GetHasFeat(FEAT_UR_SNEAKATK_3D6, oPC))
                   +     (GetHasFeat(FEAT_UR_ARMOREDGRACE, oPC))
                   +     (GetHasFeat(FEAT_UR_DODGE_FE, oPC))
                   +     (GetHasFeat(FEAT_UR_RESIST_FE, oPC))
                   +     (GetHasFeat(FEAT_UR_HAWK_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_OWL_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_VIPER_TOTEM, oPC))
                   +     (GetHasFeat(FEAT_UR_FAST_MOVEMENT, oPC))
                   +     (GetHasFeat(FEAT_UNCANNYX_DODGE_1, oPC))
                   +     (GetHasFeat(FEAT_UR_HIPS, oPC));

                if (iURanger>=11){
                   if ((iURanger-8)/3 != iAbi) Ability = 1;
                }

          if ( iFE != (iURanger+3)/5 || Ability)
          {

               string sAbi ="1 ability ";
               string sFE =" 1 favorite enemy ";
               string msg=" You must select ";
               int bFeat;
                     if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
                     else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
               if (iURanger>10 &&  (iURanger-8)%3 == 0) msg = msg+sAbi+" ";
               if (iURanger>1 && (iURanger+8)%5 == 0) msg+=sFE;
               if (iURanger == 1 || iURanger == 4 ||bFeat) msg+= " 1 bonus Feat";

               //FloatingTextStringOnCreature(" Please reselect your feats.", oPC, FALSE);
               FloatingTextStringOnCreature(msg, oPC, FALSE);
               return FALSE;
          }
          else
          {
              iURanger++;
              string msg =" In your next Ultimate Ranger level, you must select ";
              int bFeat;
                 if (iURanger>4 && iURanger<21 ) bFeat = ((iURanger+1)%4 == 0);
                 else if (iURanger>20 ) bFeat = ((iURanger+2)%5 == 0);
              if (iURanger == 1 || iURanger == 4 || bFeat) msg+= "1 bonus Feat ";
                    if (iURanger>10 &&  (iURanger-8)%3 == 0) msg +="1 Ability ";
                    if (iURanger>1 && (iURanger+8)%5 == 0) msg+="1 Favorite Enemy ";
                    if ( msg != " In your next Ultimate Ranger level, you must select ")
                      FloatingTextStringOnCreature(msg, oPC, FALSE);
          }
     }
     return TRUE;
}

int CheckClericShadowWeave(object oPC)
{
   if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetHasFeat(FEAT_SHADOWWEAVE, oPC))
   {
       int iCleDom = GetHasFeat(FEAT_EVIL_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_FIRE_DOMAIN_POWER, oPC) +
                     GetHasFeat(FEAT_DARKNESS_DOMAIN, oPC);

       if (iCleDom < 2)
       {

        FloatingTextStringOnCreature("You must have two of the following domains: Evil, Fire, or Darkness to use the shadow weave.", oPC, FALSE);
        FloatingTextStringOnCreature("Please reselect your feats.", oPC, FALSE);
               return FALSE;
       }
   }
     return TRUE;
}

int LolthsMeat(object oPC)
{
     if (GetHasFeat(FEAT_LOLTHS_MEAT, oPC) &&
        !(GetRacialType(oPC) == RACIAL_TYPE_DROW_FEMALE ||
          GetRacialType(oPC) == RACIAL_TYPE_DROW_MALE   ||
          GetRacialType(oPC) == RACIAL_TYPE_ELF         ||
          GetRacialType(oPC) == RACIAL_TYPE_HALFDROW        ) )
     {
          FloatingTextStringOnCreature("You must be a Drow or Half-Drow to take this feat. Please reselect your feats.", oPC, FALSE);
               return FALSE;
     }
     return TRUE;
}

// Prevents a player from taking Lingering Damage without
// have 8d6 sneak attack
int LingeringDamage(object oPC = OBJECT_SELF)
{
     if(GetHasFeat(FEAT_LINGERING_DAMAGE, oPC) &&
        GetTotalSneakAttackDice(oPC) < 8)
     {
          FloatingTextStringOnCreature("You must have at least 8d6 sneak attack dice. Please reselect your feats.", oPC, FALSE);
          return FALSE;          
     }
     
     return TRUE;
}

// check for server restricted feats/skills
int PWSwitchRestructions(object oPC = OBJECT_SELF)
{
    int nReturn = TRUE;
    string sMessage;
    int nFeatCount = GetPRCSwitch(PRC_DISABLE_FEAT_COUNT);
    int i;
    for(i=1;i<nFeatCount;i++)
    {
        int nFeat = GetPRCSwitch(PRC_DISABLE_FEAT_+IntToString(i));
        if(GetHasFeat(nFeat, oPC))
        {
            nReturn = FALSE;
            sMessage += "You cannot take "+GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeat)))+" in this module.\n";
        }
    }
    
    int nSkillCount = GetPRCSwitch(PRC_DISABLE_SKILL_COUNT);
    for(i=1;i<nSkillCount;i++)
    {
        int nSkill = GetPRCSwitch(PRC_DISABLE_SKILL_+IntToString(i));
        if(GetSkillRank(nSkill, oPC))
        {
            nReturn = FALSE;
            sMessage += "You cannot take "+GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", nSkill)))+" in this module.\n";
        }
    }
    FloatingTextStringOnCreature(sMessage, oPC);
    return nReturn;
}

int DraDisFeats(object oPC = OBJECT_SELF)
{

     int bLd = (GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC));

     int iBld = 0;
     int dBlood = 0;

     if (bLd > 1)
     {

        iBld +=   GetHasFeat(FEAT_RED_DRAGON, oPC) +
            GetHasFeat(FEAT_SILVER_DRAGON, oPC) +
            GetHasFeat(FEAT_BLACK_DRAGON, oPC) +
            GetHasFeat(FEAT_BLUE_DRAGON, oPC) +
            GetHasFeat(FEAT_GREEN_DRAGON, oPC) +
            GetHasFeat(FEAT_WHITE_DRAGON, oPC) +
            GetHasFeat(FEAT_BRASS_DRAGON, oPC) +
            GetHasFeat(FEAT_BRONZE_DRAGON, oPC) +
            GetHasFeat(FEAT_COPPER_DRAGON, oPC) +
            GetHasFeat(FEAT_GOLD_DRAGON, oPC) +
            GetHasFeat(FEAT_AMETHYST_DRAGON, oPC) +
            GetHasFeat(FEAT_CRYSTAL_DRAGON, oPC) +
            GetHasFeat(FEAT_EMERALD_DRAGON, oPC) +
            GetHasFeat(FEAT_SAPPHIRE_DRAGON, oPC) +
            GetHasFeat(FEAT_TOPAZ_DRAGON, oPC) +
            GetHasFeat(FEAT_BATTLE_DRAGON, oPC) +
            GetHasFeat(FEAT_BROWN_DRAGON, oPC) +
            GetHasFeat(FEAT_CHAOS_DRAGON, oPC) +
            GetHasFeat(FEAT_DEEP_DRAGON, oPC) +
            GetHasFeat(FEAT_ETHEREAL_DRAGON, oPC) +
            GetHasFeat(FEAT_FANG_DRAGON, oPC) +
            GetHasFeat(FEAT_HOWLING_DRAGON, oPC) +
            GetHasFeat(FEAT_OCEANUS_DRAGON, oPC) +
            GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC) +
            GetHasFeat(FEAT_RADIANT_DRAGON, oPC) +
            GetHasFeat(FEAT_RUST_DRAGON, oPC) +
            GetHasFeat(FEAT_SHADOW_DRAGON, oPC) +
            GetHasFeat(FEAT_SONG_DRAGON, oPC) +
            GetHasFeat(FEAT_STYX_DRAGON, oPC) +
            GetHasFeat(FEAT_TARTIAN_DRAGON, oPC) +
            GetHasFeat(FEAT_CHIANG_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_LI_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC) +
            GetHasFeat(FEAT_PAN_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON, oPC) +
            GetHasFeat(FEAT_YU_LUNG_DRAGON, oPC);

        /*
        FloatingTextStringOnCreature("Dragon Disciple Level: " + IntToString(bLd), oPC, FALSE);
        FloatingTextStringOnCreature("Draconic Blood: " + IntToString(iBld), oPC, FALSE);
        */
        if (iBld >1)
        {
            FloatingTextStringOnCreature("You cannot select more than one Draconic Heritage.", oPC, FALSE);
            return FALSE;
        }
    }
    return TRUE;
}

int MarshalAuraLimit(object oPC = OBJECT_SELF)
{
    int mArsh = (GetLevelByClass(CLASS_TYPE_MARSHAL, oPC));
    int MinAur = 0;
    int MajAur = 0;
    
    if (mArsh > 1)
    {
         MinAur +=   GetHasFeat(MIN_AUR_FORT, oPC) +
                     GetHasFeat(MIN_AUR_WILL, oPC) +
                     GetHasFeat(MIN_AUR_REF, oPC) +
                     GetHasFeat(MIN_AUR_CHA, oPC) +
                     GetHasFeat(MIN_AUR_CON, oPC) +
                     GetHasFeat(MIN_AUR_DEX, oPC) +
                     GetHasFeat(MIN_AUR_INT, oPC) +
                     GetHasFeat(MIN_AUR_WIS, oPC) +
                     GetHasFeat(MIN_AUR_STR, oPC) +
                     GetHasFeat(MIN_AUR_CAST, oPC) +
                     GetHasFeat(MIN_AUR_AOW, oPC);
         MajAur +=   GetHasFeat(MAJ_AUR_MOT_ARDOR, oPC) +
                     GetHasFeat(MAJ_AUR_MOT_CARE, oPC) +
                     GetHasFeat(MAJ_AUR_RES_TROOPS, oPC) +
                     GetHasFeat(MAJ_AUR_MOT_URGE, oPC) +
                     GetHasFeat(MAJ_AUR_HARD_SOLDIER, oPC) +
                     GetHasFeat(MAJ_AUR_MOT_ATTACK, oPC) +
                     GetHasFeat(MAJ_AUR_STEAD_HAND, oPC);
        /*
        FloatingTextStringOnCreature("Marshal Level: " + IntToString(mArsh), oPC, FALSE);
        FloatingTextStringOnCreature("Minor Aura: " + IntToString(MinAur), oPC, FALSE);
        FloatingTextStringOnCreature("Major Aura: " + IntToString(MajAur), oPC, FALSE);
        */
        if ((mArsh == 2) && (MinAur == 2))
        {
        FloatingTextStringOnCreature("You must select a Major Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 3) && (MinAur == 1))
        {
        FloatingTextStringOnCreature("You must select a Minor Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 7) && (MinAur == 3))
        {
        FloatingTextStringOnCreature("You must select a Minor Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 12) && (MinAur == 5))
        {
        FloatingTextStringOnCreature("You must select a Minor Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 14) && (MinAur == 7))
        {
        FloatingTextStringOnCreature("You must select a Major Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 15) && (MinAur == 6))
        {
        FloatingTextStringOnCreature("You must select a Minor Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 19) && (MinAur == 7))
        {
        FloatingTextStringOnCreature("You must select a Minor Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh == 20) && (MinAur == 9))
        {
        FloatingTextStringOnCreature("You must select a Major Aura this level.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh > 20) && (MinAur > 8))
        {
        FloatingTextStringOnCreature("You cannot learn any new Marshal Auras.", oPC, FALSE);
        return FALSE;
            }
        if ((mArsh > 20) && (MinAur > 5))
        {
        FloatingTextStringOnCreature("You cannot learn any new Marshal Auras.", oPC, FALSE);
        return FALSE;
            }
    }
    return TRUE;
}

int CasterFeats(object oPC = OBJECT_SELF)
{
    if (GetHasFeat(FEAT_INSCRIBE_RUNE, oPC) && GetLocalInt(oPC, "PRC_DivSpell2") != 0)
    {
            FloatingTextStringOnCreature("Inscribe Rune requires Level 2 Divine Spells", oPC, FALSE);
            return FALSE;   
        }
    
    return TRUE;
}

int MasterOfShrouds(object oPC = OBJECT_SELF)
{
    int MoS = (GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC));
    if (MoS > 0)
    {
        int nDom =   GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC) +
                         GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC) +
                         GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC);
                         
            if (nDom < 2)
            {
                FloatingTextStringOnCreature("You must select your two bonus domains", oPC, FALSE);
                return FALSE;
            }  
        }
        return TRUE;
}
    
int Blightbringer(object oPC = OBJECT_SELF)
{
    // You should only have the Blightbringer domain as a bonus domain
    if (GetHasFeat(FEAT_BLIGHTBRINGER_DOMAIN_POWER, oPC) && !GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC))
    {
            FloatingTextStringOnCreature("You may not select Blightbringer as a domain at level 1.", oPC, FALSE);
            return FALSE;
        }
        return TRUE;
}
       
       
int RacialHD(object oPC)
{
    int nRealRace = GetRacialType(oPC);
    int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRealRace));
    int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRealRace));
    if(GetLevelByClass(nRacialClass, oPC) < nRacialHD
        && GetHitDice(oPC)-1-GetLevelByClass(nRacialClass, oPC) > 0)
    {
        string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nRacialClass)));
        FloatingTextStringOnCreature("You must take "+IntToString(nRacialHD)+" levels in your racial hit dice class, "+sName, oPC, FALSE);
        return FALSE;
    }
    return TRUE;
}

//this is a rough calculation to stop the 41 spellslot levels bugs
int FortySpellSlotLevels(object oPC)
{
    int i;
    int nArcSpellslotLevel;
    int nDivSpellslotLevel;
    for(i=1;i<=3;i++)
    {
        int nClass = PRCGetClassByPosition(i, oPC);
        //spellcasting prc
        int nArcSpellMod = StringToInt(Get2DACache("classes", "ArcSpellLvlMod", nClass));
        int nDivSpellMod = StringToInt(Get2DACache("classes", "DivSpellLvlMod", nClass));
        if(nArcSpellMod)
            nArcSpellslotLevel += (GetLevelByClass(nClass, oPC)+1)/nArcSpellMod;
        if(nDivSpellMod)
            nDivSpellslotLevel += (GetLevelByClass(nClass, oPC)+1)/nDivSpellMod;
        //spellcasting base class
        //bioware only
        if(nClass == CLASS_TYPE_BARD
            || nClass == CLASS_TYPE_WIZARD
            || nClass == CLASS_TYPE_SORCERER
            )
            nArcSpellslotLevel += GetLevelByClass(nClass);
        if(nClass == CLASS_TYPE_CLERIC
            || nClass == CLASS_TYPE_DRUID
            || nClass == CLASS_TYPE_RANGER
            || nClass == CLASS_TYPE_PALADIN
            )
            nDivSpellslotLevel += GetLevelByClass(nClass);
            
    }
    
    if(nArcSpellslotLevel > 40
        || nDivSpellslotLevel > 40)
    {
        FloatingTextStringOnCreature("You cannot take this class as it would break your spellcasting.", oPC, FALSE);
        return FALSE;
    }
    return TRUE;
}

void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;

     if(!RedWizardFeats(oPC)
         || !VileFeats(oPC)
         || !Warlord(oPC)
         || !Hextor(oPC)
         || !Ethran(oPC)
         || !UltiRangerFeats(oPC)
         || !MageKiller(oPC)
         || !ElementalSavant(oPC)
         || !GenasaiFocus(oPC)
         || !MasterOfShrouds(oPC)
         || !CheckClericShadowWeave(oPC)
         || !LolthsMeat(oPC)
         || !LingeringDamage(oPC) 
         || !ManAtArmsFeats(oPC) 
         || !PWSwitchRestructions(oPC)
         || !DraDisFeats(oPC)
         || !CasterFeats(oPC)
         || !MarshalAuraLimit(oPC)
         || !Blightbringer(oPC)
         || !FortySpellSlotLevels(oPC)
         || !RacialHD(oPC)
       )
    {
       int nHD = GetHitDice(oPC);
       int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
       int nOldXP = GetXP(oPC);
       int nNewXP = nMinXPForLevel - 1000;
       SetXP(oPC,nNewXP);
       DelayCommand(1.0, SetXP(oPC,nOldXP));
    }
}