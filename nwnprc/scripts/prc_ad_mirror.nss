#include "prc_inc_clsfunc"

void CleanCopy(object oImage)
{     
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<14;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(oImage, GetGold(oImage), TRUE);
}

void main()
{
int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
int iAdd = iLevel/3;
int iImages = d4(1) + iAdd;
int iCon = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION) - 1;

    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {

     object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "PC_IMAGE");
     DelayCommand(1.0, CleanCopy(oImage));

     object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, iCon), oImage, 0.0);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oImage, 0.0);
     DestroyObject(oSkin, 0.1);
    }
}