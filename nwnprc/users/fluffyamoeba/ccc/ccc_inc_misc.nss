/**
 * convoCC misc functions
 */

#include "inc_utility"
#include "prc_alterations"
#include "ccc_inc_leto"

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

// sets race appearance as defined in racialtype.2da
// removes wings, tails and undead graft arm as well as making invisible bits visible
void DoSetRaceAppearance();

// clones the PC, makes the PC cutscene invisible then hides the swap with an effect
void CreateCloneCutscene();

// used to cleanup clones when a player leaves
void CloneMasterCheck();

// sets up the camera to rotate around the clone 
// and the clone do random animations
void DoRotatingCamera();

/* 2da cache functions */

// loops through a 2da, using the cache
// s2da is the name of the 2da, sColumnName the column to read the values
// from, nFileEnd the number of lines in the 2da
void Do2daLoop(string s2da, string sColumnName, int nFileEnd);

// loops through racialtypes.2da
void DoRacialtypesLoop();

// loops through classes.2da
void DoClassesLoop();

// stores the feats found in race_feat_***.2da as an array on the PC
void AddRaceFeats(int nRace);

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

void DoSetRaceAppearance()
{
    // sets the appearance type
    int nSex = GetLocalInt(OBJECT_SELF, "Gender");
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    // appearance type switches go here
    if(nRace == RACIAL_TYPE_RAKSHASA
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_RAKSHASA_TIGER_FEMALE);
    else if(nRace == RACIAL_TYPE_DRIDER
        && nSex == GENDER_FEMALE
        && GetPRCSwitch(PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE))
        SetCreatureAppearanceType(OBJECT_SELF, APPEARANCE_TYPE_DRIDER_FEMALE);
    else
        SetCreatureAppearanceType(OBJECT_SELF, 
                    StringToInt(Get2DACache("racialtypes", "Appearance",
                        GetLocalInt(OBJECT_SELF, "Race"))));
    
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

void CreateCloneCutscene()
{
    // make the real PC non-collideable
    effect eGhost = EffectCutsceneGhost();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGhost, OBJECT_SELF, 99999999.9);
    // make the swap and hide with an effect
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(OBJECT_SELF));
    object oClone = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "PlayerClone");
    ChangeToStandardFaction(oClone, STANDARD_FACTION_MERCHANT);
    // make the real PC invisible
    effect eInvis = EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, OBJECT_SELF, 9999.9);
    //make sure the clone stays put
    effect eParal = EffectCutsceneImmobilize();
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oClone, 9999.9);
    // swap local objects
    SetLocalObject(OBJECT_SELF, "Clone", oClone);
    SetLocalObject(oClone, "Master", OBJECT_SELF);
    // this makes sure the clone gets destroyed if the PC leaves the game
    AssignCommand(oClone, CloneMasterCheck());

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

void DoRotatingCamera()
{
    object oPC = OBJECT_SELF;
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
    DelayCommand(6.0, DoRotatingCamera());
    //its the clone not the PC that does things
    object oClone = GetLocalObject(oPC, "Clone");
    if(GetIsObjectValid(oClone))
        oPC = oClone;
    if(d2()==1)
        AssignCommand(oPC, ActionPlayAnimation(100+Random(17)));
    else
        AssignCommand(oPC, ActionPlayAnimation(100+Random(21), 1.0, 6.0));
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
    string sReqType, sParam1, sParam2;
    // this needs storing in a temp array because the 2da cache retrieval will clear
    // the query above if both steps are done in the same loop
    // hmmm...unless...LEFT JOIN...
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
        int nClass = StringToInt(PRC_SQLGetData(1)); // rowid
        // check if this base class is allowed
        string sPreReq = PRC_SQLGetData(2); // PreReq tablename
        int i = 0;
        do
        {
            sReqType = Get2DACache(sPreReq, "ReqType", i);
            if (sReqType == "VAR") // if we've found the class allowed variable
            {
                sParam1 = Get2DACache(sPreReq, "ReqParam1", i);
                if(!GetLocalInt(OBJECT_SELF, sParam1)) // if the class is allowed
                {
                    // adds the class tot he choice list
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
                    AddChoice(sName, nClass);
                }
            } // end of if (sReqType == "VAR")
            i++;
            
        } while (sReqType != "VAR"); // terminates as soon as we get the allowed variable

    } // end of while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    
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
        array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
            StringToInt(sFeat));
        i++;
        sFeat = Get2DACache(sFile, "FeatIndex", i);
    }
}
