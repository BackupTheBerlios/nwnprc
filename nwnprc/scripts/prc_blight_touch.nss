/*
  Talonas Blight.

*/

const int DISEASE_TALONAS_BLIGHT = 52;

#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int iDC = GetLevelByClass(CLASS_TYPE_BLIGHTLORD) + GetAbilityModifier(ABILITY_WISDOM, oPC) + 10;
    effect eDisease = EffectDisease(DISEASE_TALONAS_BLIGHT);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
       //Make SR check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,iDC))
        {
            //The effect is permament because the disease subsystem has its own internal resolution
            //system in place.
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget,0.0f,TRUE,-1,iDC);
            SetLocalInt(oTarget, "BlightDC", iDC);
        }
    }

    int iPenalty = d4(1);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, iPenalty);
    //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, iPenalty);
    //Make the damage supernatural
    //eCon = SupernaturalEffect(eCon);
    //eCha = SupernaturalEffect(eCha);

    //Make a saving throw check
    if(!FortitudeSave(oTarget, iDC, SAVING_THROW_TYPE_DISEASE))
    {
        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, iPenalty, TRUE, DURATION_TYPE_PERMANENT);
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oTarget);
        ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, iPenalty, TRUE, DURATION_TYPE_PERMANENT);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
