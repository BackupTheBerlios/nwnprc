#include "prc_inc_clsfunc"


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
     
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityDecrease(ABILITY_CONSTITUTION, iCon), oImage, 0.0);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oImage, 0.0);
    }
}
