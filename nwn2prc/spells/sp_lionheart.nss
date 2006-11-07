/*
    sp_lionheart

    Target becomes immune to fear.

    By: ???
    Created: ???
    Modified: Jul 2, 2006
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
    SPRaiseSpellCastAt(oTarget, FALSE);
    float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLevel));
    effect eBuff = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_FEAR), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);

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