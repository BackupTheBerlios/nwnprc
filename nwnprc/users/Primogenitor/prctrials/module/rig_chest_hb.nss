#include "rig_inc"

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
    for(i=1;i<=40;i++)
    {
        int nItemCount = GetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(i));
        if(nItemCount < nMax)
        {
            //DoDebug(GetTag(OBJECT_SELF)+" creating level "+IntToString(i));
            int nBaseItemType = GetLocalInt(OBJECT_SELF, "BaseItem");
            int nAC = GetLocalInt(OBJECT_SELF, "AC");
            float fDelay = IntToFloat(Random(600))/100.0;
            DelayCommand(fDelay, VoidCreateRandomizeItemByType(nBaseItemType, i, nAC));
            SetLocalInt(OBJECT_SELF, "ContentsLevel"+IntToString(i), nItemCount+1);
            return;
        }
    }
}
