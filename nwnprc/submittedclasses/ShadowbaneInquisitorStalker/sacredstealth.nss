



void main()
{
    //Declare major variables
    int nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    int nDuration = nCharismaBonus + nCasterLvl;

    effect eHide = EffectSkillIncrease(SKILL_HIDE, 4);
    effect eMove = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 4);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eHide, eMove);
    effect eLink2 = EffectLinkEffects(eLink, eDur);

    //Fire spell cast at event for target
    //SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 1125, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, OBJECT_SELF, TurnsToSeconds(nDuration));

}
