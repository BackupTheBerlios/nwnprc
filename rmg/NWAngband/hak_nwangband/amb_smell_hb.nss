#include "amb_inc"

void main()
{
    object oPC = GetFirstInPersistentObject();
    while(GetIsObjectValid(oPC))
    {
        DoSmellCheck(oPC);
        oPC = GetNextInPersistentObject();
    }
}
