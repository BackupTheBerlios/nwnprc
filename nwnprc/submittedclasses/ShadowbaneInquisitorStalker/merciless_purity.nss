//::///////////////////////////////////////////////
//:: Name: Merciless Puirty
//:: FileName prc_merciless
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//: Mericless Puirty Feat
*/
//:://////////////////////////////////////////////
//:: Created By: MythicWanderer
//:: Created On: 09-04-05
//:://////////////////////////////////////////////

#include "prc_feat_const"

void main()
{
object oPC = OBJECT_SELF;

    if(GetHasFeat(FEAT_MERCILESS_PURITY))
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_FORT, 1, SAVING_THROW_TYPE_ALL), oPC, 24.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 1, SAVING_THROW_TYPE_ALL), oPC, 24.0);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC);
    }
  
}