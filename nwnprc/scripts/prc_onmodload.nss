//
// Stub function for possible later use.
//

#include "x2_inc_switches"
#include "inc_threads"
#include "prc_inc_switch"

void main()
{
   SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
   ExecuteScript("look2daint", OBJECT_SELF);
   
   DoEpicSpellDefaults();
}
