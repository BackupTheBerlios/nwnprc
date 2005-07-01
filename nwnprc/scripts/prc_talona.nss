#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int iPenalty = d4(1);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    //effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, iPenalty);
    //effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, iPenalty);
    //Make the damage supernatural
    //eCon = SupernaturalEffect(eCon);
    //eCha = SupernaturalEffect(eCha);
    int iDC = GetLocalInt(oPC, "BlightDC");

    //Make a saving throw check
    if(!FortitudeSave(oPC, iDC, SAVING_THROW_TYPE_DISEASE))
    {
        //Apply the VFX impact and effects
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oPC);
        //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oPC);
        ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, iPenalty, TRUE, DURATION_TYPE_PERMANENT);
        ApplyAbilityDamage(oPC, ABILITY_CHARISMA, iPenalty, TRUE, DURATION_TYPE_PERMANENT);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    }
}
