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
    int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
    int nMax = GetLocalInt(GetModule(), "RigCacheMax"+IntToString(nBaseItemType));
    if(nMax < RIG_ITEM_CACHE_SIZE)
        nMax = RIG_ITEM_CACHE_SIZE;
    
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
    
    /*
    int nLevel = GetLocalInt(OBJECT_SELF, "Level");
    int nCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(nLevel));
    */
    if(nCount < nMax)
    {
        DoDebug(GetTag(OBJECT_SELF)+" creating level "+IntToString(nLevel)+". Cache at "+IntToString(nCount));
        int nAC = GetLocalInt(OBJECT_SELF, "AC");
        float fDelay = 0.01; //IntToFloat(Random(600))/100.0;
        DelayCommand(fDelay, CreateRandomizeItemByTypeForChest(nBaseItemType, nLevel, nAC));
        return;
    }

}

void main()
{
    //since there are ~70 of these, only 10% will fire on average each hb
    if(Random(10))
        return;
    //delay the firing to some time in the next 6 seconds
    float fDelay = IntToFloat(Random(60))/10.0;
    DelayCommand(fDelay, DoStuff());
}
