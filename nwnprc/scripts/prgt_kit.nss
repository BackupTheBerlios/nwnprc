/*
This is the tag-based item script for the new trap kit
It handles the trap kit being destroyed and the PC being rewarded for recovery
*/
#include "prc_alterations"
#include "prc_x2_switches"
#include "prgt_inc"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;
    if (nEvent == X2_ITEM_EVENT_ACQUIRE)
    {
        oPC = GetModuleItemAcquiredBy();
        oItem  = GetModuleItemAcquired();

        DestroyObject(oItem);
        DoTrapXP(GetModuleItemAcquiredFrom(), oPC, TRAP_EVENT_RECOVERED);
    }
}
