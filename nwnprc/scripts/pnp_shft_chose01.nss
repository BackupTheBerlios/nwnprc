// this script runs when the player selects the form 1 from the list to shift into

#include "prc_alterations"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=0;
    ShiftFromKnownArray(nStartIndex,FALSE,oPC);
}
