// redominates enslaved creatures on rest.
void main ()
{
    object oPC = OBJECT_SELF;
    object oCre = GetLocalObject(oPC, "EnslavedCreature");

    if(!GetIsObjectValid(oCre)) return;
    
    effect eDom = EffectCutsceneDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);
    effect eLink2 = SupernaturalEffect(eLink);

    ForceRest(oCre);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oCre);
}
