// mod_equip,prc_equip
/////////////////////////////////////////////////////////////////////
//
// This script has been auto-generated by HakInstaller to call
// multiple handlers for the onplayerequipitem event.
//
/////////////////////////////////////////////////////////////////////

#include "prc_gateway"

void main()
{
    ExecuteScript("mod_equip", OBJECT_SELF);
    if(!PRC_EVENT_DISABLE)
        ExecuteScript("prc_equip", OBJECT_SELF);
}