// this script runs when the player selects the form 5 from the list to shift into

#include "prc_alterations"
#include "prc_alterations"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=4;
    ShiftFromKnownArray(nStartIndex,TRUE,oPC);
}
