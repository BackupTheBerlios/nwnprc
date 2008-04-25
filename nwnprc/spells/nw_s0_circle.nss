/*
    nw_s0_circle

    Magic Circle Against Good, Evil, Law, Chaos

    By: Flaming_Sword
    Created: Jun 13, 2006
    Modified: Jun 13, 2006

    Consolidation of 4 scripts, cleaned up
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
    effect eAOE;
    effect eVis;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eVis2;
    string temp;

    int nSpellID = PRCGetSpellId();
    switch(nSpellID)
    {
        case SPELL_MAGIC_CIRCLE_AGAINST_CHAOS:
        {
            eAOE = EffectAreaOfEffect(AOE_MOB_CIRCCHAOS);
            temp = "TEMPO_CIRCCHAOS";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_EVIL:
        {
            eAOE = EffectAreaOfEffect(AOE_MOB_CIRCGOOD);
            temp = "TEMPO_CIRCEVIL";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_GOOD:
        {
            eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL);
            temp = "TEMPO_CIRCGOOD";
            break;
        }
        case SPELL_MAGIC_CIRCLE_AGAINST_LAW:
        {
            eAOE = EffectAreaOfEffect(AOE_MOB_CIRCLAW);
            temp = "TEMPO_CIRCLAW";
            break;
        }
    }

    if((nSpellID == SPELL_MAGIC_CIRCLE_AGAINST_CHAOS) ||
        (nSpellID == SPELL_MAGIC_CIRCLE_AGAINST_GOOD))
    {
        eVis = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
        eVis2 = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    }
    else
    {
        eVis = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
        eVis2 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    }

    effect eLink = EffectLinkEffects(eAOE, eVis);
    eLink = EffectLinkEffects(eLink, eDur);
    int nDuration = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make sure duration does not equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));
    //Create an instance of the AOE Object using the Apply Effect function
    if (GetLocalInt(OBJECT_SELF,temp))
     SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetLocalInt(OBJECT_SELF,temp)),TRUE,-1,nCasterLevel);
    else
     SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
    DeleteLocalInt(OBJECT_SELF,temp);

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
