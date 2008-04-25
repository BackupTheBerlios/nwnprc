/*
    Ollam's Inspire Confidence
*/

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    int nDur = GetLevelByClass(CLASS_TYPE_OLLAM, OBJECT_SELF);
    int nBoost = 2;
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DWARF) nBoost = 3;
    
    
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, nBoost);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSkill, oTarget, RoundsToSeconds(nDur));
}

