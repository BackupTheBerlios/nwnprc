//::///////////////////////////////////////////////
//:: Ungol Dust On Hit
//:: poison_ungol2
//:://////////////////////////////////////////////
/*
    1 Point Permenent Charisma Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 24, 2004
//:://////////////////////////////////////////////

void main()
{
    object oTarget = OBJECT_SELF;

    effect eDrain = EffectAbilityDecrease(ABILITY_CHARISMA, 1);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}