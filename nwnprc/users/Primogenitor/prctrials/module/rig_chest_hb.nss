#include "rig_inc"

void CreateRandomizeItemByTypeForChest(int nBaseItemType, int nLevel, int nAC)
{
    object oItem = CreateRandomizeItemByType(nBaseItemType, nLevel, nAC);
    int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel));
    if(GetIsObjectValid(oItem))
        SetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel), nItemCount+1);
}

void DoStuff()
{
    int nMax = RIG_ITEM_CACHE_SIZE;/*
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
    int nCount = nMax; //lowest number of items of nLevel level
    for(i=1;i<=40;i++)
    {
        int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(i));
        if(nItemCount < nCount)   
        {
            nLevel = i;
            nCount = nItemCount;
        }
        //shortcut if totally out of something cant get lower
        if(nCount == 0)
            break;    
    }
    if(nCount < nMax)
    {
        DoDebug(GetTag(OBJECT_SELF)+" creating level "+IntToString(nLevel));
        int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
        int nAC = GetLocalInt(OBJECT_SELF, "AC");
        float fDelay = 0.01; //IntToFloat(Random(600))/100.0;
        DelayCommand(fDelay, CreateRandomizeItemByTypeForChest(nBaseItemType, nLevel, nAC));
        return;
    }

}

void main()
{
    float fDelay;
    for(fDelay = 0.0; fDelay < 6.0; fDelay += 7.0)
    {
        DelayCommand(fDelay, DoStuff());
    }
}
