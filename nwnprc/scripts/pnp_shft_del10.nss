//for the form selected from the list and confermed, delete from known forms array

#include "prc_alterations"
#include "prc_alterations"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=9;
    DeleteFromKnownArray(nStartIndex,oPC);
}
