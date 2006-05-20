#include "amb_inc"

void main()
{
    object oPC = GetFirstInPersistentObject();
    while(GetIsObjectValid(oPC))
    {
        DoSoundCheck(oPC);
        oPC = GetNextInPersistentObject();
    }
}
