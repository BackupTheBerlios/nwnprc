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
   
    DoEpicSpellDefaults();
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
