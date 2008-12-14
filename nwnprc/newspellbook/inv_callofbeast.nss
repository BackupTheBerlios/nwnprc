//::///////////////////////////////////////////////
//:: [Charm Person or Animal]
//:: [NW_S0_DomAni.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
    eCharm = PRCGetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link the charm and duration visual effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    int nDuration = 2  + CasterLvl/3;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);
    int nPenetr = CasterLvl + SPGetPenetr();
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire spell cast at event to fire on the target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_CALL_OF_THE_BEAST, FALSE));
        //Make SR Check
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            //Make sure the racial type of the target is applicable
            if(nRacial == RACIAL_TYPE_ANIMAL)
            {
                //Make Will Save
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact effects and linked duration and charm effect
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}
