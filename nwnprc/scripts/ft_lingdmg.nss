
// sets up events to add on hit unique property to weapon(s)
// and sets up the on hit event to run the proper script

#include "inc_eventhook"

void main()
{
    object oPC = OBJECT_SELF;
    
    AddEventScript(oPC, EVENT_ONPLAYEREQUIPITEM, "on_hit_add_w", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONPLAYERUNEQUIPITEM, "on_hit_rem_w", TRUE, FALSE);
    AddEventScript(oPC, EVENT_ONHIT, "prc_onhitcast", TRUE, FALSE);
}