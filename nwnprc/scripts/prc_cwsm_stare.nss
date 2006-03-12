#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nPCSize = GetCreatureSize(oPC);
    int nDC;

    effect eDam = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eDam,eSave);
    eLink = EffectLinkEffects(eLink,eSkill);
    eLink = EffectLinkEffects(eLink,eVis);

           //Make Intimidate Check
           int nWis = GetAbilityModifier(ABILITY_WISDOM,oTarget);
           int nHD = GetHitDice(oTarget);
           int nRoll = d20();
           nDC = nWis + nHD + nRoll;
           
           int nTargetSize = GetCreatureSize(oTarget);
           // Size bonus to the check. Its a +4 benefit to the samurai for each category he is larger
           // Or a -4 loss for each he is smaller.
           if (nPCSize > nTargetSize) nDC -= (nPCSize - nTargetSize) * 4;
           if (nTargetSize > nPCSize) nDC += (nTargetSize - nPCSize) * 4;
           
           if(GetIsSkillSuccessful(oPC, SKILL_INTIMIDATE, nDC))
    	   {
		FloatingTextStringOnCreature("*Staredown Succeeded*",OBJECT_SELF);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(2));
	   }
           else
     		FloatingTextStringOnCreature("*Staredown Failed*",OBJECT_SELF);
}
