/*
    sp_jump

    Transmutation
    Level: Drd 1, Rgr 1, Sor/Wiz 1
    Components: V, S, M
    Casting Time: 1 standard action
    Range: Touch
    Target: Creature touched
    Duration: 1 min./level (D)
    Saving Throw: Will negates (harmless)
    Spell Resistance: Yes
    The subject gets a +10 enhancement bonus on Jump checks. The enhancement bonus increases to +20 at caster level 5th, and to +30 (the maximum) at caster level 9th.
    Material Component: A grasshopper’s hind leg, which you break when the spell is cast.

    By: Flaming_Sword
    Created: Sept 27, 2006
    Modified: Sept 27, 2006
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
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fDuration = 60.0 * nCasterLevel; //modify if necessary
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;

    SPRaiseSpellCastAt(oTarget, FALSE);
    int nBonus;
    if(nCasterLevel >= 9) nBonus = 30;
    else if (nCasterLevel >= 5) nBonus = 20;
    else nBonus = 10;

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_JUMP, nBonus), oTarget, fDuration, TRUE, -1, nCasterLevel);

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