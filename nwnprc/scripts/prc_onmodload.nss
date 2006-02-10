//
// Stub function for possible later use.
//
#include "prc_alterations"
#include "x2_inc_switches"
#include "inc_utility"
#include "prc_inc_leadersh"

void main()
{
    object oModule = GetModule();

    //this triggers NWNX on Linux
    SetLocalInt(oModule, "NWNX!INIT", 1);

    // Loading a saved game runs the module load event, but since the point of the stuff
    // we do here is to set local variables and those don't get cleared over saved games,
    // there is no point in wasting (a massive load of) CPU on doing it all over again.
    if(GetLocalInt(oModule, "prc_mod_load_done"))
        return;
    else
        SetLocalInt(oModule, "prc_mod_load_done", TRUE);


    // Set PRC presence & version marker. If plugins ever happen, this would be useful.
    SetLocalString(oModule, "PRC_VERSION", PRC_VERSION);

    SetModuleSwitch(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE); /// @todo This is somewhat intrusive, make it unnecessary and remove

    // Run a script to determine if the PRC Companion is present
    ExecuteScript("prc_companion", OBJECT_SELF);

    CreateSwitchNameArray();
    DoEpicSpellDefaults();
    SetDefaultFileEnds();
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
    {
        SetPRCSwitch(PRC_USE_DATABASE, TRUE);
        //SetPRCSwitch(PRC_DB_PRECACHE, TRUE);
        SetPRCSwitch(PRC_USE_LETOSCRIPT, TRUE);
    }
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE) == 0)
        SetPRCSwitch(PRC_USE_BIOWARE_DATABASE, 100);//100 HBs = 600sec = 10min
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE))
    {
        //check PRC version
        if(GetCampaignString("prc_data", "version") != PRC_VERSION)
        {
            DestroyCampaignDatabase("prc_data");
            DestroyCampaignDatabase(COHORT_DATABASE);
        }
        SetCampaignString("prc_data", "version", PRC_VERSION);

        location lLoc = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
        //only get it if one doesnt already exist (saved games)
        if(GetIsObjectValid(GetObjectByTag("Bioware2DACache")))
            DestroyObject(GetObjectByTag("Bioware2DACache"));
        RetrieveCampaignObject("prc_data", "CacheChest", lLoc);
    }

    if(GetPRCSwitch(PRC_USE_DATABASE))
    {
        PRC_SQLInit();
        PRCMakeTables();
        if(GetPRCSwitch(PRC_DB_PRECACHE))
            Cache_2da_data();
        if(GetPRCSwitch(PRC_DB_SQLLITE))
            DelayCommand(IntToFloat(GetPRCSwitch(PRC_DB_SQLLITE_INTERVAL)), PRC_SQLCommit());
    }

    //check for letoscript dir
    if(GetLocalString(oModule, PRC_LETOSCRIPT_NWN_DIR) == "")
    {
        string sDir = Get2DACache("directory", "Dir", 0);
        if(sDir != "")
            SetLocalString(oModule, PRC_LETOSCRIPT_NWN_DIR, sDir);
    }

    //delay the 2da lookup stuff
    DelayCommand(10.0, ExecuteScript("look2daint", OBJECT_SELF));//helps avoid TMI errors
    DelayCommand(12.0, MakeLookupLoopMaster());
}
