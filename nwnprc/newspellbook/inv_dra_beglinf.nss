
#include "spinc_common"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nSkillBonus = GetHasFeat(FEAT_MORPHEME_SAVANT) ? max(GetAbilityModifier(ABILITY_CHARISMA) * 2, 6) : 6;
    effect eSkill = EffectSkillIncrease(SKILL_BLUFF, nSkillBonus);
    effect eSkill1 = EffectSkillIncrease(SKILL_INTIMIDATE, nSkillBonus);
    effect eSkill2 = EffectSkillIncrease(SKILL_PERSUADE, nSkillBonus);
    effect eLink = EffectLinkEffects(eSkill, eSkill1);
    eLink = EffectLinkEffects(eLink, eSkill2);
    eLink = EffectLinkEffects(eLink, eDur);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_BEGUILING_INFLUENCE, FALSE));
    
    //Apply the VFX impact and effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

}
