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
        PRCMakeTables();
        
        
   ExecuteScript("look2daint", OBJECT_SELF);
}
