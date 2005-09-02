//
// Stub function for possible later use.
//
#include "prc_alterations"
#include "prc_alterations"
#include "x2_inc_switches"
#include "inc_threads"
#include "prc_inc_switch"
#include "inc_2dacache"

void main()
{
    //this triggers NWNX on Linux
    SetLocalInt(GetModule(), "NWNX!INIT", 1);
    //looks like there is some sort of issue with reloading a saved game
    //this shold stop this event firing for reloads
    if(GetLocalInt(GetModule(), "prc_mod_load_done"))
        return;
    SetLocalInt(GetModule(), "prc_mod_load_done", TRUE);    
    
    SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
    ExecuteScript("prc_companion", OBJECT_SELF);
   
    CreateSwitchNameArray();
    DoEpicSpellDefaults();
    SetDefaultFileEnds();
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
    {
        SetPRCSwitch(PRC_USE_DATABASE, TRUE);
        SetPRCSwitch(PRC_DB_PRECACHE, TRUE);
        SetPRCSwitch(PRC_USE_LETOSCRIPT, TRUE);
    }   
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE) == 0)
        SetPRCSwitch(PRC_USE_BIOWARE_DATABASE, 100);//100 HBs = 600sec = 10min
    if(GetPRCSwitch(PRC_USE_BIOWARE_DATABASE))    
    {
        //check PRC version
        if(GetCampaignString("prc_data", "version") != PRC_VERSION)
            DestroyCampaignDatabase("prc_data");
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
    if(GetLocalString(GetModule(), PRC_LETOSCRIPT_NWN_DIR) == "")
    {    
        string sDir = Get2DACache("directory", "Dir", 0);
        if(sDir != "")
            SetLocalString(GetModule(), PRC_LETOSCRIPT_NWN_DIR, sDir);
    }    
    
    //delay the 2da lookup stuff
    DelayCommand(10.0, ExecuteScript("look2daint", OBJECT_SELF));//helps avoid TMI errors
    DelayCommand(12.0, MakeLookupLoopMaster());
}
