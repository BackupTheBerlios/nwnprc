/*
	Feyri Clairaudience
*/
#include "spinc_common"
void main()
{
    //Declare major variables
    effect eSpot = EffectSkillIncrease(SKILL_SPOT, 10);
    effect eListen = EffectSkillIncrease(SKILL_LISTEN, 10);
    effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eSpot, eListen);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetSpellTargetObject();
    int CasterLvl = 3;
    int nLevel = CasterLvl;
    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, FALSE));

         //Apply linked and VFX effects
         SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nLevel),TRUE,-1,CasterLvl);
    }
}

