/*
    nw_s0_barkskin

    Enhances the casters Natural AC by an amount
    dependant on the caster's level.

    By: Preston Watamaniuk
    Created: Feb 21, 2001
    Modified: Jun 12, 2006
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
    int CasterLvl = nCasterLevel;
    int nBonus;
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = HoursToSeconds(nCasterLevel);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    effect eHead = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eAC;
    //Signal spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BARKSKIN, FALSE));
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) //Duration is +100%
    {
        fDuration = HoursToSeconds(nCasterLevel * 2);
    }

    //Determine AC Bonus based Level.
    if (nCasterLevel <= 6)
    {
        nBonus = 3;
    }
    else
    {
        if (nCasterLevel <= 12)
        {
            nBonus = 4;
        }
        else
        {
            nBonus = 5;
        }
     }
    //Make sure the Armor Bonus is of type Natural
    eAC = EffectACIncrease(nBonus, AC_NATURAL_BONUS);
    effect eLink = EffectLinkEffects(eVis, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHead, oTarget);

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
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
    PRCSetSchool();
}