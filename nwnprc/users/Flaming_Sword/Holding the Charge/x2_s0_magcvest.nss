/*
    x2_s0_magcvest

    Grants a +1 AC bonus to armor touched per 3 caster
    levels (maximum of +5).

    By: Andrew Nobbs
    Created: Nov 28, 2002
    Modified: Jun 30, 2006
*/

#include "prc_sp_func"

void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   return;
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nDuration  = nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nAmount = nDuration/3;
    if (nAmount <0)
    {
        nAmount =1;
    }
    else if (nAmount>5)
    {
        nAmount =5;
    }
    object oMyArmor   =  IPGetTargetedOrEquippedArmor(TRUE);
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2; //Duration is +100%
    }
    if(GetIsObjectValid(oMyArmor) )
    {
        SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        if (nDuration>0)
        {
            location lLoc = GetLocation(PRCGetSpellTargetObject());
            DelayCommand(1.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), HoursToSeconds(nDuration));
            AddACBonusToArmor(oMyArmor, HoursToSeconds(nDuration),nAmount);
    }
        return TRUE;
    }
        else
    {
           FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
           return TRUE;
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