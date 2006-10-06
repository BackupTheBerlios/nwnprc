#include "rig_inc"

void CreateRandomizeItemByTypeForChest(int nBaseItemType, int nLevel, int nAC)
{
    object oItem = CreateRandomizeItemByType(nBaseItemType, nLevel, nAC);
    int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel));
    if(GetIsObjectValid(oItem))
        SetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel), nItemCount+1);
}

void main()
{
    int nMax = 5;/*
    object oTest = GetFirstItemInInventory();
    while(GetIsObjectValid(oTest))
    {
        int nItemLevel = GetLocalInt(oTest, "RigLevel");
        SetLocalInt(OBJECT_SELF, 
            "ContentsLevel"+IntToString(nItemLevel),
            GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nItemLevel))+1);
        oTest = GetNextItemInInventory();
    }*/
    int i;
    int nLevel = 1;
    int nCount = nMax;
    for(i=1;i<=40;i++)
    {
        int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel));
        if(nItemCount < nCount)   
        {
            nLevel = i;
            nCount = nItemCount;
        }
    
    }
    if(nCount < nMax)
    {
        //DoDebug(GetTag(OBJECT_SELF)+" creating level "+IntToString(nLevel));
        int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
        int nAC = GetLocalInt(OBJECT_SELF, "AC");
        float fDelay = IntToFloat(Random(600))/100.0;
        DelayCommand(fDelay, CreateRandomizeItemByTypeForChest(nBaseItemType, nLevel, nAC));
        return;
    }
}
