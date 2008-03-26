/*
    nw_s0_bescurse

    Afflicted creature must save or suffer a -2 penalty
    to all ability scores. This is a supernatural effect.

    By: Bob McCabe
    Created: March 6, 2001
    Modified: Jun 12, 2006

    Flaming_Sword: Added touch attack roll
*/

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{   
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oCaster = OBJECT_SELF;
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object oTarget = PRCGetSpellTargetObject();
    
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(2, 2, 2, 2, 2, 2);
    effect eDespair = EffectAttackDecrease(1);
    int nPenetr =   CasterLvl + SPGetPenetr();

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);

    //INSERT SPELL CODE HERE
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, INVOKE_CURSE_OF_DESPAIR));
         //Make SR Check
         if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
         {
            //Make Will Save
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, OBJECT_SELF)))
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget,0.0f,TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDespair, oTarget,TurnsToSeconds(1),TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}