// this script runs when the player selects the form 9 from the list to shift into

#include "nw_i0_generic"
#include "prc_alterations"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=8;
    ShiftFromKnownArray(nStartIndex,TRUE,oPC);
}
