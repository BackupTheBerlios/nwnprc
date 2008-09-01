/////////////////////////////////////////////////
// Bowman Focus
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    // The pile of effects that are given to the Bowman when it focuses
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nClass = GetLevelByClass(CLASS_TYPE_BOWMAN, OBJECT_SELF);
    int nDex = 4;
    int nAtk = 1;
    if (nClass >= 19)
    {
    	nDex = 10;
    	natk = 4;
    }
    if (nClass >= 13)
    {
    	nDex = 8;
    	natk = 3;
    }
    if (nClass >= 9)
    {
    	nDex = 6;
    	natk = 2;
    }    
    
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY, nDex);
    effect eAtk = EffectModifyAttacks(nAtk);
    effect eLink = EffectLinkEffects(eDex, eDur);
    eLink = EffectLinkEffects(eLink, eAtk);
    
    eLink = ExtraordinaryEffect(eLink);
    int nDur = (GetAbilityModifier(3 + nClass/2);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDur));
}