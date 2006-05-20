#include "amb_inc"

void main()
{
    object oPC = GetFirstInPersistentObject();
    while(GetIsObjectValid(oPC))
    {
        DoFeelingCheck(oPC);
        oPC = GetNextInPersistentObject();
    }
}
