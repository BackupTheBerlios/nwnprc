//::///////////////////////////////////////////////
//:: [PRC Feat Router]
//:: [inc_prc_function.nss]
//:://////////////////////////////////////////////
//:: This file serves as a hub for the various
//:: PRC passive feat functions.  If you need to
//:: add passive feats for a new PRC, link them here.
//::
//:: This file also contains a few multi-purpose
//:: PRC functions that need to be included in several
//:: places, ON DIFFERENT PRCS. Make local include files
//:: for any functions you use ONLY on ONE PRC.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////

//--------------------------------------------------------------------------
// This is the "event" that is called to re-evalutate PRC bonuses.  Currently
// it is fired by OnEquip, OnUnequip and OnLevel.  If you want to move any
// classes into this event, just copy the format below.  Basically, this function
// is meant to keep the code looking nice and clean by routing each class's
// feats to their own self-contained script
//--------------------------------------------------------------------------


#include "prc_alterations"

int nbWeaponFocus(object oPC);

void EvalPRCFeats(object oPC)
{
    //Elemental savant is sort of four classes in one, so we'll take care
    //of them all at once.
    int iElemSavant =  GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_COLD, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_ES_ACID, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESF, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESC, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESE, oPC);
        iElemSavant += GetLevelByClass(CLASS_TYPE_DIVESA, oPC);

    //Route the event to the appropriate class specific scripts
    if(GetLevelByClass(CLASS_TYPE_DUELIST, oPC) > 0)            ExecuteScript("prc_duelist", oPC);
    if(GetLevelByClass(CLASS_TYPE_ACOLYTE, oPC) > 0)            ExecuteScript("prc_acolyte", oPC);
    if(GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) > 0)         ExecuteScript("prc_spellswd", oPC);
    if(GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC) > 0)         ExecuteScript("prc_magekill", oPC);
    if(GetLevelByClass(CLASS_TYPE_OOZEMASTER, oPC) > 0)         ExecuteScript("prc_oozemstr", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_MEPH, oPC) > 0)   ExecuteScript("prc_discmeph", oPC);
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) > 0)               ExecuteScript("pnp_lich_level", oPC);
    if(iElemSavant > 0)                                         ExecuteScript("prc_elemsavant", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEARTWARDER,oPC) > 0)         ExecuteScript("prc_heartwarder", oPC);
    if(GetLevelByClass(CLASS_TYPE_STORMLORD,oPC) > 0)           ExecuteScript("prc_stormlord", oPC);
    if(GetLevelByClass(CLASS_TYPE_PNP_SHIFTER ,oPC) > 0)        ExecuteScript("prc_shifter", oPC);
    if(GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE,oPC) > 0)      ExecuteScript("prc_knghtch", oPC);
    if(GetLevelByClass(CLASS_TYPE_FRE_BERSERKER, oPC) > 0)      ExecuteScript("prc_frebzk", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPEST, oPC) > 0)            ExecuteScript("prc_tempest", oPC);
    if(GetLevelByClass(CLASS_TYPE_FOE_HUNTER, oPC) > 0)         ExecuteScript("prc_foe_hntr", oPC);
    if(GetLevelByClass(CLASS_TYPE_VASSAL, oPC) > 0)             ExecuteScript("prc_vassal", oPC);
    if(GetLevelByClass(CLASS_TYPE_PEERLESS, oPC) > 0)           ExecuteScript("prc_peerless", oPC);
    if(GetLevelByClass(CLASS_TYPE_LEGENDARY_DREADNOUGHT,oPC)>0) ExecuteScript("prc_legendread", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL,oPC) > 0)      ExecuteScript("prc_baalzebul", oPC);
    if(GetLevelByClass(CLASS_TYPE_IAIJUTSU_MASTER,oPC) >0)      ExecuteScript("prc_iaijutsu_mst", oPC);
    if(GetLevelByClass(CLASS_TYPE_FISTRAZIEL,oPC) > 0)          ExecuteScript("prc_fistraziel", oPC);
    if(GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC) > 0)          ExecuteScript("prc_sacredfist", oPC);
    if(GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,oPC) > 0)   ExecuteScript("prc_initdraconic", oPC);
    if(GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC) > 0)         ExecuteScript("prc_bladesinger", oPC);
    if(GetLevelByClass(CLASS_TYPE_HEXTOR,oPC) > 0)              ExecuteScript("prc_hextor", oPC);
    if(GetLevelByClass(CLASS_TYPE_ARCHER,oPC) > 0)              ExecuteScript("prc_archer", oPC);
    if(GetLevelByClass(CLASS_TYPE_TEMPUS,oPC) > 0)              ExecuteScript("prc_battletempus", oPC);
    if(GetLevelByClass(CLASS_TYPE_DISPATER,oPC) > 0)            ExecuteScript("prc_dispater", oPC);
    if(GetLevelByClass(CLASS_TYPE_MANATARMS,oPC) > 0)           ExecuteScript("prc_manatarms", oPC);
    if(GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,oPC) > 0)    ExecuteScript("prc_soldoflight", oPC);
    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC,oPC) > 0)      ExecuteScript("prc_henshin", oPC);
    if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER,oPC) > 0)      ExecuteScript("prc_drunk", oPC);
    if(GetLevelByClass(CLASS_TYPE_MASTER_HARPER,oPC) > 0)       ExecuteScript("prc_masterh", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHOU,oPC) > 0)                ExecuteScript("prc_shou", oPC);
    if(GetLevelByClass(CLASS_TYPE_BFZ,oPC) > 0)                 ExecuteScript("prc_bfz", oPC);
    if(GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER,oPC) > 0)    ExecuteScript("prc_bondedsumm", oPC);
    if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oPC) > 0)        ExecuteScript("prc_shadowadept", oPC);
    if(GetLevelByClass(CLASS_TYPE_BRAWLER,oPC) > 0)             ExecuteScript("prc_brawler", oPC);
    if(GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE,oPC) > 0)       ExecuteScript("prc_minstrel", oPC);
    if(GetLevelByClass(CLASS_TYPE_NIGHTSHADE,oPC) > 0)          ExecuteScript("prc_nightshade", oPC);
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED,oPC) > 0)         ExecuteScript("prc_runescarred", oPC);
    if(GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER,oPC) > 0)     ExecuteScript("prc_uranger", oPC);

    // Feats are checked here
    if(GetHasFeat(FEAT_SAC_VOW, oPC) >0)                        ExecuteScript("prc_vows", oPC);
    if(GetHasFeat(FEAT_LICHLOVED, oPC) >0)                      ExecuteScript("prc_lichloved", oPC);
    if(GetHasFeat(FEAT_EB_HAND, oPC) >0)                        ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_EB_HEAD, oPC) >0)                        ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_EB_CHEST, oPC) >0)                       ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_EB_ARM, oPC) >0)                         ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_EB_NECK, oPC) >0)                        ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC))                  ExecuteScript("prc_vilefeats", oPC);
    if(GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC))                 ExecuteScript("prc_vilefeats", oPC);
    if(GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC))                 ExecuteScript("prc_vilefeats", oPC);
    if (GetHasFeat(FEAT_VIGIL_ARMOR, oPC))                      ExecuteScript("ft_vigil_armor", oPC);
    if(GetHasFeat(FEAT_BOWMASTERY, oPC) ||
       GetHasFeat(FEAT_XBOWMASTERY, oPC) ||
       GetHasFeat(FEAT_SHURIKENMASTERY, oPC))                   ExecuteScript("prc_weapmas", oPC);
    if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) ||
       GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))                   ExecuteScript("prc_intuiatk", oPC);

    if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC)
       && GetLevelByClass(CLASS_TYPE_TEMPEST, oPC) == 0)        ExecuteScript("ft_gtwf", oPC);
       
    // Miscellaneous
    ExecuteScript("ft_sanctmartial",oPC);
    ExecuteScript("prc_wyzfeat",oPC);
    ExecuteScript("onenter_ess",oPC);
    ExecuteScript("prc_sneak_att",oPC);
}



void DeletePRCLocalInts(object oSkin)
{
    // In order to work with the PRC system we need to delete some locals for each
    // PRC that has a hide
    // Duelist
    DeleteLocalInt(oSkin,"DiscMephResist");
    DeleteLocalInt(oSkin,"GraceBonus");
    DeleteLocalInt(oSkin,"ElaborateParryBonus");
    DeleteLocalInt(oSkin,"CannyDefenseBonus");
    // Elemental Savants
    DeleteLocalInt(oSkin,"ElemSavantResist");
    DeleteLocalInt(oSkin,"ElemSavantPerfection");
    DeleteLocalInt(oSkin,"ElemSavantImmMind");
    DeleteLocalInt(oSkin,"ElemSavantImmParal");
    DeleteLocalInt(oSkin,"ElemSavantImmSleep");
    // HeartWarder
    DeleteLocalInt(oSkin, "HeartPassionA");
    DeleteLocalInt(oSkin, "HeartPassionP");
    DeleteLocalInt(oSkin, "HeartPassionPe");
    DeleteLocalInt(oSkin, "HeartPassionT");
    DeleteLocalInt(oSkin, "HeartPassionUMD");
    DeleteLocalInt(oSkin, "HeartPassionB");
    DeleteLocalInt(oSkin, "HeartPassionI");
    DeleteLocalInt(oSkin,"FeyType");
    DeleteLocalInt(oSkin, "HeartWardCharBonus");
    // MageKiller
    DeleteLocalInt(oSkin,"MKFortBonus");
    DeleteLocalInt(oSkin,"MKRefBonus");
    // Master Harper
    DeleteLocalInt(oSkin,"MHLycanbane");
    DeleteLocalInt(oSkin,"MHMililEar");
    DeleteLocalInt(oSkin,"MHDeneirsOrel");
    DeleteLocalInt(oSkin,"MHHarperKnowledge");
    // OozeMaster
    DeleteLocalInt(oSkin,"OozeChaPen");
    DeleteLocalInt(oSkin,"IndiscernibleCrit");
    DeleteLocalInt(oSkin,"IndiscernibleBS");
    DeleteLocalInt(oSkin,"OneOozeMind");
    DeleteLocalInt(oSkin,"OneOozePoison");
    // Storm lord
    DeleteLocalInt(oSkin,"StormLResElec");
    // Spell sword
    DeleteLocalInt(oSkin,"SpellswordSFBonusNormal");
    DeleteLocalInt(oSkin,"SpellswordSFBonusEpic");
    // Acolyte of the skin
    DeleteLocalInt(oSkin,"AcolyteSkinBonus");
    DeleteLocalInt(oSkin,"AcolyteSymbBonus");
    DeleteLocalInt(oSkin,"AcolyteStatBonusCon");
    DeleteLocalInt(oSkin,"AcolyteStatBonusDex");
    DeleteLocalInt(oSkin,"AcolyteStatBonusInt");
    DeleteLocalInt(oSkin,"AcolyteResistanceCold");
    DeleteLocalInt(oSkin,"AcolyteResistanceFire");
    DeleteLocalInt(oSkin,"AcolyteResistanceAcid");
    DeleteLocalInt(oSkin,"AcolyteResistanceElectric");
    DeleteLocalInt(oSkin,"AcolyteStatBonusDex");
    // Vassal of Bahamut
    DeleteLocalInt(oSkin, "ImperiousAura");
    // Disciple of Baalzebul
    DeleteLocalInt(oSkin, "KingofLies");
    DeleteLocalInt(oSkin, "TongueoftheDevil");
    // Battleguard of Tempus
    DeleteLocalInt(oSkin,"FEAT_WEAP_TEMPUS");
    DeleteLocalInt(oSkin,"Tempus_Lore");
    DeleteLocalInt(oSkin,"BatForgerW");
    // Blood Archer
    DeleteLocalInt(oSkin,"Acidblood");
    DeleteLocalInt(oSkin,"Level3");
    DeleteLocalInt(oSkin,"Level6");
    DeleteLocalInt(oSkin,"Level9");
    // Bonded Summoner
    DeleteLocalInt(oSkin,"BondResEle");
    DeleteLocalInt(oSkin,"ImmuEle");
    DeleteLocalInt(oSkin,"BondSubType");
    // Disciple of Meph
    DeleteLocalInt(oSkin,"DiscMephResist");
    DeleteLocalInt(oSkin,"DiscMephGlove");
    // Disciple of Dispater
    DeleteLocalInt(oSkin,"DeviceLore");
    DeleteLocalInt(oSkin,"IPowerBonus");
    // Evil Brand
    DeleteLocalInt(oSkin,"EvilbrandPe");
    // Initiate of Draconic Mysteries
    DeleteLocalInt(oSkin,"IniSR");
    DeleteLocalInt(oSkin,"IniStunStrk");
    // Lich Loved
    DeleteLocalInt(oSkin,"LichLovedD");
    // Man at Arms
    DeleteLocalInt(oSkin,"ManArmsGenSpe");
    DeleteLocalInt(oSkin,"ManArmsDmg");
    DeleteLocalInt(oSkin,"ManArmsCore");
    // Peerless Archer
    DeleteLocalInt(oSkin,"PABowyer");
    // Prereq Feats
    DeleteLocalInt(oSkin,"EnduranceBonus");
    DeleteLocalInt(oSkin,"TrackSkill");
    DeleteLocalInt(oSkin,"Ethran");
    // Telflammar Shadowlord
    DeleteLocalInt(oSkin,"ShaDiscorp");
    // Vile Feats
    DeleteLocalInt(oSkin,"DeformObeseCon");
    DeleteLocalInt(oSkin,"DeformGauntDex");
    DeleteLocalInt(oSkin,"WillDeform");
    // Vow Feats
    DeleteLocalInt(oSkin,"SacredVow");
    DeleteLocalInt(oSkin,"VowObed");
    // Vigilant
    DeleteLocalInt(oSkin,"VigilantSkinBonus");
    // Bladesinger
    DeleteLocalInt(oSkin,"BladesAC");
    DeleteLocalInt(oSkin,"BladesCon");
    // Sneak Attack
    DeleteLocalInt(oSkin,"RogueSneakDice");
    DeleteLocalInt(oSkin,"BlackguardSneakDice");
    // Sacred Fist
    DeleteLocalInt(oSkin,"SacFisAC");
    DeleteLocalInt(oSkin,"SacFisMv"); 
    // Brawler
    DeleteLocalInt(oSkin,"BrawlerDodge");
    DeleteLocalInt(oSkin,"BrawlerFinesse");
    // Minstrel
    DeleteLocalInt(oSkin,"MinstrelSFBonus");
    // Nightshade
    DeleteLocalInt(oSkin,"ImmuNSWeb");
    DeleteLocalInt(oSkin,"ImmuNSPoison");
    // Soldier of Light
    DeleteLocalInt(oSkin,"ImmuPF");
    DeleteLocalInt(oSkin,"SoLFH");
    

    // future PRCs Go below here
}


void ScrubPCSkin(object oPC, object oSkin)
{
    int iCode = GetHasFeat(FEAT_SF_CODE,oPC);
    itemproperty ip = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ip)) {
        // Insert Logic here to determine if we spare a property
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT) {
            // Check for specific Bonus Feats
            // Reference iprp_feats.2da
            int st = GetItemPropertySubType(ip);

            // Spare 400 through 570 except for 428 (currently unknown)
            if (st < 400 || st > 570 || st == 428 )
                RemoveItemProperty(oSkin, ip);
        }
        else
            RemoveItemProperty(oSkin, ip);

        // Get the next property
        ip = GetNextItemProperty(oSkin);
    }
    if (iCode) 
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(381),oSkin);

}


int CompareAlignment(object oSource, object oTarget)
{
    int iStepDif;
    int iGE1 = GetAlignmentGoodEvil(oSource);
    int iLC1 = GetAlignmentLawChaos(oSource);
    int iGE2 = GetAlignmentGoodEvil(oTarget);
    int iLC2 = GetAlignmentLawChaos(oTarget);

    if(iGE1 == ALIGNMENT_GOOD){
        if(iGE2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iGE2 == ALIGNMENT_EVIL)
            iStepDif += 2;
    }
    if(iGE1 == ALIGNMENT_NEUTRAL){
        if(iGE2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iGE1 == ALIGNMENT_EVIL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_GOOD)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_LAWFUL){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_CHAOTIC)
            iStepDif += 2;
    }
    if(iLC1 == ALIGNMENT_NEUTRAL){
        if(iLC2 != ALIGNMENT_NEUTRAL)
            iStepDif += 1;
    }
    if(iLC1 == ALIGNMENT_CHAOTIC){
        if(iLC2 == ALIGNMENT_NEUTRAL)
            iStepDif += 1;
        if(iLC2 == ALIGNMENT_LAWFUL)
            iStepDif += 2;
    }
    return iStepDif;
}

int BlastInfidelOrFaithHeal(object oCaster, object oTarget, int iEnergyType, int iDisplayFeedback)
{
    //Don't bother doing anything if iEnergyType isn't either positive/negative energy
    if(iEnergyType != DAMAGE_TYPE_POSITIVE && iEnergyType != DAMAGE_TYPE_NEGATIVE)
        return FALSE;

    //If the target is undead and damage type is negative
    //or if the target is living and damage type is positive
    //then we're healing.  Otherwise, we're harming.
    int iHeal = ( MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && iEnergyType == DAMAGE_TYPE_NEGATIVE ) ||
                ( MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD && iEnergyType == DAMAGE_TYPE_POSITIVE );
    int iRetVal = FALSE;
    int iAlignDif = CompareAlignment(oCaster, oTarget);
    string sFeedback = "";

    if(iHeal){
        if((GetHasFeat(FEAT_FAITH_HEALING, oCaster) && iAlignDif <= 2)){
            iRetVal = TRUE;
            sFeedback = "Faith Healing";
        }
    }
    else{
        if((GetHasFeat(FEAT_BLAST_INFIDEL, oCaster) && iAlignDif >= 2)){
            iRetVal = TRUE;
            sFeedback = "Blast Infidel";
        }
    }

    if(iDisplayFeedback) FloatingTextStringOnCreature(sFeedback, oCaster);
    return iRetVal;
}




///////////////////////////////////////////////////////////////
//  GetArmorType
///////////////////////////////////////////////////////////////
const int ARMOR_TYPE_CLOTH      = 0;
const int ARMOR_TYPE_LIGHT      = 1;
const int ARMOR_TYPE_MEDIUM     = 2;
const int ARMOR_TYPE_HEAVY      = 3;

// returns -1 on error, or base AC of armor
int GetItemACBase(object oArmor)
{
    int nBonusAC = 0;

    // oItem is not armor then return an error
    if(GetBaseItemType(oArmor) != BASE_ITEM_ARMOR)
        return -1;

    // check each itemproperty for AC Bonus
    itemproperty ipAC = GetFirstItemProperty(oArmor);

    while(GetIsItemPropertyValid(ipAC))
    {
        int nType = GetItemPropertyType(ipAC);

        // check for ITEM_PROPERTY_AC_BONUS
        if(nType == ITEM_PROPERTY_AC_BONUS)
        {
            nBonusAC = GetItemPropertyCostTableValue(ipAC);
            break;
        }

        // get next itemproperty
        ipAC = GetNextItemProperty(oArmor);
    }

    // return base AC
    return GetItemACValue(oArmor) - nBonusAC;
}

// returns -1 on error, or the const int ARMOR_TYPE_*
int GetArmorType(object oArmor)
{
    int nType = -1;

    // get and check Base AC
    switch(GetItemACBase(oArmor) )
    {
        case 0: nType = ARMOR_TYPE_CLOTH;   break;
        case 1: nType = ARMOR_TYPE_LIGHT;   break;
        case 2: nType = ARMOR_TYPE_LIGHT;   break;
        case 3: nType = ARMOR_TYPE_LIGHT;   break;
        case 4: nType = ARMOR_TYPE_MEDIUM;  break;
        case 5: nType = ARMOR_TYPE_MEDIUM;  break;
        case 6: nType = ARMOR_TYPE_HEAVY;   break;
        case 7: nType = ARMOR_TYPE_HEAVY;   break;
        case 8: nType = ARMOR_TYPE_HEAVY;   break;
    }

    // return type
    return nType;
}