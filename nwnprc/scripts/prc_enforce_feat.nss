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
#include "psi_inc_psifunc"
#include "inv_inc_invfunc"
#include "inc_ecl"
#include "inc_epicspells"

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

// Stops people from taking the blightbringer domain, since its prestige
int Blightbringer(object oPC = OBJECT_SELF);

// Stop people from taking crafting feats they don't have the caster level for
int CraftingFeats(object oPC = OBJECT_SELF);

// Stop people from taking Sudden Metamagic feats they don't have the prereqs
int SuddenMetamagic(object oPC = OBJECT_SELF);

// This is for feats that have more than two skill requirements. It's fairly generic
int SkillRequirements(object oPC = OBJECT_SELF);

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
     if(GetHasFeat(FEAT_IMPROVED_CRITICAL_WHIP,             oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC) ) { iNumImpCrit++; bReturnVal = FALSE; }

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

int FavouredSoul(object oPC = OBJECT_SELF)
{

     int nFS = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC);
     int nEnergy;
     int nFocus;
     int nCheck;

     if (nFS >= 3)
     {
    nFocus += GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,    oPC) +
    GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,       oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,             oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE,         oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,           oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_DART,             oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,        oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,       oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,            oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,        oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,      oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,          oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,         oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,   oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,      oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,             oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,           oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,            oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,   oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,      oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,     oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,       oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,       oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,          oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,     oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,           oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,         oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,           oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,      oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,         oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,         oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,           oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SLING,            oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,            oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,            oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,     oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD, oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE,   oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,       oPC)           +
    GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,             oPC)           ;

        if (nFocus >= 1 && nFS >= 3) { nCheck = TRUE; }
        else { nCheck = FALSE; }

        if (nCheck != TRUE)
        {

            FloatingTextStringOnCreature("You must select a Weapon Focus Feat. Please reselect your feats.", oPC, FALSE);
                 return FALSE;
        }

     }

     if (nFS >= 5)
     {

        nEnergy += GetHasFeat(FEAT_FAVOURED_SOUL_ACID, oPC) +
                   GetHasFeat(FEAT_FAVOURED_SOUL_COLD, oPC) +
                   GetHasFeat(FEAT_FAVOURED_SOUL_ELEC, oPC) +
                   GetHasFeat(FEAT_FAVOURED_SOUL_FIRE, oPC) +
                   GetHasFeat(FEAT_FAVOURED_SOUL_SONIC, oPC);

        if (nEnergy == 3 && nFS >= 15) { nCheck = TRUE; }
        else if (nEnergy == 2 && nFS > 5 && nFS < 15) { nCheck = TRUE; }
        else if (nEnergy == 1 && nFS >= 5) { nCheck = TRUE; }
        else { nCheck = FALSE; }

        if (nCheck != TRUE)
        {

             FloatingTextStringOnCreature("You must select an Energy Resistance Feat. Please reselect your feats.", oPC, FALSE);
                  return FALSE;
        }

     }
     return TRUE;
}

int GenasaiFocus(object oPC)
{
    if(GetPRCSwitch(PRC_DISABLE_DOMAIN_ENFORCEMENT))
        return TRUE;
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
    if (bLd == 1)
    {
        //if(DEBUG) FloatingTextStringOnCreature("Checking Heritage.", oPC, FALSE);
        //make sure you don't take a DD heritage that doesn't match your heritage
        if(((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)) && !(GetHasFeat(FEAT_BLACK_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)) && !(GetHasFeat(FEAT_BLUE_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)) && !(GetHasFeat(FEAT_GREEN_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)) && !(GetHasFeat(FEAT_RED_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)) && !(GetHasFeat(FEAT_WHITE_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)) && !(GetHasFeat(FEAT_AMETHYST_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)) && !(GetHasFeat(FEAT_CRYSTAL_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)) && !(GetHasFeat(FEAT_EMERALD_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)) && !(GetHasFeat(FEAT_SAPPHIRE_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)) && !(GetHasFeat(FEAT_TOPAZ_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)) && !(GetHasFeat(FEAT_BRASS_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)) && !(GetHasFeat(FEAT_BRONZE_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)) && !(GetHasFeat(FEAT_COPPER_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)) && !(GetHasFeat(FEAT_GOLD_DRAGON, oPC)))
         || ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC) || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)) && !(GetHasFeat(FEAT_SILVER_DRAGON, oPC)))
         )
        {
         FloatingTextStringOnCreature("You must take a Dragon Disciple Heritage that matches yours.", oPC, FALSE);
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
                     GetHasFeat(MAJ_AUR_STEAD_HAND, oPC)+
                     GetHasFeat(FEAT_MARSHAL_AURA_PRESENCE, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_SENSES, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_TOUGHNESS, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_INSIGHT, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_RESOLVE, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_STAMINA, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_SWIFTNESS, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_RESISTACID, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_RESISTCOLD, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_RESISTELEC, oPC) +
                     GetHasFeat(FEAT_MARSHAL_AURA_RESISTFIRE, oPC);
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
    int nCaster = GetCasterLvl(TYPE_DIVINE, oPC);
    if(DEBUG) DoDebug("GetCasterLevel: " + IntToString(nCaster));
    if (nCaster < 3 && GetHasFeat(FEAT_INSCRIBE_RUNE, oPC))
    {
            FloatingTextStringOnCreature("Inscribe Rune requires level 2 Divine Spells", oPC, FALSE);
            return FALSE;
    }
    nCaster = GetCasterLvl(TYPE_ARCANE, oPC);
    if (nCaster < 3 && GetHasFeat(FEAT_ATTUNE_GEM, oPC))
    {
            FloatingTextStringOnCreature("Attune Gem requires level 2 Arcane Spells", oPC, FALSE);
            return FALSE;
    }
    if(GetHasFeat(FEAT_EPIC_SPELLCASTING, oPC) && !GetIsEpicSpellcaster(oPC))
    {
        FloatingTextStringOnCreature("Epic Spellcasting requires level 9 Arcane or Divine spells", oPC, FALSE);
        return FALSE;
    }

    return TRUE;
}

int Blightbringer(object oPC = OBJECT_SELF)
{
    // You should only have the Blightbringer domain as a bonus domain
    if (GetHasFeat(FEAT_DOMAIN_POWER_BLIGHTBRINGER, oPC) && !GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC))
    {
            FloatingTextStringOnCreature("You may not select Blightbringer as a domain at level 1.", oPC, FALSE);
            return FALSE;
        }
        return TRUE;
}

int SkillRequirements(object oPC = OBJECT_SELF)
{
    // You should only have the Blightbringer domain as a bonus domain
    if (GetHasFeat(FEAT_APPRAISE_MAGIC_VALUE, oPC) && GetSkillRank(SKILL_SPELLCRAFT, oPC) < 5)
    {
            FloatingTextStringOnCreature("You need at least 5 ranks of Spellcraft to select this feat", oPC, FALSE);
            return FALSE;
    }
    if (GetHasFeat(FEAT_DIVE_FOR_COVER, oPC) && GetReflexSavingThrow(oPC) < 4)
    {
            FloatingTextStringOnCreature("You need a Reflex save of at least 4 to select this feat", oPC, FALSE);
            return FALSE;
    }

        return TRUE;
}

int CraftingFeats(object oPC = OBJECT_SELF)
{
    int nCasterLvl     = max(GetCasterLvl(TYPE_ARCANE, oPC), GetCasterLvl(TYPE_DIVINE, oPC)),
        // Gets the maximum of the character's manifester level over all 3 class positions.
        nManifesterLvl = max(max(PRCGetClassByPosition(1, oPC) != CLASS_TYPE_INVALID ? GetManifesterLevel(oPC, PRCGetClassByPosition(1, oPC)) : 0,
                                 PRCGetClassByPosition(2, oPC) != CLASS_TYPE_INVALID ? GetManifesterLevel(oPC, PRCGetClassByPosition(2, oPC)) : 0
                                 ),
                             PRCGetClassByPosition(3, oPC) != CLASS_TYPE_INVALID ? GetManifesterLevel(oPC, PRCGetClassByPosition(3, oPC)) : 0
                             ),
        nInvokerLvl    = max(GetInvokerLevel(oPC, CLASS_TYPE_WARLOCK), GetInvokerLevel(oPC, CLASS_TYPE_DRAGONFIRE_ADEPT)),
        nCasterMax     = max(nCasterLvl, nInvokerLvl),
        nMax           = max(nCasterMax, nManifesterLvl),
        nArti          = GetLevelByClass(CLASS_TYPE_ARTIFICER, oPC);
    int bOK = TRUE, bFirst = TRUE;
    string sError = GetStringByStrRef(16823153) + "\n"; // "Your spellcaster (or manifester) level is not high enough to take the following crafting feats:"

    if(GetHasFeat(FEAT_SCRIBE_SCROLL, oPC) &&
       nMax < 1 &&
       !GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && //fix for wizards getting this for free.
       !nArti
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_SCRIBE_SCROLL)));
    }
    if(GetHasFeat(FEAT_BREW_POTION, oPC) &&
       nMax < 3 && nArti < 2
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_BREW_POTION)));
    }
    if(GetHasFeat(FEAT_CRAFT_WONDROUS, oPC) &&
       nMax < 3 && nArti < 3
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_WONDROUS)));
    }
    if(GetHasFeat(FEAT_CRAFT_ARMS_ARMOR, oPC) &&
       nMax < 5 && nArti < 5
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_ARMS_ARMOR)));
    }
    if(GetHasFeat(FEAT_CRAFT_WAND, oPC) &&
       nMax < 5 && nArti < 7
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_WAND)));
    }
    if(GetHasFeat(FEAT_CRAFT_ROD, oPC) &&
       nMax < 9 && nArti < 9
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_ROD)));
    }
    if(GetHasFeat(FEAT_CRAFT_STAFF, oPC) &&
       nMax < 12 && nArti < 12
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_CRAFT_STAFF)));
    }
    if(GetHasFeat(FEAT_FORGE_RING, oPC) &&
       nMax < 12 && nArti < 14
       )
    {
        bOK = FALSE;
        if(bFirst) bFirst = FALSE; else sError += ", ";
        sError += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", FEAT_FORGE_RING)));
    }

    if(!bOK)
        FloatingTextStringOnCreature(sError, oPC);

    //only one item creation feat and it's one of the ones that needs another as a prereq
    int iCraft = GetItemCreationFeatCount(oPC);
    if(iCraft &&
        iCraft == (
            GetHasFeat(FEAT_EXCEPTIONAL_ARTISAN_I               , oPC) +
            GetHasFeat(FEAT_EXCEPTIONAL_ARTISAN_II              , oPC) +
            GetHasFeat(FEAT_EXCEPTIONAL_ARTISAN_III             , oPC) +
            GetHasFeat(FEAT_EXTRAORDINARY_ARTISAN_I             , oPC) +
            GetHasFeat(FEAT_EXTRAORDINARY_ARTISAN_II            , oPC) +
            GetHasFeat(FEAT_EXTRAORDINARY_ARTISAN_III           , oPC) +
            GetHasFeat(FEAT_LEGENDARY_ARTISAN_I                 , oPC) +
            GetHasFeat(FEAT_LEGENDARY_ARTISAN_II                , oPC) +
            GetHasFeat(FEAT_LEGENDARY_ARTISAN_III               , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_CRAFT_MAGIC_ARMS    , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_CRAFT_ROD           , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_CRAFT_STAFF         , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_CRAFT_WAND          , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_CRAFT_WONDROUS      , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_FORGE_RING          , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_SCRIBE_SCROLL       , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_ATTUNE_GEM          , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_INSCRIBE_RUNE       , oPC) +
            GetHasFeat(FEAT_MAGICAL_ARTISAN_BREW_POTION         , oPC)))
    {
        bOK = FALSE;
    }

    return bOK;
}


int RacialHD(object oPC)
{
    if(!GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
        return TRUE;
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

int LeadershipHD(object oPC)
{
    if(GetECL(oPC)<6 && GetHasFeat(FEAT_LEADERSHIP, oPC))
    {
        FloatingTextStringOnCreature("You must take "+IntToString(6-GetECL(oPC))+" more levels before you can select Leadership.", oPC, FALSE);
        return FALSE;
    }
    if(GetLevelByClass(CLASS_TYPE_THRALLHERD, oPC))
    {
        if(GetHasFeat(FEAT_LEADERSHIP, oPC))
        {
            FloatingTextStringOnCreature("A thrallherd cannot take the Leadership feat.", oPC, FALSE);
            return FALSE;
        }
        if(GetHasFeat(FEAT_EPIC_LEADERSHIP, oPC))
        {
            FloatingTextStringOnCreature("A thrallherd cannot take the Epic Leadership feat.", oPC, FALSE);
            return FALSE;
        }
        if(GetHasFeat(FEAT_LEGENDARY_COMMANDER, oPC))
        {
            FloatingTextStringOnCreature("A thrallherd cannot take the Legendary Commander feat.", oPC, FALSE);
            return FALSE;
        }
    }
    return TRUE;
}

int SuddenMetamagic(object oPC = OBJECT_SELF)
{
    int iFeat = GetHasFeat(FEAT_EMPOWER_SPELL, oPC)    + GetHasFeat(FEAT_EXTEND_SPELL, oPC) +
            GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC)   + GetHasFeat(FEAT_QUICKEN_SPELL, oPC) +
            GetHasFeat(FEAT_SILENCE_SPELL, oPC)    + GetHasFeat(FEAT_STILL_SPELL, oPC) +
            GetHasFeat(FEAT_SUDDEN_EXTEND, oPC) + GetHasFeat(FEAT_SUDDEN_WIDEN, oPC);
            //sudden feats count as metamagic for prereqs
    int nWarmage = GetLevelByClass(CLASS_TYPE_WARMAGE, oPC);

    if(GetHasFeat(FEAT_SUDDEN_EMPOWER, oPC) && (!iFeat) && (nWarmage < 7))
        return FALSE;
    if(GetHasFeat(FEAT_SUDDEN_MAXIMIZE, oPC) && (!iFeat) && (nWarmage < 20))
        return FALSE;

    return TRUE;
}

int DraconicFeats(object oPC = OBJECT_SELF)
{
    //Dragonfriend and Dragonthrall exclude each other
    if(GetHasFeat(FEAT_DRAGONFRIEND, oPC) && GetHasFeat(FEAT_DRAGONTHRALL, oPC))
    {
        FloatingTextStringOnCreature("You cannot take both Dragonfriend and Dragonthrall.", oPC, FALSE);
         return FALSE;
    }

    int bDragonblooded;
    int bHeritage;

    //make sure they qualify for Draconic Heritage
    if((GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC)
      || GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC)
      ) && !( GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0 || GetHasFeat(FEAT_DRAGONTOUCHED, oPC))
     )
     {
        FloatingTextStringOnCreature("You need Dragontouched or a level of Sorcerer for Heritage.", oPC, FALSE);
         return FALSE;
     }

    //Check for dragonblood subtype
    if(GetRacialType(oPC) == RACIAL_TYPE_KOBOLD ||
       GetRacialType(oPC) == RACIAL_TYPE_SPELLSCALE ||
       GetRacialType(oPC) == RACIAL_TYPE_DRAGONBORN ||
       GetRacialType(oPC) == RACIAL_TYPE_STONEHUNTER_GNOME ||
       GetRacialType(oPC) == RACIAL_TYPE_SILVERBROW_HUMAN ||
       GetRacialType(oPC) == RACIAL_TYPE_FORESTLORD_ELF ||
       GetRacialType(oPC) == RACIAL_TYPE_FIREBLOOD_DWARF ||
       GetRacialType(oPC) == RACIAL_TYPE_GLIMMERSKIN_HALFING ||
       GetRacialType(oPC) == RACIAL_TYPE_FROSTBLOOD_ORC ||
       GetRacialType(oPC) == RACIAL_TYPE_SUNSCORCH_HOBGOBLIN ||
       GetRacialType(oPC) == RACIAL_TYPE_VILETOOTH_LIZARDFOLK ||
       GetHasFeat(FEAT_DRAGONTOUCHED, oPC) ||
       GetHasFeat(FEAT_DRACONIC_DEVOTEE, oPC) ||
       GetHasFeat(FEAT_DRAGON, oPC) ||
       GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 9)  bDragonblooded = TRUE;

    //Draconic Heritage qualifies for dragonblood
    if((GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC))
          || (GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC))
         )
        {
            bHeritage = TRUE; //record that they have heritage, for checking Draconic prereqs
            bDragonblooded = TRUE;
        }

        int nNumHeritage = 0;

        if(bHeritage)
            nNumHeritage +=   GetHasFeat(FEAT_DRACONIC_HERITAGE_BK, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_BL, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_GR, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_RD, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_WH, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_AM, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_CR, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_EM, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_SA, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_TP, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_BS, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_BZ, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_CP, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_GD, oPC) +
            GetHasFeat(FEAT_DRACONIC_HERITAGE_SR, oPC);

       if(nNumHeritage > 1)
       {
               FloatingTextStringOnCreature("You cannot select more than one Draconic Heritage.", oPC, FALSE);
            return FALSE;
       }



     //check for Draconic Feats that only need heritage
     if((GetHasFeat(FEAT_DRACONIC_SKIN, oPC)
       || GetHasFeat(FEAT_DRACONIC_ARMOR, oPC)
       || GetHasFeat(FEAT_DRACONIC_BREATH, oPC)
       || GetHasFeat(FEAT_DRACONIC_CLAW, oPC)
       || GetHasFeat(FEAT_DRACONIC_GRACE, oPC)
       || GetHasFeat(FEAT_DRACONIC_KNOWLEDGE, oPC)
       || GetHasFeat(FEAT_DRACONIC_PERSUADE, oPC)
       || GetHasFeat(FEAT_DRACONIC_POWER, oPC)
       || GetHasFeat(FEAT_DRACONIC_PRESENCE, oPC)
       || GetHasFeat(FEAT_DRACONIC_RESISTANCE, oPC)
       || GetHasFeat(FEAT_DRACONIC_VIGOR, oPC))
       && !bHeritage)
    {
            FloatingTextStringOnCreature("You must take a Dragon Heritage first.", oPC, FALSE);
         return FALSE;
    }

    //special test for Draconic Senses
    if(GetHasFeat(FEAT_DRACONIC_SENSES, oPC)
       && !(bDragonblooded
            || (GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 1)
            || (GetLevelByClass(CLASS_TYPE_HANDOTWM, oPC) > 0)))
    {
             FloatingTextStringOnCreature("You must be dragonblood subtype.", oPC, FALSE);
          return FALSE;
    }

    //special test for Dragonfire Strike
    if(GetHasFeat(FEAT_DRAGONFIRE_STRIKE, oPC)
       && !(bDragonblooded || (GetLevelByClass(CLASS_TYPE_HANDOTWM, oPC) > 2)))
    {
             FloatingTextStringOnCreature("You must be dragonblood subtype.", oPC, FALSE);
          return FALSE;
    }

    //testing for Dragonblood only
    if((GetHasFeat(FEAT_DRAGONFIRE_ASSAULT, oPC)
         || GetHasFeat(FEAT_DRAGONFIRE_CHANNELING, oPC)
         || GetHasFeat(FEAT_DRAGONFIRE_INSPIRATION, oPC)
         || GetHasFeat(FEAT_ENTANGLING_EXHALATION, oPC)
         || GetHasFeat(FEAT_EXHALED_BARRIER, oPC)
         || GetHasFeat(FEAT_EXHALED_IMMUNITY, oPC))
       && !bDragonblooded)
    {
             FloatingTextStringOnCreature("You must be dragonblood subtype.", oPC, FALSE);
          return FALSE;
    }

    //Swift Wing Dragon Affinity test - make sure only one is taken
    int nSWLevel = (GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC));

     int nAffinities = 0;

     if (nSWLevel > 1)
     {

        nAffinities +=   GetHasFeat(FEAT_DRAGON_AFFINITY_BK, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_BL, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_GR, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_RD, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_WH, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_AM, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_CR, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_EM, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_SA, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_TP, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_BS, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_BZ, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_CP, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_GD, oPC) +
            GetHasFeat(FEAT_DRAGON_AFFINITY_SR, oPC);

        if (nAffinities >1)
        {
            FloatingTextStringOnCreature("You cannot select more than one Dragon Affinity.", oPC, FALSE);
            return FALSE;
        }

    }

    //Draconic Surge test
    int nPSurge = 0;
    int nMSurge = 0;

    if (nSWLevel > 9)
     {
        nPSurge += GetHasFeat(FEAT_DRACONIC_SURGE_STR, oPC) +
            GetHasFeat(FEAT_DRACONIC_SURGE_DEX, oPC) +
            GetHasFeat(FEAT_DRACONIC_SURGE_CON, oPC);

        nMSurge += GetHasFeat(FEAT_DRACONIC_SURGE_INT, oPC) +
            GetHasFeat(FEAT_DRACONIC_SURGE_WIS, oPC) +
            GetHasFeat(FEAT_DRACONIC_SURGE_CHA, oPC);

        if (nPSurge > 1 || nMSurge > 1)
        {
            FloatingTextStringOnCreature("You must select one Mental and one Physical Surge.", oPC, FALSE);
            return FALSE;
        }
     }

    //racial tests - make sure user is Dragonblooded subtype
    if((GetHasFeat(FEAT_KOB_DRAGON_WING_A, oPC)
           || GetHasFeat(FEAT_KOB_DRAGON_TAIL, oPC))
        && !(bDragonblooded))
        return FALSE;

     //Make sure only kobolds take Dragonwrought
     if(!(GetRacialType(oPC) == RACIAL_TYPE_KOBOLD) &&
         ((GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC))
          || (GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC))
         )
     )
        return FALSE;

    return TRUE;
}

int MetabreathFeats(object oPC)
{
    int bRechargeBreath;
    int bBreath;

    //sources of breaths with recharge rounds
    if((GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oPC) > 9)
       || (GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC) > 3)
       || (GetLevelByClass(CLASS_TYPE_TALON_OF_TIAMAT, oPC) > 0)
       || (GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oPC) > 9)
       || (GetLevelByClass(CLASS_TYPE_SHIFTER, oPC) > 6)
       || (GetRacialType(oPC) == RACIAL_TYPE_DRAGON))
       bRechargeBreath = TRUE;

    if(bRechargeBreath
       || (GetLevelByClass(CLASS_TYPE_SWIFT_WING, oPC) > 2)
       || (GetLevelByClass(CLASS_TYPE_DIAMOND_DRAGON, oPC) > 3)
       || (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) > 9)
       || (GetLevelByClass(CLASS_TYPE_DRAGONFIRE_ADEPT, oPC) > 0)
       || GetHasFeat(FEAT_DRACONIC_BREATH, oPC))
       bBreath = TRUE;

    //metabreath requires breath weapons with a recharge time
    if((GetHasFeat(FEAT_CLINGING_BREATH, oPC)
           || GetHasFeat(FEAT_LINGERING_BREATH, oPC)
           || GetHasFeat(FEAT_ENLARGE_BREATH, oPC)
           || GetHasFeat(FEAT_HEIGHTEN_BREATH, oPC)
           || GetHasFeat(FEAT_MAXIMIZE_BREATH, oPC)
           || GetHasFeat(FEAT_RECOVER_BREATH, oPC)
           || GetHasFeat(FEAT_SHAPE_BREATH, oPC)
           || GetHasFeat(FEAT_SPREAD_BREATH, oPC)
           || GetHasFeat(FEAT_TEMPEST_BREATH, oPC))
        && !(bRechargeBreath))
    {
        FloatingTextStringOnCreature("You must have a breath weapon with a recharge time.", oPC, FALSE);
        return FALSE;
    }

    //breath channeling works with any breath weapon
    if((GetHasFeat(FEAT_ENTANGLING_EXHALATION, oPC)
           || GetHasFeat(FEAT_EXHALED_BARRIER, oPC)
           || GetHasFeat(FEAT_EXHALED_IMMUNITY, oPC))
        && !(bBreath))
    {
        FloatingTextStringOnCreature("You must have a breath weapon.", oPC, FALSE);
        return FALSE;
    }

    //Fivefold Tiamat and Bahamut breath alignment restrictions
    if((GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL && GetHasFeat(FEAT_BAHAMUT_ADEPTBREATH))
       || (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD && GetHasFeat(FEAT_TIAMAT_ADEPTBREATH)))
    {
        FloatingTextStringOnCreature("Your alignment does not allow you to take this breath effect.", oPC, FALSE);
        return FALSE;
    }

    return TRUE;
}

int DragonShamanFeats(object oPC)
{
    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_SHAMAN, oPC);
    if (nLevel == 0) return TRUE;
    int nNumAuras;
    int nNumDragonTotem;
    int nNumOfSkillFocus;

    nNumDragonTotem +=   GetHasFeat(FEAT_DRAGONSHAMAN_RED, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_BLACK, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_BLUE, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_SILVER, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_BRASS, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_GOLD, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_GREEN, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_COPPER, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_WHITE, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_BRONZE, oPC);

    nNumAuras +=         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_POWER, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_PRESENCE, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGYSHLD, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SENSES, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESISTANCE, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_VIGOR, oPC) +
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_TOUGHNESS, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_INSIGHT, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_RESOLVE, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_STAMINA, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_SWIFTNESS, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_MAGICPOWER, oPC)+
                         GetHasFeat(FEAT_DRAGONSHAMAN_AURA_ENERGY, oPC);

    nNumOfSkillFocus +=  GetHasFeat(FEAT_SKILL_FOCUS_HIDE) +
                         GetHasFeat(FEAT_SKILL_FOCUS_MOVE_SILENTLY) +
                         GetHasFeat(FEAT_SKILL_FOCUS_BLUFF);

    if(nNumDragonTotem != 1)
    {
        FloatingTextStringOnCreature("You cannot take more than one Dragon Totem, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }

    if(nLevel <= 2 && nNumAuras != 3)
    {
        FloatingTextStringOnCreature("You may only have 3 auras at this level, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    else if((nLevel == 3 || nLevel == 4) && nNumAuras != 4)
    {
        FloatingTextStringOnCreature("You may only have 4 auras at this level, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    else if((nLevel == 5 || nLevel == 6) && nNumAuras != 5)
    {
        FloatingTextStringOnCreature("You may only have 5 auras at this level, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    else if((nLevel == 7 || nLevel == 8) && nNumAuras != 6)
    {
        FloatingTextStringOnCreature("You may only have 6 auras at this level, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    else if(nLevel >= 9 && nNumAuras != 7)
    {
        FloatingTextStringOnCreature("You may only have 7 auras at this level, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    if(nLevel == 2 && nNumOfSkillFocus != 1)
    {
        FloatingTextStringOnCreature("You must have 1 class skill focus, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    if(nLevel == 8 && nNumOfSkillFocus != 2)
    {
        FloatingTextStringOnCreature("You must have 2 class skill focuses, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    if(nLevel == 16 && nNumOfSkillFocus < 3)
    {
        FloatingTextStringOnCreature("You must have 3 class skill focuses, please reselect your feats.", oPC, FALSE);
        return FALSE;
    }
    return TRUE;
}

int Swordsage(object oPC = OBJECT_SELF)
{

     int nClass = GetLevelByClass(CLASS_TYPE_SWORDSAGE, oPC);

     if (nClass > 0)
     {
         int nWF   =     (GetHasFeat(FEAT_SS_DF_WF_DW, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_WF_DM, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_WF_SS, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_WF_SH, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_WF_SD, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_WF_TC, oPC));

          if (nWF > 1)
          {

               FloatingTextStringOnCreature("You may only have one Discipline Focus (Weapon Focus). Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }

         int nIS   =     (GetHasFeat(FEAT_SS_DF_IS_DW, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_IS_DM, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_IS_SS, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_IS_SH, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_IS_SD, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_IS_TC, oPC));

          if ((nIS > 1 && nClass >= 4 && nClass < 12) || (nIS > 2 && nClass >= 12))
          {

               FloatingTextStringOnCreature("You do not have the correct amount of Discipline Focus (Insightful Strike). Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }

         int nDS   =     (GetHasFeat(FEAT_SS_DF_DS_DW, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_DS_DM, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_DS_SS, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_DS_SH, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_DS_SD, oPC))
                   +     (GetHasFeat(FEAT_SS_DF_DS_TC, oPC));

          if ((nDS > 1 && nClass >= 8 && nClass < 16) || (nDS > 2 && nClass >= 16))
          {

               FloatingTextStringOnCreature("You do not have the correct amount of Discipline Focus (Defensive Stance). Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }

     }
     return TRUE;
}

int Shaman(object oPC = OBJECT_SELF)
{
     int nClass = GetLevelByClass(CLASS_TYPE_SHAMAN, oPC);

     if (nClass > 0)
     {
         int nDomain = (GetHasFeat(FEAT_BONUS_DOMAIN_AIR,           oPC))
                    + (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL,        oPC))
                    + (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH,         oPC))
                    + (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION,   oPC))
                    + (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH,         oPC))
                    + (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING,       oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE,     oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION,    oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_SUN,           oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_WAR,           oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_WATER,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_STORM,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_METAL,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY,       oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION,    oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH,       oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_TIME,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_ELF,           oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_FATE,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY,      oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN,         oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_ORC,           oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL,       oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION,   oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE,          oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS,        oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND,    oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC))
            + (GetHasFeat(FEAT_BONUS_DOMAIN_DRAGON,        oPC));

          if ((nDomain > 2 && nClass < 11) || (nDomain > 3 && nClass >= 11))
          {

               FloatingTextStringOnCreature("You have the wrong among of domains. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }

         int nIS   =     (GetHasFeat(FEAT_DODGE, oPC))
                   +     (GetHasFeat(FEAT_STUNNING_FIST, oPC))
                   +     (GetHasFeat(FEAT_EXPERTISE, oPC))
                   +     (GetHasFeat(FEAT_IMPROVED_EXPERTISE, oPC))
                   +     (GetHasFeat(FEAT_DEFLECT_ARROWS, oPC));

          if (nIS != (nClass/4))
          {
               FloatingTextStringOnCreature("You do not have the correct amount of bonus feats. Please reselect your feats.", oPC, FALSE);
               return FALSE;
          }
     }
     return TRUE;
}

int RacialFeats(object oPC = OBJECT_SELF)
{
    if((GetHasFeat(FEAT_SOULBLADE_WARRIOR)
        || GetHasFeat(FEAT_SPIRITUAL_FORCE)
        || GetHasFeat(FEAT_STRENGTH_OF_TWO)
        || GetHasFeat(FEAT_SHIELD_OF_THOUGHT))
       && GetRacialType(oPC) != RACIAL_TYPE_KALASHTAR)
    {
        FloatingTextStringOnCreature("You must be Kalashtar.", oPC, FALSE);
        return FALSE;
    }

    int nNumFeats;
    nNumFeats +=   GetHasFeat(FEAT_DREAMSIGHT_ELITE, oPC) +
            GetHasFeat(FEAT_GOREBRUTE_ELITE, oPC) +
            GetHasFeat(FEAT_LONGSTRIDE_ELITE, oPC) +
            GetHasFeat(FEAT_LONGTOOTH_ELITE, oPC) +
            GetHasFeat(FEAT_RAZORCLAW_ELITE, oPC) +
            GetHasFeat(FEAT_WILDHUNT_ELITE, oPC) +
            GetHasFeat(FEAT_EXTRA_SHIFTER_TRAIT, oPC) +
            GetHasFeat(FEAT_HEALING_FACTOR, oPC) +
            GetHasFeat(FEAT_SHIFTER_AGILITY, oPC) +
            GetHasFeat(FEAT_SHIFTER_DEFENSE, oPC) +
            GetHasFeat(FEAT_GREATER_SHIFTER_DEFENSE, oPC) +
            GetHasFeat(FEAT_SHIFTER_FEROCITY, oPC) +
            GetHasFeat(FEAT_SHIFTER_INSTINCTS, oPC) +
            GetHasFeat(FEAT_SHIFTER_SAVAGERY, oPC);

    if((GetHasFeat(FEAT_EXTRA_SHIFTER_TRAIT, oPC) && nNumFeats < 3) ||
       (GetHasFeat(FEAT_SHIFTER_DEFENSE, oPC) && nNumFeats < 3) ||
       (GetHasFeat(FEAT_GREATER_SHIFTER_DEFENSE, oPC) && nNumFeats < 5))
    {
        FloatingTextStringOnCreature("You must take more Shifter feats to take this feat.", oPC, FALSE);
        return FALSE;
    }

    return TRUE;
}

int WarlockFeats(object oPC)
{
    int nNumFeats;
    nNumFeats +=   GetHasFeat(FEAT_WARLOCK_RESIST_ACID, oPC) +
            GetHasFeat(FEAT_WARLOCK_RESIST_COLD, oPC) +
            GetHasFeat(FEAT_WARLOCK_RESIST_ELEC, oPC) +
            GetHasFeat(FEAT_WARLOCK_RESIST_FIRE, oPC) +
            GetHasFeat(FEAT_WARLOCK_RESIST_SONIC, oPC);

    if(nNumFeats > 2)
    {
        FloatingTextStringOnCreature("You can only choose resistances.", oPC, FALSE);
        return FALSE;
    }

    if(GetInvokerLevel(oPC, GetFirstInvocationClass(oPC)) < 6 && GetHasFeat(FEAT_EXTRA_INVOCATION_I))
    {
        FloatingTextStringOnCreature("You must have access to lesser invocations to learn extra ones.", oPC, FALSE);
        return FALSE;
    }

    if(GetInvokerLevel(oPC, GetFirstInvocationClass(oPC)) < 16 && GetHasFeat(FEAT_EPIC_EXTRA_INVOCATION_I))
    {
        FloatingTextStringOnCreature("You must have access to dark invocations to learn epic extra ones.", oPC, FALSE);
        return FALSE;
    }

    int nEldBlast = 0;
    if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) < 13)
        nEldBlast = (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) + 1) / 2;
    else if(GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) < 20)
        nEldBlast = (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) + 7) / 3;
    else
        nEldBlast = 9 + (GetLevelByClass(CLASS_TYPE_WARLOCK, oPC) - 20) / 2;

    if(nEldBlast < 9 && GetHasFeat(FEAT_EPIC_ELDRITCH_BLAST_I))
    {
        FloatingTextStringOnCreature("You must have 9d6 eldritch blast to take Epic Eldritch Blast.", oPC, FALSE);
        return FALSE;
    }

    int bShadow = GetHasInvocation(INVOKE_BESHADOWED_BLAST, oPC) &&
                  GetHasInvocation(INVOKE_DARK_DISCORPORATION, oPC) &&
                  GetHasInvocation(INVOKE_DARKNESS, oPC) &&
                  GetHasInvocation(INVOKE_ENERVATING_SHADOW, oPC);

    int bVisionary = GetHasInvocation(INVOKE_DARK_FORESIGHT, oPC) &&
                     GetHasInvocation(INVOKE_DEVILS_SIGHT, oPC) &&
                     GetHasInvocation(INVOKE_SEE_THE_UNSEEN, oPC) &&
                     GetHasInvocation(INVOKE_VOIDSENSE, oPC);

    int bMorpheme = GetHasInvocation(INVOKE_BALEFUL_UTTERANCE, oPC) &&
                    GetHasInvocation(INVOKE_BEGUILING_INFLUENCE, oPC) &&
                    GetHasInvocation(INVOKE_WORD_OF_CHANGING, oPC);

    int bElements = GetHasInvocation(INVOKE_BREATH_OF_THE_NIGHT, oPC) &&
                    GetHasInvocation(INVOKE_CHILLING_TENTACLES, oPC) &&
                    GetHasInvocation(INVOKE_STONY_GRASP, oPC) &&
                    GetHasInvocation(INVOKE_WALL_OF_PERILOUS_FLAME, oPC);

    int bSculptor = (GetHasInvocation(INVOKE_ELDRITCH_GLAIVE, oPC) ||
                        GetHasInvocation(INVOKE_ELDRITCH_SPEAR, oPC) ||
                        GetHasInvocation(INVOKE_HIDEOUS_BLOW, oPC)) &&
                    GetHasInvocation(INVOKE_ELDRITCH_CHAIN, oPC) &&
                    (GetHasInvocation(INVOKE_ELDRITCH_CONE, oPC) ||
                        GetHasInvocation(INVOKE_ELDRITCH_LINE, oPC)) &&
                    GetHasInvocation(INVOKE_ELDRITCH_DOOM, oPC);

    int bLeastEssence = GetHasInvocation(INVOKE_FRIGHTFUL_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_HAMMER_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_SICKENING_BLAST, oPC);

    int bLesserEssence = GetHasInvocation(INVOKE_BANEFUL_BLAST_ABBERATION, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_BEAST, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_CONSTRUCT, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_DRAGON, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_DWARF, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_ELF, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_ELEMENTAL, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_FEY, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_GIANT, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_GOBLINOID, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_GNOME, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_HALFLING, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_HUMAN, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_MONSTEROUS, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_ORC, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_OUTSIDER, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_PLANT, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_REPTILIAN, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_SHAPECHANGER, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_UNDEAD, oPC) ||
                         GetHasInvocation(INVOKE_BANEFUL_BLAST_VERMIN, oPC) ||
                         GetHasInvocation(INVOKE_BESHADOWED_BLAST, oPC) ||
                         GetHasInvocation(INVOKE_BRIMSTONE_BLAST, oPC) ||
                         GetHasInvocation(INVOKE_HELLRIME_BLAST, oPC);

    int bGreatEssence = GetHasInvocation(INVOKE_BEWITCHING_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_HINDERING_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_INCARNUM_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_NOXIOUS_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_PENETRATING_BLAST, oPC) ||
                        GetHasInvocation(INVOKE_VITRIOLIC_BLAST, oPC);

    int bDarkEssence = GetHasInvocation(INVOKE_BINDING_BLAST, oPC) ||
                       GetHasInvocation(INVOKE_UTTERDARK_BLAST, oPC);

    if(!bShadow && GetHasFeat(FEAT_WARLOCK_SHADOWMASTER))
    {
        FloatingTextStringOnCreature("You must have Beshadowed Blast, Dark Discorporation, Darkness, and Enervating Shadow.", oPC, FALSE);
        return FALSE;
    }

    if(!bVisionary && GetHasFeat(FEAT_PARAGON_VISIONARY))
    {
        FloatingTextStringOnCreature("You must have Dark Foresight, Devil's Sight, See the Unseen, and Voidsense.", oPC, FALSE);
        return FALSE;
    }

    if(!bMorpheme && GetHasFeat(FEAT_MORPHEME_SAVANT))
    {
        FloatingTextStringOnCreature("You must have Baleful Utterance, Beguiling Influence, and Word of Changing.", oPC, FALSE);
        return FALSE;
    }

    if(!bElements && GetHasFeat(FEAT_MASTER_OF_THE_ELEMENTS))
    {
        FloatingTextStringOnCreature("You must have Breath of the Night, Chilling Tentacles, Stony Grasp, and Wall of Perilous Flame.", oPC, FALSE);
        return FALSE;
    }

    if(!bSculptor && GetHasFeat(FEAT_ELDRITCH_SCULPTOR))
    {
        FloatingTextStringOnCreature("You must have a blast shape invocation of each invocation level.", oPC, FALSE);
        return FALSE;
    }

    if(!(bLeastEssence && bLesserEssence && bGreatEssence && bDarkEssence) && GetHasFeat(FEAT_LORD_OF_ALL_ESSENCES))
    {
        FloatingTextStringOnCreature("You must have an eldritch essence invocation of each invocation level.", oPC, FALSE);
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
         || !CheckClericShadowWeave(oPC)
         || !LolthsMeat(oPC)
         || !LingeringDamage(oPC)
         || !ManAtArmsFeats(oPC)
         || !PWSwitchRestructions(oPC)
         || !DraDisFeats(oPC)
         || !CasterFeats(oPC)
         || !MarshalAuraLimit(oPC)
         || !Blightbringer(oPC)
         || !CraftingFeats(oPC)
         || !RacialHD(oPC)
         || !LeadershipHD(oPC)
         || !FavouredSoul(oPC)
         || !SuddenMetamagic(oPC)
         || !DraconicFeats(oPC)
         || !MetabreathFeats(oPC)
         || !DragonShamanFeats(oPC)
         || !Swordsage(oPC)
         || !Shaman(oPC)
         || !RacialFeats(oPC)
         || !WarlockFeats(oPC)
         || !SkillRequirements(oPC)
       )
    {
       int nHD = GetHitDice(oPC);
       int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
       int nOldXP = GetXP(oPC);
       int nNewXP = nMinXPForLevel - 1000;
       SetXP(oPC,nNewXP);
       DelayCommand(0.1, SetXP(oPC,nOldXP));
    }
}