// this script runs when the player selects the form 10 from the list to shift into

#include "prc_alterations"
#include "prc_alterations"

// The user has selected index 1 from the starting condition to shift into

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=9;
    ShiftFromKnownArray(nStartIndex,FALSE,oPC);
}
