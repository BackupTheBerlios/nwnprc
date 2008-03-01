//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
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

    //Declare major variables
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());

    float fDuration = RoundsToSeconds(CasterLvl);
    int nDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eSaveD = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eAttackD = EffectAttackDecrease(2);
    effect eDmgD = EffectDamageDecrease(2,DAMAGE_TYPE_BLUDGEONING|DAMAGE_TYPE_PIERCING|DAMAGE_TYPE_SLASHING);
    float fDelay;
    //Link the shaken effects
    effect eLink2 = EffectLinkEffects(eAttackD, eDmgD);
    eLink2 = EffectLinkEffects(eLink2, eSaveD);
    eLink2 = EffectLinkEffects(eLink2, eMind);
    eLink2 = EffectLinkEffects(eLink2, eDur);
    int nPenetr = CasterLvl + SPGetPenetr();
    
    object oTarget;
    
    //Get first target in the spell cone
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
            && MyPRCGetRacialType(oTarget)!= RACIAL_TYPE_DRAGON)
        {
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
            //Make SR Check
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
            {
                //Make a will save - if failed, shaken for 10 minutes
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, TurnsToSeconds(10),TRUE,-1,CasterLvl));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE, GetPosition(OBJECT_SELF));
    }
    

}

