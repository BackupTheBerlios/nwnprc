#include "rig_inc"

void main()
{
    SetAILevel(OBJECT_SELF, AI_LEVEL_VERY_LOW);
    int nCount;
    object oTest = GetFirstItemInInventory();
    while(GetIsObjectValid(oTest))
    {
        nCount++;
        oTest = GetNextItemInInventory();
    }
    int nMax = 20;
    if(nCount < nMax)
    {
        int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
        int nLevel = GetLocalInt(OBJECT_SELF, "Level");
        int nAC = GetLocalInt(OBJECT_SELF, "AC");
        float fDelay = IntToFloat(Random(600))/100.0;
        DelayCommand(fDelay, VoidCreateRandomizeItemByType(nBaseItemType, nLevel, nAC));
    }
}
