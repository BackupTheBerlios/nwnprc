void main ()
{
    int iCnt = 1;
    object oPC = OBJECT_SELF;
    object oCre = GetLocalObject(oPC, "EnslavedCreature");

    if(!GetIsObjectValid(oCre)) return;

    effect eDom = EffectDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eLink2 = SupernaturalEffect(eLink);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);

    ForceRest(oCre);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oCre);
}
