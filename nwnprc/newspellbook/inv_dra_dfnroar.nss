#include "prc_inc_spells"
#include "X0_I0_SPELLS"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding

    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());

    effect eDeaf = EffectDeaf();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    float fDelay;
    //Link the panicked effects
    effect eLink = EffectLinkEffects(eDeaf, eDur);
    int nPenetr = CasterLvl + SPGetPenetr();
    
    object oTarget;
    
    //Get first target in the spell cone
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, INVOKE_DEAFENING_ROAR));
            //Make SR Check
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
            {
                //Make a fort save
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetInvocationSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_SONIC, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0,TRUE,-1,CasterLvl));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, FeetToMeters(30.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    }
    

}

