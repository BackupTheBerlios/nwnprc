/*
	Deep Gnome Blindness/Deafness
*/
#include "spinc_common"
#include "NW_I0_SPELLS"

void main()
{

    //Declare major varibles
    object oTarget = GetSpellTargetObject();
    int CasterLvl = 3;

    int nDuration = CasterLvl;
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
    int nPenetr = CasterLvl + SPGetPenetr();
            
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            // Make Fortitude save to negate
            if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF))))
            {
                //Apply visual and effects
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
