// this script runs when the player selects the form 1 from the list to shift into

#include "nw_i0_generic"
#include "prc_alterations"

void main()
{
    object oPC = GetPCSpeaker();
    int iIndex = GetLocalInt(oPC,"ShifterListIndex");
    int iQuickSlot = GetLocalInt(oPC,"pnp_shft_qs");
    int iEpic = GetLocalInt(oPC,"pnp_shft_qse");
    // add index to the start
    iIndex+=2;
    SetQuickSlot(oPC,iIndex,iQuickSlot,iEpic);
}
