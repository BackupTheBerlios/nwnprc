/*
    nw_s0_catgrace

    The transmuted creature becomes more graceful,
    agile, and coordinated. The spell grants an
    enhancement  bonus to Dexterity of 1d4+1
    points, adding the usual benefits to AC,
    Reflex saves, Dexterity-based skills, etc.

    By: Noel Borstad
    Created: Oct 18, 2000
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
    effect eDex;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int CasterLvl = nCasterLevel;
    int nModify = d4() + 1;
    float fDuration = HoursToSeconds(CasterLvl);
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Signal spell cast at event to fire on the target.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CATS_GRACE, FALSE));
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nModify = 5;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nModify = FloatToInt( IntToFloat(nModify) * 1.5 ); //Damage/Healing is +50%
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }
    //Create the Ability Bonus effect with the correct modifier
    eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
    effect eLink = EffectLinkEffects(eDex, eDur);

    // Stratovarius - Prevents stacking of normal and Mass spells
    RemoveEffectsFromSpell(oTarget, SPELL_MASS_CATS_GRACE);

    //Apply visual and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

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