/////////////////////////////////////////////////
// Fist of Hextor Strength Boost
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////

#include "prc_class_const"

void main()
{

    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nStr = GetLevelByClass(CLASS_TYPE_HEXTOR, OBJECT_SELF);
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
    effect eLink = EffectLinkEffects(eStr, eDur);
    float fDur = (GetLevelByClass(CLASS_TYPE_HEXTOR, OBJECT_SELF) + 4.0);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDur);

}