/*
    Mass Staredown
    All Creatures around the Samurai must pass an
    opposed Intimidate Check or suffer penalites
*/

#include "prc_alterations"
#include "prc_class_const"
void main()
{
    //Declare major variables
    object oTarget;
    object oPC = OBJECT_SELF;

    int nDuration = 2;

    if(GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) >= 14)
    	nDuration = 5;
    
    int nPCSize = GetCreatureSize(oPC);
    int nDC;

    effect eDam = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eDam,eSave);
    eLink = EffectLinkEffects(eLink,eSkill);
    eLink = EffectLinkEffects(eLink,eVis);


    //Determine enemies in the radius around the samurai
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
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
           	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(nDuration));
           }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

}
