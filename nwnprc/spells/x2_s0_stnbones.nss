/*
    x2_s0_stnbones

    Gives the target +3 AC Bonus to Natural Armor.
    Only if target creature is undead.

    By: Andrew Nobbs
    Created: Nov 25, 2002
    Modified: Jun 30, 2006
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
    int nCasterLvl = nCasterLevel;
    int nDuration  = nCasterLvl * 10;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nRacial = MyPRCGetRacialType(oTarget);
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    //Check for metamagic extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Set the one unique armor bonuses
    effect eAC1 = EffectACIncrease(3, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eAC1, eDur);

    //Stacking Spellpass, 2003-07-07, Georg
    PRCRemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    if(nRacial == RACIAL_TYPE_UNDEAD)
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else
    {
        FloatingTextStrRefOnCreature(85390,OBJECT_SELF); // only affects undead;
    }

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