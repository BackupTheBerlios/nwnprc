//
// Stub function for possible later use.
//

#include "x2_inc_switches"
#include "inc_threads"

void main()
{
   SetModuleSwitch (MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS, TRUE);
   ExecuteScript("look2daint", OBJECT_SELF);
   
   SpawnNewThread("PsionPowerLoadin", "psi_psibk_load", 2.0f);
}
