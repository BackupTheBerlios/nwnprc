#include "prc_inc_clsfunc"
#include "x2_i0_spells"

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
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void RemoveExtraImages()
{
    string sImage1 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"mirror";
    string sImage2 = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage1 || GetTag(oCreature) == sImage2)
         {
         DestroyObject(oCreature, 0.0);
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }
}

void main2()
{

object oTarget = GetSpellTargetObject();
int iLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
int iAdd = iLevel/3;
int iImages = d4(1) + 3;
RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

SetLocalObject(OBJECT_SELF, "FLURRY_TARGET", oTarget);
FlurryEffects(OBJECT_SELF);

string sImage = "PC_IMAGE"+ObjectToString(OBJECT_SELF)+"flurry";

effect eImage = EffectCutsceneGhost();
       eImage = SupernaturalEffect(eImage);
effect eNoSpell = EffectSpellFailure(100);
       eNoSpell = SupernaturalEffect(eNoSpell);

    int iPlus;
    for (iPlus = 0; iPlus < iImages; iPlus++)
    {

     object oImage = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, sImage);
     DelayCommand(1.0, CleanCopy(oImage));

     AssignCommand(oImage, ActionAttack(oTarget, FALSE));
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eImage, oImage);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNoSpell, oImage);

     DestroyObject(oImage, 9.0); // they dissapear after one round
    }
    object oCreature = GetFirstObjectInArea(GetArea(OBJECT_SELF));
    while (GetIsObjectValid(oCreature))
        {
         if(GetTag(oCreature) == sImage)
         {
         DelayCommand(3.0, SPMakeAttack(oTarget, oCreature));
         }
         oCreature = GetNextObjectInArea(GetArea(OBJECT_SELF));;
        }

}

void main()
{
   DelayCommand(0.0, RemoveExtraImages());
   DelayCommand(0.5, main2());
}
