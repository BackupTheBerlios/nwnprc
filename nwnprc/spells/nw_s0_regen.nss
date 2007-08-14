/*
    nw_s0_regen

    Grants the selected target 6 HP of regeneration
    every round.

    By: Preston Watamaniuk
    Created: Oct 22, 2001
    Modified: Jun 16, 2006
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
    effect eRegen = EffectRegenerate(6, 6.0);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eRegen, eDur);
    int nMeta = PRCGetMetaMagicFeat();
    int nDur = PRCGetCasterLevel(OBJECT_SELF);
    //Meta-Magic Checks
    if (nMeta == METAMAGIC_EXTEND)
        nDur *= 2;
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_REGENERATE, FALSE));
    //Apply effects and VFX
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    
    //Regrow fingers
    if(GetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND"))
    {
            SetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND", 6);
            SetPersistantLocalInt(oPC, "FINGERS_RIGHT_HAND", 6);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
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