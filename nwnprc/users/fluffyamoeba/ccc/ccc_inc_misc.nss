/**
 * convoCC misc functions
 */

#include "inc_utility"
#include "prc_alterations"
#include "inc_letoscript"
#include "inc_letocommands"

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

/* 2da cache functions */

// loops through a 2da, using the cache
// s2da is the name of the 2da, sColumnName the column to read the values
// from, nFileEnd the number of lines in the 2da
void Do2daLoop(string s2da, string sColumnName, int nFileEnd);

// loops through racialtypes.2da
void DoRacialtypesLoop();

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