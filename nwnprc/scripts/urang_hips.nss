

void main()
{


    object oTarget = GetSpellTargetObject();
    effect eMov = EffectMovementSpeedDecrease(50);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eLink = EffectLinkEffects(eInvis, eMov);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);

}