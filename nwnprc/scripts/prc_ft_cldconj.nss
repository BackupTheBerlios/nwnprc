#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
    effect eConceal2 = EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED);
    //set up sickened effect
    effect eAtt = EffectAttackDecrease(2);
    effect eDam = EffectDamageDecrease(2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eLink = EffectLinkEffects(eAtt, eDam);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eSave);
    //Set VFX
    effect eVis = EffectVisualEffect(VFX_IMP_POISON_L);    
    // Link
    eLink = EffectLinkEffects(eLink, eConceal2);
    eLink = EffectLinkEffects(eLink, eConceal);

    if (GetIsFriend(oTarget, GetAreaOfEffectCreator())) 
    {
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
