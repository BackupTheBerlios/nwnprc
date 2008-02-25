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

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(2, 2, 2, 2, 2, 2);
    int CasterLvl = nCasterLevel;
    int nPenetr =   CasterLvl + SPGetPenetr();

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);

    //INSERT SPELL CODE HERE
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!PRCMyResistSpell(OBJECT_SELF, oTarget,nPenetr))
         {
            //Make Will Save
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget,0.0f,TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}