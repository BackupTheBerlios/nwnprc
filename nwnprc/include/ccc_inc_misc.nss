/**
 * convoCC misc functions
 */

#include "inc_utility"
#include "prc_alterations"
#include "inc_letoscript"
#include "inc_letocommands"
#include "inc_dynconv"
#include "prc_ccc_const"

// checks if it's a multiplayer game and that letoscript is set up correctly
// returns 0 for pass and 1 for fail
int DoLetoscriptTest(object oPC);

// makes a string based on the PC name and player public CD key
string Encrypt(object oPC);

// removes all equipped items from the PC
// that means ALL items, even plot ones
void DoStripPC(object oPC);

// checks if oPC is valid and in an area then boots them
void CheckAndBoot(object oPC);

/**
 * main cutscene function
 * letoscript changes to the PC clone are done via this function
 * nSetup indicates whether the cutscene needs seting up or not
 */
void DoCutscene(object oPC, int nSetup = FALSE);

/**
 * Cutscene pseudo HB functions
 */
 
// used to cleanup clones when a player leaves
void CloneMasterCheck();

// sets up the camera to rotate around the clone 
// and the clone do random animations
void DoRotatingCamera(object oPC);

/**
 * functions to set appearance, portrait, soundset
 */
 
// sets race appearance as defined in racialtype.2da
// removes wings, tails and undead graft arm as well as making invisible bits visible
void DoSetRaceAppearance(object oPC);
 
// assigns the ccc chosen gender to the clone and resets the soundset
// if it's changed
void DoCloneGender(object oPC);

// deletes local variables stored on the PC before the player is booted to make the new character
void DoCleanup();

// set up the ability choice in "<statvalue> (racial <+/-modifier>) <statname>. Cost to increase <cost>" format
void AddAbilityChoice(int nStatValue, string sStatName, string sRacialAdjust, int nAbilityConst);

// subtracts the correct amount of points for increasing the current ability score
// returns the current ability score incremented by 1
int IncreaseAbilityScore(int nCurrentAbilityScore);

//this returns the cost to get to a score
//or the cost saved by dropping from that score
int GetCost(int nAbilityScore);

// works out the next stage to go to between STAGE_FEAT_CHECK and STAGE_APPEARANCE
// when given the stage just completed
// covers caster and familiar related choices
int GetNextCCCStage(int nStage);

// checks if the PC has the two feats given as arguements
// '****' as an arguement is treated as an automatic TRUE for that arguement
// used to check if the PC meets the prerequisites in the PreReqFeat1 AND PreReqFeat2
// columns of feat.2da
int GetMeetsANDPreReq(string sPreReqFeat1, string sPreReqFeat2);

// checks if the PC has any one of the 5 feats given as arguements
// '****' as an arguement is treated as an automatic TRUE for that arguement
// used to check if the PC meets the prerequisites in the OrReqFeat0 OR OrReqFeat1 
// OR OrReqFeat2 OR OrReqFeat3 OR OrReqFeat4 columns of feat.2da
int GetMeetsORPreReq(string sOrReqFeat0, string sOrReqFeat1, string sOrReqFeat2, string sOrReqFeat3, string sOrReqFeat4);

// loops through the feat array on the PC to see if it has nReqFeat
int PreReqFeatArrayLoop(int nReqFeat);

// checks if the PC has enough skill ranks in the two skills
// '****' as ReqSkill arguement is treated as an automatic TRUE for that arguement
// used to check if the PC meets the prerequisites in the ReqSkill AND ReqSkill2
// columns of feat.2da
int GetMeetSkillPrereq(string sReqSkill, string sReqSkill2, string sReqSkillRanks,  string sReqSkillRanks2);

// checks if the PC has enough points in sReqSkill
int CheckSkillPrereq(string sReqSkill, string sReqSkillRanks);

// adds all the cantrips to a wizard's spellbook
void SetWizCantrips(int iSpellschool);

// loops through the spell array on the PC to see if they already know the spell
// returns TRUE if they know it
int GetIsSpellKnown(int nSpell, int nSpellLevel);

/* 2da cache functions */

// loops through a 2da, using the cache
// s2da is the name of the 2da, sColumnName the column to read the values
// from, nFileEnd the number of lines in the 2da
void Do2daLoop(string s2da, string sColumnName, int nFileEnd);

// loops through racialtypes.2da
void DoRacialtypesLoop();

// loops through classes.2da
void DoClassesLoop();

// loops through skills.2da
void DoSkillsLoop();

// loops through feat.2da
void DoFeatLoop(int nClassFeatStage = FALSE);

// loops through cls_feat_***.2da
void DoBonusFeatLoop();

// loops through spells.2da
void DoSpellsLoop(int nStage);

// loops through domains.2da
void  DoDomainsLoop();

// stores the feats found in race_feat_***.2da as an array on the PC
void AddRaceFeats(int nRace);

// stores the feats found in cls_feat_***.2da in the feat array on the PC
void AddClassFeats(int nClass);

// stores the feat listed in domais.2da in the feat array on the PC
void AddDomainFeats();

/* function definitions */

int DoLetoscriptTest(object oPC)
{
    int bBoot;
    //check that its a multiplayer game
    if(GetPCPublicCDKey(oPC) == "")
    {
        SendMessageToPC(oPC, "This module must be hosted as a multiplayer game with NWNX and Letoscript");
        WriteTimestampedLogEntry("This module must be hosted as a multiplayer game with NWNX and Letoscript");
        bBoot = TRUE;
    }

    //check that letoscript is setup correctly
    string sScript;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        sScript = LetoGet("FirstName")+" "+LetoGet("LastName");
    else
        sScript = LetoGet("FirstName")+"print ' ';"+LetoGet("LastName");
        
    StackedLetoScript(sScript);
    RunStackedLetoScriptOnObject(oPC, "LETOTEST", "SCRIPT", "", FALSE);
    string sResult = GetLocalString(GetModule(), "LetoResult");
    string sName = GetName(oPC);
    if((    sResult != sName
         && sResult != sName+" "
         && sResult != " "+sName)
         )
    {
        SendMessageToPC(oPC, "Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        WriteTimestampedLogEntry("Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        bBoot = TRUE;
    }
    
    return bBoot;
}

string Encrypt(object oPC)
{
    string sName = GetName(oPC);
    int nKey = GetPRCSwitch(PRC_CONVOCC_ENCRYPTION_KEY);
    if(nKey == 0)
        nKey = 10;
    string sReturn;

    string sPublicCDKey = GetPCPublicCDKey(oPC);
    int nKeyTotal;
    int i;
    for(i=1;i<GetStringLength(sPublicCDKey);i++)
    {
        nKeyTotal += StringToInt(GetStringLeft(GetStringRight(sPublicCDKey, i),1));
    }
    sReturn = IntToString(nKeyTotal);
    return sReturn;
}

void DoStripPC(object oPC)
{
    // remove equipped items
    int i;
    for(i=0; i<NUM_INVENTORY_SLOTS; i++)
    {
        object oEquip = GetItemInSlot(i,oPC);
        if(GetIsObjectValid(oEquip))
        {
            SetPlotFlag(oEquip,FALSE);
            DestroyObject(oEquip);
        }
    }
    // empty inventory
    object oItem = GetFirstItemInInventory(oPC);
    while(GetIsObjectValid(oItem))
    {
        SetPlotFlag(oItem,FALSE);
        if(GetHasInventory(oItem))
        {
            object oItem2 = GetFirstItemInInventory(oItem);
            while(GetIsObjectValid(oItem2))
            {
                object oItem3 = GetFirstItemInInventory(oItem2);
                while(GetIsObjectValid(oItem3))
                {
                    SetPlotFlag(oItem3,FALSE);
                    DestroyObject(oItem3);
                    oItem3 = GetNextItemInInventory(oItem2);
                }
                SetPlotFlag(oItem2,FALSE);
                DestroyObject(oItem2);
                oItem2 = GetNextItemInInventory(oItem);
            }
        }
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
}

void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void DoSetRaceAppearance(object oPC)
{
    DoDebug(DebugObject2Str(oPC));
    // sets the appearance type
    int nSex = GetLocalInt(oPC, "Gender");
    int nRace = GetLocalInt(oPC, "Race");
    // appearance type switches go here
    if(nRace == RACIAL_TYPE_RAKSHASA
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE);
    else if(nRace == RACIAL_TYPE_DRIDER
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(oPC, APPEARANCE_TYPE_DRIDER_FEMALE);
    else
        SetCreatureAppearanceType(oPC, 
                    StringToInt(Get2DACache("racialtypes", "Appearance",
                        GetLocalInt(oPC, "Race"))));
    
    // remove wings and tails - so this can be set later
    // enforcing wing and tail related switches comes later too
    SetCreatureWingType(CREATURE_WING_TYPE_NONE);
    SetCreatureTailType(CREATURE_TAIL_TYPE_NONE);
    
    // get rid of invisible/undead etc bits, but keep tatoos as is
    SetCreatureBodyPart(CREATURE_PART_RIGHT_FOOT, 1);
    SetCreatureBodyPart(CREATURE_PART_LEFT_FOOT, 1);
    SetCreatureBodyPart(CREATURE_PART_PELVIS, 1);
    SetCreatureBodyPart(CREATURE_PART_BELT, 0);
    SetCreatureBodyPart(CREATURE_PART_NECK, 1);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_SHOULDER, 0);
    SetCreatureBodyPart(CREATURE_PART_LEFT_SHOULDER, 0);
    SetCreatureBodyPart(CREATURE_PART_RIGHT_HAND, 1);
    SetCreatureBodyPart(CREATURE_PART_LEFT_HAND, 1);
    // make invisible heads visible, otherwise leave
    if(GetCreatureBodyPart(CREATURE_PART_HEAD) == 0)
        SetCreatureBodyPart(CREATURE_PART_HEAD, 1);
    // preserve tattoos, get rid of anything else
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_SHIN, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_SHIN) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_SHIN, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_THIGH, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_THIGH) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_THIGH, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_FOREARM, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM) == 1))
        SetCreatureBodyPart(CREATURE_PART_LEFT_FOREARM, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 2);
    if(!(GetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP) == 1))
        SetCreatureBodyPart(CREATURE_PART_RIGHT_BICEP, 2);
}

void DoCloneGender(object oPC)
{
    object oClone = GetLocalObject(oPC, "Clone");
    if(!GetIsObjectValid(oClone))
        return;
    int nSex = GetLocalInt(oPC, "Gender");
    int nCurrentSex = GetGender(oClone);
    StackedLetoScript(LetoSet("Gender", IntToString(nSex), "byte"));
    // if the gender needs changing, reset the soundset
    if (nSex != nCurrentSex)
        StackedLetoScript(LetoSet("SoundSetFile", IntToString(0), "word"));
    string sResult;
    RunStackedLetoScriptOnObject(oClone, "OBJECT", "SPAWN", "prc_ccc_app_lspw", TRUE);
    sResult = GetLocalString(GetModule(), "LetoResult");
    SetLocalObject(GetModule(), "PCForThread"+sResult, oPC);
}

void DoCutscene(object oPC, int nSetup = FALSE)
{
    
    // get what stage we're at
    int nStage = GetStage(oPC);
    DoDebug("DoCutscene() stage is :" + IntToString(nStage) + " nSetup = " + IntToString(nSetup));
    // get whether this function has been called in setting up a stage,
    // in response to a choice or by prc_enter
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);

    // if we are on STAGE_RACE_CHECK 
    // or if we are setting up the cutscene and have got at least that far in the convo
    if (nStage == STAGE_RACE_CHECK || (nStage > STAGE_RACE_CHECK && nSetup))
    {
        DoDebug("DoCutscene() stage is :" + IntToString(nStage) + " nSetup = " + IntToString(nSetup));
        if(!GetIsObjectValid(GetArea(oPC)))
        {
            DelayCommand(1.0, DoCutscene(oPC, nSetup));
            return;
        }

        // set race appearance, remove wings and tails, get rid of
        // invisible/undead etc body parts
        DoSetRaceAppearance(oPC);
        // clone the PC and hide the swap with a special effect
        // make the real PC non-collideable
        effect eGhost = EffectCutsceneGhost();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, oPC, 99999999.9);
        // make the swap and hide with an effect
        effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oPC));
        // make clone
        object oClone = CopyObject(oPC, GetLocation(oPC), OBJECT_INVALID, "PlayerClone");
        ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
        // make the real PC invisible
        effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oPC, 9999.9);
        //make sure the clone stays put
        effect eParal = EffectCutsceneImmobilize();
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oClone, 9999.9);
        // ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oPC, 9999.9);
        // swap local objects
        SetLocalObject(oPC, "Clone", oClone);
        SetLocalObject(oClone, "Master", oPC);
        // this makes sure the clone gets destroyed if the PC leaves the game
        AssignCommand(oClone, CloneMasterCheck());
        // use letoscript to assign the gender
        DoCloneGender(oPC);
        // set up the camera and animations
        DoRotatingCamera(oPC);
    }
}

void CloneMasterCheck()
{
    object oMaster = GetLocalObject(OBJECT_SELF, "Master");
    if(!GetIsObjectValid(oMaster))
    {
        SetIsDestroyable(TRUE);
        DestroyObject(OBJECT_SELF);
    }
    else
        DelayCommand(10.0, CloneMasterCheck());
}

void DoRotatingCamera(object oPC)
{
    if(!GetIsObjectValid(oPC))
        return;
    if(GetLocalInt(oPC, "StopRotatingCamera"))
    {
        DeleteLocalInt(oPC, "StopRotatingCamera");
        DeleteLocalFloat(oPC, "DoRotatingCamera");
        return;
    }
    float fDirection = GetLocalFloat(oPC, "DoRotatingCamera");
    fDirection += 30.0;
    if(fDirection > 360.0)
        fDirection -= 360.0;
    if(fDirection <= 0.0)
        fDirection += 360.0;
    SetLocalFloat(oPC, "DoRotatingCamera", fDirection);
    SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    SetCameraFacing(fDirection, 4.0, 45.0, CAMERA_TRANSITION_TYPE_VERY_SLOW);
    DelayCommand(6.0, DoRotatingCamera(oPC));
    //its the clone not the PC that does things
    object oClone = GetLocalObject(oPC, "Clone");
    if(GetIsObjectValid(oClone))
        oPC = oClone;
    if(d2()==1)
        AssignCommand(oPC, ActionPlayAnimation(100+Random(17)));
    else
        AssignCommand(oPC, ActionPlayAnimation(100+Random(21), 1.0, 6.0));
}

void DoCleanup()
{
    object oPC = OBJECT_SELF;
    // go through the ones used to make the character
    // delete some ints
    DeleteLocalInt(oPC, "Str");
    DeleteLocalInt(oPC, "Dex");
    DeleteLocalInt(oPC, "Con");
    DeleteLocalInt(oPC, "Int");
    DeleteLocalInt(oPC, "Wis");
    DeleteLocalInt(oPC, "Cha");

    DeleteLocalInt(oPC, "Race");

    DeleteLocalInt(oPC, "Class");
    DeleteLocalInt(oPC, "HitPoints");

    DeleteLocalInt(oPC, "Gender");

    DeleteLocalInt(oPC, "LawfulChaotic");
    DeleteLocalInt(oPC, "GoodEvil");

    DeleteLocalInt(oPC, "Familiar");
    DeleteLocalInt(oPC, "Companion");

    DeleteLocalInt(oPC, "Domain1");
    DeleteLocalInt(oPC, "Domain2");

    DeleteLocalInt(oPC, "School");
    
    DeleteLocalInt(oPC, "SpellsPerDay0");
    DeleteLocalInt(oPC, "SpellsPerDay1");
    
    // delete some arrays
    array_delete(oPC, "spellLvl0");
    array_delete(oPC, "spellLvl1");
    array_delete(oPC, "Feats");
    array_delete(oPC, "Skills");
}


void AddAbilityChoice(int nAbilityScore, string sAbilityName, string sRacialAdjust, int nAbilityConst)
{
    // if it is still possible to increase the ability score, add that choice
    if (nAbilityScore < GetLocalInt(OBJECT_SELF, "MaxStat") && GetLocalInt(OBJECT_SELF, "Points") >= GetCost(nAbilityScore + 1))
    {
        AddChoice(sAbilityName + " " + IntToString(nAbilityScore) + " (Racial " + sRacialAdjust + "). " 
            + GetStringByStrRef(137) + " " + IntToString(GetCost(nAbilityScore + 1)), nAbilityConst);
    }
}

int IncreaseAbilityScore(int nCurrentAbilityScore)
{
    int nPoints = GetLocalInt(OBJECT_SELF, "Points");
    // get cost and remove from total
    // note: because of how GetCost() works, the ability score is incremented here not later
    nPoints -= GetCost(++nCurrentAbilityScore);
    // store the total points left on the PC
    SetLocalInt(OBJECT_SELF, "Points", nPoints);
    return nCurrentAbilityScore;
}

int GetCost(int nAbilityScore)
{
    int nCost = (nAbilityScore-11)/2;
    if(nCost < 1)
        nCost = 1;
    return nCost;
}

int GetNextCCCStage(int nStage)
{
    // check we're in the right place
    if (nStage < STAGE_FEAT_CHECK)
        return -1; // sent here too early
    // get some info
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    switch (nStage) // with no breaks to go all the way through
    {
        case STAGE_FEAT_CHECK: {
            if(nClass == CLASS_TYPE_WIZARD)
            {
                return STAGE_WIZ_SCHOOL;
            }
        }
        case STAGE_WIZ_SCHOOL_CHECK: {
            if (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_BARD)
            {
                return STAGE_SPELLS_0;
            }
            else if (nClass == CLASS_TYPE_WIZARD)
            {
                return STAGE_SPELLS_1;
            }
        }
        case STAGE_SPELLS_0: {
            if (nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_BARD)
            {
                string sSpkn = Get2DACache("classes", "SpellKnownTable", nClass);
                // if they can pick level 1 spells
                if (StringToInt(Get2DACache(sSpkn, "SpellLevel1", 0)))
                    return STAGE_SPELLS_1;
            }       
        }
        case STAGE_SPELLS_1: {
            if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_BARD)
            {
                return STAGE_SPELLS_CHECK; // checks both 0 and 1 level spells
            }
        }
        case STAGE_SPELLS_CHECK: {
            if (nClass == CLASS_TYPE_WIZARD || nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_DRUID)
            {
                return STAGE_FAMILIAR; // also does animal companion
            }
        }
        case STAGE_FAMILIAR_CHECK: {
            if (nClass == CLASS_TYPE_CLERIC)
            {
                return STAGE_DOMAIN;
            }
        }
        default:
            return STAGE_APPEARANCE;
    }
    return -1; // silly compiler
}

int GetMeetsANDPreReq(string sPreReqFeat1, string sPreReqFeat2)
{
    // are there any prereq?
    if (sPreReqFeat1 == "****" && sPreReqFeat2 == "****")
        return TRUE;
    // test if the PC meets the first prereq
    // if not, exit
    if(!PreReqFeatArrayLoop(StringToInt(sPreReqFeat1)))
        return FALSE;
    // got this far, then the first prereq was met
    // is there a second prereq? If not, done
    if (sPreReqFeat2 == "****")
        return TRUE;
    // test if the PC meets the second one
    if(!PreReqFeatArrayLoop(StringToInt(sPreReqFeat2)))
        return FALSE;
    // got this far, so second one matched too
    return TRUE;
}

int GetMeetsORPreReq(string sOrReqFeat0, string sOrReqFeat1, string sOrReqFeat2, string sOrReqFeat3, string sOrReqFeat4)
{
    // are there any prereq
    if (sOrReqFeat0 == "****")
        return TRUE;
    // first one
    if(PreReqFeatArrayLoop(StringToInt(sOrReqFeat0)))
        return TRUE;
    // second one
    if(PreReqFeatArrayLoop(StringToInt(sOrReqFeat1)))
        return TRUE;
    // third one
    if(PreReqFeatArrayLoop(StringToInt(sOrReqFeat2)))
        return TRUE;
    // 4th one
    if(PreReqFeatArrayLoop(StringToInt(sOrReqFeat3)))
        return TRUE;
    // 5th one
    if(PreReqFeatArrayLoop(StringToInt(sOrReqFeat4)))
        return TRUE;
    // no match
    return FALSE;
}

int PreReqFeatArrayLoop(int nOrReqFeat)
{
    // as alertness is stored in the array as -1
    if (nOrReqFeat == 0)
        nOrReqFeat == -1;
    int i = 0;
    while (i != array_get_size(OBJECT_SELF, "Feats"))
    {
        int nFeat  = array_get_int(OBJECT_SELF, "Feats", i);
        if(nFeat == nOrReqFeat) // if there's a match, the prereq are met
            return TRUE;
        i++;
    }
    // otherwise no match
    return FALSE;
}

int GetMeetSkillPrereq(string sReqSkill, string sReqSkill2, string sReqSkillRanks,  string sReqSkillRanks2)
{
    if(sReqSkill == "****" && sReqSkill2 == "****")
        return TRUE;
    // test if the PC meets the first prereq
    if(!CheckSkillPrereq(sReqSkill, sReqSkillRanks))
        return FALSE;
    
    // got this far, then the first prereq was met
	// is there a second prereq? If not, done
    if(sReqSkill2 == "****")
        return TRUE;
    if(!CheckSkillPrereq(sReqSkill2, sReqSkillRanks2))
        return FALSE;
    // got this far, so second one matched too
    return TRUE;
}

int CheckSkillPrereq(string sReqSkill, string sReqSkillRanks)
{
    // for skill focus feats
    if (sReqSkillRanks == "0" || sReqSkillRanks == "****") // then it just requires being able to put points in the skill
    {
        // if requires animal empathy, but the PC can't take ranks in it
        if(sReqSkill == "0" && !GetLocalInt(OBJECT_SELF, "bHasAnimalEmpathy"))
            return FALSE;
        // if requires UMD, but the PC can't take ranks in it
        if(sReqSkill == IntToString(SKILL_USE_MAGIC_DEVICE) && !GetLocalInt(OBJECT_SELF, "bHasUMD"))
            return FALSE;
    }
    else // test if the PC has enough ranks in the skill
    {
        int nSkillPoints = array_get_int(OBJECT_SELF, "Skills", StringToInt(sReqSkill));
        if (nSkillPoints < StringToInt(sReqSkillRanks))
            return FALSE;
    }
    // get this far then not failed any of the prereq
    return TRUE;
}

void SetWizCantrips(int iSpellschool)
{
    string sOpposition = "";
    // if not a generalist
    if(iSpellschool)
    {
        sOpposition = Get2DACache("spellschools", "Letter", StringToInt(Get2DACache("spellschools", "Opposition", iSpellschool)));
    }
    
    array_create(OBJECT_SELF, "SpellLvl0");
    string q = PRC_SQLGetTick();
    string sSQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Wiz_Sorc"+q+" = '0') AND ("+q+"School"+q+" != '"+sOpposition+"')";
    PRC_SQLExecDirect(sSQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        int nRow = StringToInt(PRC_SQLGetData(1));
        array_set_int(OBJECT_SELF, "SpellLvl0", array_get_size(OBJECT_SELF, "SpellLvl0"),nRow);
    }
}

int GetIsSpellKnown(int nSpell, int nSpellLevel)
{
    // spell 0 is a level 6 spell, so no need to do the 0 == -1 workaround
    int i = 0;
    string sArray = "SpellLvl" + IntToString(nSpellLevel);
    // if the array doesn't exist then there won't be a match
    if (!array_exists(OBJECT_SELF, sArray))
        return FALSE;
    while (i != array_get_size(OBJECT_SELF, sArray))
    {
        int nKnownSpell  = array_get_int(OBJECT_SELF, sArray, i);
        if(nKnownSpell == nSpell) // if there's a match, don't add it
            return TRUE;
        i++;
    }
    // otherwise no match
    return FALSE;
}

void Do2daLoop(string s2da, string sColumnName, int nFileEnd)
{
    int i = 0;
    string sName;
    sName = Get2DACache(s2da, sColumnName, i);
    while(i < nFileEnd)
    {
        AddChoice(GetStringByStrRef(StringToInt(sName)), i);
        i++;
        sName = Get2DACache(s2da, sColumnName, i);
    }
}

void DoRacialtypesLoop()
{
    // remove if decide not to make the convo wait
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    // get the table/column name quote mark
    string q = PRC_SQLGetTick();
    // get the results 25 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    /* SELECT statement
    SELECT rowid, Name FROM prc_cached2da_racialtypes
    WHERE PlayerRace = 1
    LIMIT 25 OFFSET <nReali>
    */
    string sSQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_racialtypes"+q+" WHERE ("+q+"PlayerRace"+q+" = 1) LIMIT 25 OFFSET "+IntToString(nReali);
    PRC_SQLExecDirect(sSQL);
    // to keep track of where in the 25 rows we stop getting a result
    int nCounter = 0;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
        int nRace = StringToInt(PRC_SQLGetData(1)); // rowid
        int bIsTakeable = TRUE;
        
        // check for right drow gender IF the switch is set
        if(GetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER))
        {
            if(nRace == RACIAL_TYPE_DROW_FEMALE
                && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_MALE)
                bIsTakeable = FALSE;
            if(nRace == RACIAL_TYPE_DROW_MALE
                && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_FEMALE)
                bIsTakeable = FALSE;
        }
        
        // add the choices, choice number is race rowid/constant value
        if(bIsTakeable)
        {
            string sName = GetStringByStrRef(StringToInt(PRC_SQLGetData(2)));
            AddChoice(sName, nRace);
        }
    }
    
    // IF there were 25 rows, carry on
    if(nCounter == 25)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+25);
        DelayCommand(0.01, DoRacialtypesLoop());
    }
    else // there were less than 25 rows, it's the end of the 2da
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
}

void DoClassesLoop()
{
    // remove if decide not to make the convo wait
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    // get the table/column name quote mark
    string q = PRC_SQLGetTick();
    // get the results 25 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    /*
    SELECT `rowid`, `PreReqTable` FROM `prc_cached2da_classes`
    WHERE (`PlayerClass` = 1) AND (`XPPenalty` = 1) 
    LIMIT 25 OFFSET <nReali>
    */
    string sSQL = "SELECT "+q+"rowid"+q+", "+q+"PreReqTable"+q+" FROM "+q+"prc_cached2da_classes"+q+" WHERE ("+q+"PlayerClass"+q+" = 1) AND ("+q+"XPPenalty"+q+" = 1) LIMIT 25 OFFSET "+IntToString(nReali);
    PRC_SQLExecDirect(sSQL);
    // to keep track of where in the 25 rows we stop getting a result
    int nCounter = 0;
    int nClass;
    string sPreReq, sReqType, sParam1, sParam2;
    // this needs storing in a temp array because the 2da cache retrieval will clear
    // the query above if both steps are done in the same loop
    // two parallel arrays as there's no struct arrays
    array_create(OBJECT_SELF, "temp_classes");
    array_create(OBJECT_SELF, "temp_class_prereq");
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
        nClass = StringToInt(PRC_SQLGetData(1)); // rowid
        array_set_int(OBJECT_SELF, "temp_classes", array_get_size(OBJECT_SELF, "temp_classes"), nClass);
        sPreReq = PRC_SQLGetData(2); // PreReq tablename
        array_set_string(OBJECT_SELF, "temp_class_prereq", array_get_size(OBJECT_SELF, "temp_class_prereq"), sPreReq);

    }
    
    // loop through the temp array to check for banned classes
    int i;
    for (i=0; i < array_get_size(OBJECT_SELF, "temp_classes"); i++)
    {
        nClass = array_get_int(OBJECT_SELF, "temp_classes", i); // class
        sPreReq = array_get_string(OBJECT_SELF, "temp_class_prereq", i); // prereq table name
        int j = 0;
        // check if this base class is allowed
        do
        {
            sReqType = Get2DACache(sPreReq, "ReqType", j);
            if (sReqType == "VAR") // if we've found the class allowed variable
            {
                sParam1 = Get2DACache(sPreReq, "ReqParam1", j);
                if(!GetLocalInt(OBJECT_SELF, sParam1)) // if the class is allowed
                {
                    // adds the class to the choice list
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
                    AddChoice(sName, nClass);
                }
            } // end of if (sReqType == "VAR")
            j++;
            
        } while (sReqType != "VAR"); // terminates as soon as we get the allowed variable
        
    } // end of for loop
    // clean up
    array_delete(OBJECT_SELF, "temp_classes");
    array_delete(OBJECT_SELF, "temp_class_prereq");
    
    // IF there were 25 rows, carry on
    if(nCounter == 25)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+25);
        DelayCommand(0.01, DoClassesLoop());
    }
    else // there were less than 25 rows, it's the end of the 2da
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
}

void DoSkillsLoop()
{
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
    {
        // add the "store" option
        AddChoice("Store all remaining points.", -2);
    }
    // get the cls_skill_*** 2da to use
    string sFile = Get2DACache("classes", "SkillsTable", GetLocalInt(OBJECT_SELF, "Class"));
    // too convoluted to do via SQL..meh
    // set up the while
    int i = 0;
    // because with strings, "0" (Animal Empathy) and "" (blank entry) are different
    string sSkillIndex = Get2DACache(sFile, "SkillIndex", i);
    // loop over each valid row - as soon as we hit an empty line, quit
    while(sSkillIndex != "")
    {
        int nPoints = GetLocalInt(OBJECT_SELF, "Points");
        // see if it's class or cross-class
        int nClassSkill = StringToInt(Get2DACache(sFile, "ClassSkill", i));
        int nSkillID = StringToInt(sSkillIndex); // line of skills.2da for the skill
        // get the skill name
        string sName = GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", nSkillID)));
        if (nClassSkill == 1) // class skill
        {
            sName += " " + GetStringByStrRef(52951); // (Class Skill)
            // check there's not already 4 points in there
            int nStoredPoints = array_get_int(OBJECT_SELF, "Skills", nSkillID);
            if (nStoredPoints < 4) // level (ie 1) + 3
            {
                sName += " : "+IntToString(nStoredPoints);
                // only add if there's less than the maximum points allowed
                AddChoice(sName, i); // uses cls_skill_*** rowid as choice number
            }
        }
        else // cross-class skill
        {
            // check there's not already 2 points in there
            int nStoredPoints = array_get_int(OBJECT_SELF, "Skills", nSkillID);
            // if there's only 1 point left, then no cross class skills
            if (nStoredPoints < 2 && nPoints > 1) // level (ie 1) + 1
            {
                sName += " : "+IntToString(nStoredPoints);
                // only add if there's less than the maximum points allowed
                AddChoice(sName, i); // uses cls_skill_*** rowid as choice number
            }
        }
        i++; // go to next line
        sSkillIndex = Get2DACache(sFile, "SkillIndex", i);
    }
    // if the dynamic convo is set waiting (first time through only)
    // then mark as done
    if (GetLocalInt(OBJECT_SELF, "DynConv_Waiting"))
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
    }
}

void DoFeatLoop(int nClassFeatStage = FALSE)
{
    /* TODO - class feats, scripting feat enforcement */
    // get the table/column name quote mark
    string q = PRC_SQLGetTick();
    object oPC = OBJECT_SELF;
    
    // check if UMD and animal empathy can be taken for prereq for the skill focus feats
    // done here because reading the 2da cache clears out any existing SQL results
    // note: any other skill that is restricted to certain classes needs to be hardcoded here
    string sFile = Get2DACache("classes", "SkillsTable", GetLocalInt(oPC, "Class"));
    
    /*
     * SELECT SkillIndex FROM <cls_skill_***> WHERE SkillIndex = <skill>
     */
    
    // query to see if animal empathy is on that list
    string sSkillAnimalEmpathy = "0"; // as int 0 is the same as a non existant row
    string sSQL = "SELECT " +q+"data"+q+ " FROM " + q +"prc_cached2da"+ q +
    " WHERE " + q +"file"+q + " = '" + sFile + "' AND " +q+"columnid"+q+ "= 'SkillIndex' AND " 
    +q+"data"+q+ " = '" + sSkillAnimalEmpathy + "'";
    
    PRC_SQLExecDirect(sSQL);
    if (PRC_SQLFetch() == PRC_SQL_SUCCESS && PRC_SQLGetData(1) == "0") // check it was the right skill
        SetLocalInt(oPC, "bHasAnimalEmpathy", TRUE);
    
    // query to see if use magic device is on that list
    string sSkillUMD = IntToString(SKILL_USE_MAGIC_DEVICE);
    sSQL = "SELECT " +q+"data"+q+ " FROM " + q +"prc_cached2da"+ q +
    " WHERE " + q +"file"+q + " = '" + sFile + "' AND " +q+"columnid"+q+ "= 'SkillIndex' AND " 
    +q+"data"+q+ " = '" + sSkillUMD + "'";
    
    PRC_SQLExecDirect(sSQL);
    if (PRC_SQLFetch() == PRC_SQL_SUCCESS && PRC_SQLGetData(1) == sSkillUMD) // check it was the right skill
        SetLocalInt(oPC, "bHasUMD", TRUE);
    
    // get the information needed to work out if the prereqs are met
    int nSex = GetLocalInt(oPC, "Gender");
	int nRace = GetLocalInt(oPC, "Race");
	int nClass = GetLocalInt(oPC, "Class");
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha"); 
    int nOrder = GetLocalInt(oPC, "LawfulChaotic");
    int nMoral = GetLocalInt(oPC, "GoodEvil");

    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialtypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialtypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialtypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialtypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialtypes", "ChaAdjust", nRace));
    
    // get BAB
    int nBAB = StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable", nClass), "BAB", 0));
    
    // get fortitude save
    int nFortSave = StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", 0));
    
    // get the results 5 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    
    if (!nClassFeatStage) // select the general feats
    {
        /*
        SELECT `rowid`, `feat`, `PREREQFEAT1`, `PREREQFEAT2`, `OrReqFeat0`, `OrReqFeat1`, `OrReqFeat2`, `OrReqFeat3`, `OrReqFeat4`,
        `REQSKILL`, `REQSKILL2`, `ReqSkillMinRanks`, `ReqSkillMinRanks2`
        FROM `prc_cached2da_feat`
        WHERE (`feat` != '****') AND (`PreReqEpic` != 1)
        AND (`MinLevel` = '****' OR `MinLevel` = '1')
        AND `ALLCLASSESCANUSE` = 1
        AND `minattackbonus` <= <nBAB>
        AND `minspelllvl` <= 1
        AND `minstr`<= <nStr>
        AND `mindex`<= <nDex>
        AND `mincon`<= <nCon>
        AND `minint`<= <nInt>
        AND `minwis`<= <nWis>
        AND `mincha`<= <nCha>
        AND `MinFortSave` <= <nFortSave>
        */
        
        sSQL = "SELECT "+q+"rowid"+q+", "+q+"FEAT"+q+", "+q+"PREREQFEAT1"+q+", "+q+"PREREQFEAT2"+q+", "
                +q+"OrReqFeat0"+q+", "+q+"OrReqFeat1"+q+", "+q+"OrReqFeat2"+q+", "+q+"OrReqFeat3"+q+", "+q+"OrReqFeat4"+q+", "
                +q+"REQSKILL"+q+", "+q+"REQSKILL2"+q+", "+q+"ReqSkillMinRanks"+q+", "+q+"ReqSkillMinRanks2"+q+
                " FROM "+q+"prc_cached2da_feat"+q+
                " WHERE ("+q+"FEAT"+q+" != '****') AND ("+q+"PreReqEpic"+q+" != 1)"
                +" AND ("+q+"MinLevel"+q+" = '****' OR "+q+"MinLevel"+q+" = '1')"
                +" AND ("+q+"ALLCLASSESCANUSE"+q+" = 1)"
                +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
                +" AND ("+q+"MINSPELLLVL"+q+" <= 1)"
                +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
                +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
                +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
                +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
                +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
                +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
                +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
                +" LIMIT 5 OFFSET "+IntToString(nReali);
    }
    else // select the class feats
    {
        // get which cls_feat_*** 2da to use
        string sFile = Get2DACache("classes", "FeatsTable", nClass);
        
        /*
        SELECT prc_cached2da_cls_feat.FeatIndex, prc_cached2da_cls_feat.FEAT, 
            prc_cached2da_feat.PREREQFEAT1, prc_cached2da_feat.PREREQFEAT2, 
            prc_cached2da_feat.OrReqFeat0, prc_cached2da_feat.OrReqFeat1, prc_cached2da_feat.OrReqFeat2, prc_cached2da_feat.OrReqFeat3, prc_cached2da_feat.OrReqFeat4, 
            prc_cached2da_feat.REQSKILL, prc_cached2da_feat.REQSKILL2,
            prc_cached2da_feat.ReqMinSkillRanks, prc_cached2da_feat.ReqMinSkillRanks2
        FROM prc_cached2da_cls_feat INNER JOIN prc_cached2da_feat
        WHERE (prc_cached2da_feat.FEAT != '****') AND (prc_cached2da_cls_feat.FeatIndex != '****')
            AND (prc_cached2da_cls_feat.file = '<cls_feat***>')
            AND (prc_cached2da_cls_feat.List <= 1)
            AND (prc_cached2da_cls_feat.GrantedOnLevel <= 1)
            AND (prc_cached2da_feat.rowid = prc_cached2da_cls_feat.FeatIndex)
            AND (`PreReqEpic` != 1)
            AND (`MinLevel` = '****' OR `MinLevel` = '1')
            AND `ALLCLASSESCANUSE` = 0
            AND `minattackbonus` <= <nBAB>
            AND `minspelllvl` <= 1
            AND `minstr`<= <nStr>
            AND `mindex`<= <nDex>
            AND `mincon`<= <nCon>
            AND `minint`<= <nInt>
            AND `minwis`<= <nWis>
            AND `mincha`<= <nCha>
            AND `MinFortSave` <= <nFortSave>
        */
        
        sSQL = "SELECT "+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+", "+q+"FEAT"+q+", "+q+"PREREQFEAT1"+q+", "+q+"PREREQFEAT2"+q+", "
                +q+"OrReqFeat0"+q+", "+q+"OrReqFeat1"+q+", "+q+"OrReqFeat2"+q+", "+q+"OrReqFeat3"+q+", "+q+"OrReqFeat4"+q+", "
                +q+"REQSKILL"+q+", "+q+"REQSKILL2"+q+", "+q+"ReqSkillMinRanks"+q+", "+q+"ReqSkillMinRanks2"+q+
                " FROM "+q+"prc_cached2da_feat"+q+ " INNER JOIN " +q+"prc_cached2da_cls_feat"+q+
                " WHERE ("+q+"prc_cached2da_feat"+q+"."+q+"FEAT"+q+" != '****') AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+" != '****')"
                +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"file"+q+" = '" + sFile + "')"
                +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" <= 1)"
                +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"GrantedOnLevel"+q+" <= 1)"
                +" AND ("+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+" = "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+")"
                +" AND ("+q+"PreReqEpic"+q+" != 1)"
                +" AND ("+q+"MinLevel"+q+" = '****' OR "+q+"MinLevel"+q+" = '1')"
                +" AND ("+q+"ALLCLASSESCANUSE"+q+" != 1)"
                +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
                +" AND ("+q+"MINSPELLLVL"+q+" <= 1)"
                +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
                +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
                +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
                +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
                +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
                +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
                +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
                +" LIMIT 5 OFFSET "+IntToString(nReali);
    }
    
    // debug print the sql statement
    if(DEBUG)
    {
        DoDebug(sSQL);
    }
            
    PRC_SQLExecDirect(sSQL);
    // to keep track of where in the 25 rows we stop getting a result
    int nCounter = 0;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
	    int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        string sPreReqFeat1 = PRC_SQLGetData(3);
        string sPreReqFeat2 = PRC_SQLGetData(4);
        string sOrReqFeat0 = PRC_SQLGetData(5);
        string sOrReqFeat1 = PRC_SQLGetData(6);
        string sOrReqFeat2 = PRC_SQLGetData(7);
        string sOrReqFeat3 = PRC_SQLGetData(8);
        string sOrReqFeat4 = PRC_SQLGetData(9);
        string sReqSkill = PRC_SQLGetData(10);
        string sReqSkill2 = PRC_SQLGetData(11);
        string sReqSkillRanks = PRC_SQLGetData(12);
        string sReqSkillRanks2 = PRC_SQLGetData(13);
        
        // check AND feat prerequisites
        if (GetMeetsANDPreReq(sPreReqFeat1, sPreReqFeat2))
        {
            // check OR feat prerequisites
            if (GetMeetsORPreReq(sOrReqFeat0, sOrReqFeat1, sOrReqFeat2, sOrReqFeat3, sOrReqFeat4))
            {
                // check skill prerequisites
                if(GetMeetSkillPrereq(sReqSkill, sReqSkill2, sReqSkillRanks, sReqSkillRanks2))
                {
                    // check they don't have it already
                    if(!PreReqFeatArrayLoop(nRow))
                        AddChoice(sName, nRow);
                    else
                    {
                        if(DEBUG) DoDebug("Already picked feat " + IntToString(nRow) + ". Not added!");
                    }
                }
                else
                {
                    if(DEBUG) DoDebug("Not met skill prereq for feat " + IntToString(nRow) + ". Not added!");
                }
            }
            else
            {
                if(DEBUG) DoDebug("Not met OR prereqfeat test for feat " + IntToString(nRow) + ". Not added!");
            }
        }
        else
        {
            if(DEBUG) DoDebug("Not met AND prereqfeat test for feat " + IntToString(nRow) + ". Not added!");
        }
    } // end of while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    
    if(nCounter == 5)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+5);
        DelayCommand(0.01, DoFeatLoop(nClassFeatStage));
    }
    else // there were less than 5 rows, it's the end of the 2da
    {
        if(nClassFeatStage)
        {
            FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
            if(DEBUG) DoDebug("Finished class feats");
            DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
            DeleteLocalInt(OBJECT_SELF, "i");
            return;
        }
        else // run again to select class feats
        {
            nClassFeatStage = TRUE;
            if(DEBUG) DoDebug("Finished general feats");
            DeleteLocalInt(OBJECT_SELF, "i");
            DelayCommand(0.01, DoFeatLoop(nClassFeatStage));
        }
    }
}

void DoBonusFeatLoop()
{
    /* TODO - scripting feat enforcement */
    // get the table/column name quote mark
    string q = PRC_SQLGetTick();
    object oPC = OBJECT_SELF;
    
    // check if UMD and animal empathy can be taken for prereq for the skill focus feats
    // done here because reading the 2da cache clears out any existing SQL results
    // note: any other skill that is restricted to certain classes needs to be hardcoded here
    string sFile = Get2DACache("classes", "SkillsTable", GetLocalInt(oPC, "Class"));
    
    /*
     * SELECT SkillIndex FROM <cls_skill_***> WHERE SkillIndex = <skill>
     */
    
    // query to see if animal empathy is on that list
    string sSkillAnimalEmpathy = "0"; // as int 0 is the same as a non existant row
    string sSQL = "SELECT " +q+"data"+q+ " FROM " + q +"prc_cached2da"+ q +
    " WHERE " + q +"file"+q + " = '" + sFile + "' AND " +q+"columnid"+q+ "= 'SkillIndex' AND " 
    +q+"data"+q+ " = '" + sSkillAnimalEmpathy + "'";
    
    PRC_SQLExecDirect(sSQL);
    if (PRC_SQLFetch() == PRC_SQL_SUCCESS && PRC_SQLGetData(1) == "0") // check it was the right skill
        SetLocalInt(oPC, "bHasAnimalEmpathy", TRUE);
    
    // query to see if use magic device is on that list
    string sSkillUMD = IntToString(SKILL_USE_MAGIC_DEVICE);
    sSQL = "SELECT " +q+"data"+q+ " FROM " + q +"prc_cached2da"+ q +
    " WHERE " + q +"file"+q + " = '" + sFile + "' AND " +q+"columnid"+q+ "= 'SkillIndex' AND " 
    +q+"data"+q+ " = '" + sSkillUMD + "'";
    
    PRC_SQLExecDirect(sSQL);
    if (PRC_SQLFetch() == PRC_SQL_SUCCESS && PRC_SQLGetData(1) == sSkillUMD) // check it was the right skill
        SetLocalInt(oPC, "bHasUMD", TRUE);
    
    // get the information needed to work out if the prereqs are met
    int nSex = GetLocalInt(oPC, "Gender");
	int nRace = GetLocalInt(oPC, "Race");
	int nClass = GetLocalInt(oPC, "Class");
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha"); 
    int nOrder = GetLocalInt(oPC, "LawfulChaotic");
    int nMoral = GetLocalInt(oPC, "GoodEvil");

    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialtypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialtypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialtypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialtypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialtypes", "ChaAdjust", nRace));
    
    // get BAB
    int nBAB = StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable", nClass), "BAB", 0));
    
    // get fortitude save
    int nFortSave = StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", 0));
    
    // get the results 5 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    
    // get which cls_feat_*** 2da to use
    sFile = Get2DACache("classes", "FeatsTable", nClass);
        
        /*
        SELECT prc_cached2da_cls_feat.FeatIndex, prc_cached2da_cls_feat.FEAT, 
            prc_cached2da_feat.PREREQFEAT1, prc_cached2da_feat.PREREQFEAT2, 
            prc_cached2da_feat.OrReqFeat0, prc_cached2da_feat.OrReqFeat1, prc_cached2da_feat.OrReqFeat2, prc_cached2da_feat.OrReqFeat3, prc_cached2da_feat.OrReqFeat4, 
            prc_cached2da_feat.REQSKILL, prc_cached2da_feat.REQSKILL2,
            prc_cached2da_feat.ReqMinSkillRanks, prc_cached2da_feat.ReqMinSkillRanks2
        FROM prc_cached2da_cls_feat INNER JOIN prc_cached2da_feat
        WHERE (prc_cached2da_feat.FEAT != '****') AND (prc_cached2da_cls_feat.FeatIndex != '****')
            AND (prc_cached2da_cls_feat.file = '<cls_feat***>')
            AND ((prc_cached2da_cls_feat.List = 1) OR (prc_cached2da_cls_feat.List = 2))
            AND (prc_cached2da_cls_feat.GrantedOnLevel <= 1)
            AND (prc_cached2da_feat.rowid = prc_cached2da_cls_feat.FeatIndex)
            AND (`PreReqEpic` != 1)
            AND (`MinLevel` = '****' OR `MinLevel` = '1')
            AND `ALLCLASSESCANUSE` = 0
            AND `minattackbonus` <= <nBAB>
            AND `minspelllvl` <= 1
            AND `minstr`<= <nStr>
            AND `mindex`<= <nDex>
            AND `mincon`<= <nCon>
            AND `minint`<= <nInt>
            AND `minwis`<= <nWis>
            AND `mincha`<= <nCha>
            AND `MinFortSave` <= <nFortSave>
        */
        
        sSQL = "SELECT "+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+", "+q+"FEAT"+q+", "+q+"PREREQFEAT1"+q+", "+q+"PREREQFEAT2"+q+", "
                +q+"OrReqFeat0"+q+", "+q+"OrReqFeat1"+q+", "+q+"OrReqFeat2"+q+", "+q+"OrReqFeat3"+q+", "+q+"OrReqFeat4"+q+", "
                +q+"REQSKILL"+q+", "+q+"REQSKILL2"+q+", "+q+"ReqSkillMinRanks"+q+", "+q+"ReqSkillMinRanks2"+q+
                " FROM "+q+"prc_cached2da_feat"+q+ " INNER JOIN " +q+"prc_cached2da_cls_feat"+q+
                " WHERE ("+q+"prc_cached2da_feat"+q+"."+q+"FEAT"+q+" != '****') AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+" != '****')"
                +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"file"+q+" = '" + sFile + "')"
                +" AND (("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" = 1) OR ("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" = 2))"
                +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"GrantedOnLevel"+q+" <= 1)"
                +" AND ("+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+" = "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+")"
                +" AND ("+q+"PreReqEpic"+q+" != 1)"
                +" AND ("+q+"MinLevel"+q+" = '****' OR "+q+"MinLevel"+q+" = '1')"
                +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
                +" AND ("+q+"MINSPELLLVL"+q+" <= 1)"
                +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
                +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
                +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
                +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
                +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
                +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
                +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
                +" LIMIT 5 OFFSET "+IntToString(nReali);
                
    // debug print the sql statement
    if(DEBUG)
    {
        DoDebug(sSQL);
    }
            
    PRC_SQLExecDirect(sSQL);
    // to keep track of where in the 25 rows we stop getting a result
    int nCounter = 0;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
	    int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        string sPreReqFeat1 = PRC_SQLGetData(3);
        string sPreReqFeat2 = PRC_SQLGetData(4);
        string sOrReqFeat0 = PRC_SQLGetData(5);
        string sOrReqFeat1 = PRC_SQLGetData(6);
        string sOrReqFeat2 = PRC_SQLGetData(7);
        string sOrReqFeat3 = PRC_SQLGetData(8);
        string sOrReqFeat4 = PRC_SQLGetData(9);
        string sReqSkill = PRC_SQLGetData(10);
        string sReqSkill2 = PRC_SQLGetData(11);
        string sReqSkillRanks = PRC_SQLGetData(12);
        string sReqSkillRanks2 = PRC_SQLGetData(13);
        
        // check AND feat prerequisites
        if (GetMeetsANDPreReq(sPreReqFeat1, sPreReqFeat2))
        {
            // check OR feat prerequisites
            if (GetMeetsORPreReq(sOrReqFeat0, sOrReqFeat1, sOrReqFeat2, sOrReqFeat3, sOrReqFeat4))
            {
                // check skill prerequisites
                if(GetMeetSkillPrereq(sReqSkill, sReqSkill2, sReqSkillRanks, sReqSkillRanks2))
                {
                    // check they don't have it already
                    if(!PreReqFeatArrayLoop(nRow))
                        AddChoice(sName, nRow);
                    else
                    {
                        if(DEBUG) DoDebug("Already picked feat " + IntToString(nRow) + ". Not added!");
                    }
                }
                else
                {
                    if(DEBUG) DoDebug("Not met skill prereq for feat " + IntToString(nRow) + ". Not added!");
                }
            }
            else
            {
                if(DEBUG) DoDebug("Not met OR prereqfeat test for feat " + IntToString(nRow) + ". Not added!");
            }
        }
        else
        {
            if(DEBUG) DoDebug("Not met AND prereqfeat test for feat " + IntToString(nRow) + ". Not added!");
        }
    } // end of while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    
    if(nCounter == 5)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+5);
        DelayCommand(0.01, DoBonusFeatLoop());
    }
    else // there were less than 5 rows, it's the end of the 2da
    {
        if(DEBUG) DoDebug("Finished bonus feats");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
}

void DoSpellsLoop(int nStage)
{
    // get which spell level the choices are for
    int nSpellLevel = 0;
    if (nStage == STAGE_SPELLS_1)
        nSpellLevel = 1;
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    string sSQL;
    string q = PRC_SQLGetTick();
    // get the results 30 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    switch(nClass)
    {
        case CLASS_TYPE_WIZARD: {
            int nSpellSchool = GetLocalInt(OBJECT_SELF, "School");
            string sOpposition = Get2DACache("spellschools", "Letter", StringToInt(Get2DACache("spellschools", "Opposition", nSpellSchool)));
            sSQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Name"+q+" != '****') AND ("+q+"Wiz_Sorc"+q+" = '1') AND ("+q+"School"+q+" != '"+sOpposition+"') LIMIT 30 OFFSET "+IntToString(nReali);
            break;
        }
        case CLASS_TYPE_SORCERER: {
            sSQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Name"+q+" != '****') AND("+q+"Wiz_Sorc"+q+" = '"+IntToString(nSpellLevel)+"') LIMIT 30 OFFSET "+IntToString(nReali);
            break;
        }
        case CLASS_TYPE_BARD: {
            sSQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Name"+q+" != '****') AND("+q+"Bard"+q+" = '"+IntToString(nSpellLevel)+"') LIMIT 30 OFFSET "+IntToString(nReali);
            break;
        }
    }
    
    PRC_SQLExecDirect(sSQL);
    // to keep track of where in the 10 rows we stop getting a result
    int nCounter = 0;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
        // has it already been chosen?
        int nSpell = StringToInt(PRC_SQLGetData(1));
        // if they don't know the spell, add it to the choice list
        if(!GetIsSpellKnown(nSpell, nSpellLevel))
        {
            string sName = GetStringByStrRef(StringToInt(PRC_SQLGetData(2)));
            AddChoice(sName, nSpell);
        }
    } // end of while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    
    if (nCounter == 30)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+30);
        DelayCommand(0.01, DoSpellsLoop(nStage));
    }
    else // end of the 2da
    {
        if(DEBUG) DoDebug("Finished spells");
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        return;
    }
}

void  DoDomainsLoop()
{
    int i = 0;
    string sName;
    // get the first domain chosen if it's there
    string sDomain = IntToString(GetLocalInt(OBJECT_SELF, "Domain1"));
    // fix for air domain being 0
    if (sDomain == "-1")
        sDomain = "0";
    sName = Get2DACache("domains", "Name", i);
    while(i < GetPRCSwitch(FILE_END_DOMAINS))
    {
        if (sName != "" && sName != sDomain)
        {
            AddChoice(GetStringByStrRef(StringToInt(sName)), i);
        }
        i++;
        sName = Get2DACache("domains", "Name", i);
    }
}

void AddRaceFeats(int nRace)
{
    // gets which race_feat***.2da to use
    string sFile = GetStringLowerCase(Get2DACache("racialtypes", "FeatsTable", nRace));
    int i = 0;
    // create the Feats array
    array_create(OBJECT_SELF, "Feats");
    // initialise the while loop
    string sFeat = Get2DACache(sFile, "FeatIndex", i);
    while(sFeat != "") // while there's non empty lines in the 2da
    {
        //alertness fix
        if(sFeat == "0")
            sFeat = "-1";
        int nQTMCount = 0;
        // if one of these is quick to master, mark for doing the bonus feat later
        if (sFeat == "258")
            nQTMCount++;
        // add on any bonus feats from switches here
        nQTMCount += (GetPRCSwitch(PRC_CONVOCC_BONUS_FEATS));
        SetLocalInt(OBJECT_SELF, "QTM", nQTMCount);
        
        array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
            StringToInt(sFeat));
        i++;
        sFeat = Get2DACache(sFile, "FeatIndex", i);
    }
}

void AddClassFeats(int nClass)
{
    // gets which class_feat_***.2da to use
    string sFile = GetStringLowerCase(Get2DACache("classes", "FeatsTable", nClass));
    // Feats array should already exist, but check anyway
    int nArraySize = array_get_size(OBJECT_SELF, "Feats");
    if (nArraySize) // if there's stuff in there already
    {
        // has it's own table, so SQL is easiest
        // get the table/column name quote mark
        string q = PRC_SQLGetTick();
        // class feats granted at level 1
        /*
        SELECT `FeatIndex` FROM `prc_cached2da_cls_feat`
        WHERE (`file` = <cls_feat***>) AND (`List` = 3) AND (`GrantedOnLevel` = 1)
        */
        string sSQL = "SELECT "+q+"FeatIndex"+q+" FROM "+q+"prc_cached2da_cls_feat"+q+" WHERE ("+q+"file"+q+" = '" + sFile + "') AND ("+q+"List"+q+" = 3) AND ("+q+"GrantedOnLevel"+q+" = 1)";
        PRC_SQLExecDirect(sSQL);
        int nFeat;
        while (PRC_SQLFetch() == PRC_SQL_SUCCESS)
        {
            nFeat = StringToInt(PRC_SQLGetData(1)); // feat index
            //alertness fix
            if(nFeat == 0)
                nFeat = -1;
            array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"), nFeat);
        }
    }
    else // no feat array - screw up
    {
        /* TODO - start again */
    }
    
}

void AddDomainFeats()
{
    int nDomain = GetLocalInt(OBJECT_SELF, "Domain1");
    // air domain fix
    if (nDomain == -1)
        nDomain = 0;
    // get feat
    string sFeat = Get2DACache("domains", "GrantedFeat", nDomain);
    // add to the feat array
    array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
            StringToInt(sFeat));
    
    nDomain = GetLocalInt(OBJECT_SELF, "Domain2");
    // air domain fix
    if (nDomain == -1)
        nDomain = 0;
    sFeat = Get2DACache("domains", "GrantedFeat", nDomain);
    // add to the feat array
    array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
            StringToInt(sFeat));
}