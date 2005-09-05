#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int iPCCha = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iTACha = GetAbilityModifier(ABILITY_CHARISMA,oTarget);

    int iPCRoll = GetSkillRank(SKILL_INTIMIDATE,oPC) + d20();
    int iTARoll = GetSkillRank(SKILL_INTIMIDATE,oTarget) + d20();

    effect eDam = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eDam,eSave);
    eLink = EffectLinkEffects(eLink,eSkill);
    eLink = EffectLinkEffects(eLink,eVis);

    if(iPCRoll > iTARoll)
    	{
	FloatingTextStringOnCreature("*Staredown Succeeded*",OBJECT_SELF);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(2));
	}
     else
     	FloatingTextStringOnCreature("*Staredown Failed*",OBJECT_SELF);


}
