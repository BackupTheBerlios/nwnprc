/*
    Frightful Presence
    All Creatures around the Samurai must pass a will save
    or become either panicked or shaken depending upon hit dice
*/
#include "prc_alterations"
#include "X2_I0_SPELLS"
void main()
{
    //Declare major variables
    object oTarget;
    object oPC = OBJECT_SELF;
    object oWeap = GetFirstItemInInventory(oPC);

    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    int nDuration = d6(4);


    int iPCCha = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iTACha = GetAbilityModifier(ABILITY_CHARISMA,oTarget);

    int nDC = 20 + iPCCha;

    int iPCRoll = GetSkillRank(SKILL_INTIMIDATE,oPC) + d20();
    int iTARoll = GetSkillRank(SKILL_INTIMIDATE,oTarget) + d20();

    int iHitDie = GetHitDice(oTarget);
    int iPCHD = GetHitDice(oPC);

    //Shaken Effect
    effect eDam = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
effect eVis2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLink = EffectLinkEffects(eDam,eSave);
    eLink = EffectLinkEffects(eLink,eSkill);
eLink = EffectLinkEffects(eLink,eVis2);

    //Panicked Effect
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eFear = EffectFrightened();

    effect eLink2 = EffectLinkEffects(eVis,eFear);

  if(!GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
   {

    //Determine enemies in the radius around the samurai
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
     {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
        //Make a will save
          if(!PRCMySavingThrow(SAVING_THROW_WILL,oTarget,nDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF))
          {
           //Make A HitDie Check
           if(iHitDie <= 4)
            {
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink2,oTarget,RoundsToSeconds(nDuration));
            }
            else if(iHitDie < iPCHD)
            {
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(nDuration));
            }

           }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
     }
	ExecuteScript("prc_cwsm_left", oPC);
	DelayCommand(0.1,ExecuteScript("prc_cwsm_right", oPC));
	//ExecuteScript("prc_cwsm_right", oPC);
    }
}
