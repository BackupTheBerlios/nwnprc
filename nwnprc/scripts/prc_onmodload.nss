//
// Stub function for possible later use.
//
#include "prc_alterations"
#include "x2_inc_switches"
#include "prc_alterations"
#include "prc_inc_leadersh"

void CheckDB()
{
    //check PRC version
    if(GetCampaignString("prc_data", "version") != PRC_VERSION)
    {
        DoDebug("Removing old databases");
        DestroyCampaignDatabase("prc_data");
        DestroyCampaignDatabase(COHORT_DATABASE);
    }
    SetCampaignString("prc_data", "version", PRC_VERSION);

    location lLoc = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
    //only get it if one doesnt already exist (saved games)
    if(GetIsObjectValid(GetObjectByTag("Bioware2DACache")))
        DestroyObject(GetObjectByTag("Bioware2DACache"));
    object oChest = RetrieveCampaignObject("prc_data", "CacheChest", lLoc);
    if(!GetIsObjectValid(oChest))
        DoDebug("Unable to retieve CacheChest from prc_data");
}

void main()
{
    object oModule = GetModule();

    //this triggers NWNX on Linux
    SetLocalInt(oModule, "NWNX!INIT", 1);
    SetLocalString(oModule, "NWNX!INIT", "1");

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

    //delay this to avoid TMIs
    DelayCommand(0.01, CreateSwitchNameArray());
    DelayCommand(0.01, DoEpicSpellDefaults());
    DelayCommand(0.01, DoSamuraiBanDefaults());
    SetDefaultFileEnds();
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
    {
        SetPRCSwitch(PRC_USE_DATABASE, TRUE);
        //SetPRCSwitch(PRC_DB_PRECACHE, TRUE);
        SetPRCSwitch(PRC_USE_LETOSCRIPT, TRUE);
    }
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE) == 0)
        SetPRCSwitch(PRC_USE_BIOWARE_DATABASE, 300);//100 HBs = 1800sec = 30min
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE))
        DelayCommand(1.0, CheckDB());

    if(GetPRCSwitch(PRC_USE_DATABASE))
    {
        PRC_SQLInit();
        PRCMakeTables();
        if(GetPRCSwitch(PRC_DB_SQLLITE))
            DelayCommand(IntToFloat(GetPRCSwitch(PRC_DB_SQLLITE_INTERVAL)), PRC_SQLCommit());
    }
    if(GetPRCSwitch(PRC_DB_PRECACHE))
        Cache_2da_data();
    //pre-made cohorts
    //DelayCommand(6.0, AddPremadeCohortsToDB());
    //done differently now

    //check for letoscript dir
    if(GetLocalString(oModule, PRC_LETOSCRIPT_NWN_DIR) == "")
    {
        string sDir = Get2DACache("directory", "Dir", 0);
        if(sDir != "")
            SetLocalString(oModule, PRC_LETOSCRIPT_NWN_DIR, sDir);
    }

    //delay the 2da lookup stuff
    //DelayCommand(10.0, ExecuteScript("look2daint", OBJECT_SELF));//helps avoid TMI errors
    DelayCommand(12.0, MakeLookupLoopMaster());
    
    //mark server as loading
    float fDelay = IntToFloat(GetPRCSwitch(PRC_PW_LOGON_DELAY))*60.0;
    if(fDelay>0.0)
    {
        SetLocalInt(GetModule(), PRC_PW_LOGON_DELAY+"_TIMER", TRUE);
        DelayCommand(fDelay, DeleteLocalInt(GetModule(), PRC_PW_LOGON_DELAY+"_TIMER"));
    }   
}
