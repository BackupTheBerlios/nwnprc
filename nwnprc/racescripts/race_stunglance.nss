//::///////////////////////////////////////////////
//:: Stunning Glance
//:: race_stunglance
//:://////////////////////////////////////////////
//:: Fort save or the target is stunned for 2d4 round
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Feb 21, 2008
//:://////////////////////////////////////////////


#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectStunned();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    int nDuration = d4(2);
    
    if(GetDistanceBetween(OBJECT_SELF, oTarget) > FeetToMeters(30.0))
        return;
    
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NYMPH_STUNNING_GLANCE));
        //Make Fort Save to negate effect
        if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
        {
            //Apply VFX Impact and stun effect
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

}
