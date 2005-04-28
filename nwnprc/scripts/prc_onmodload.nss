//
// Stub function for possible later use.
//

#include "x2_inc_switches"
#include "inc_threads"
#include "prc_inc_switch"
#include "inc_2dacache"

void main()
{
    SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
    ExecuteScript("prc_companion", OBJECT_SELF);
   
    DoEpicSpellDefaults();
    if(GetPRCSwitch(PRC_CONVOCC_ENABLE))
    {
        SetPRCSwitch(PRC_USE_DATABASE, TRUE);
        SetPRCSwitch(PRC_DB_PRECACHE, TRUE);
        SetPRCSwitch(PRC_USE_LETOSCRIPT, TRUE);
    }   
    
    if(GetPRCSwitch(PRC_USE_DATABASE))
    {
        PRC_SQLInit();
        PRCMakeTables();
        if(GetPRCSwitch(PRC_DB_PRECACHE))
            Cache_2da_data();
        if(GetPRCSwitch(PRC_DB_SQLLITE))
            DelayCommand(600.0, PRC_SQLCommit());
    }        
        
        
    ExecuteScript("look2daint", OBJECT_SELF);
    
}
