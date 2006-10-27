#include "prc_alterations"

void main()
{
    int i;
    object oTest;
    for(i = 0; i <= 9; i++)
    {
        oTest = GetObjectByTag("SpellLvl_9_Level_" + IntToString(i));
        DoDebug("Name: " + GetName(oTest));
        DoDebug("Tag: " + GetTag(oTest));
        DoDebug("Resref: " + GetResRef(oTest));
        DoDebug(IntToString(array_get_size(oTest, GetTag(oTest))));
    }
}