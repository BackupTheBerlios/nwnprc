//::///////////////////////////////////////////////
//:: Energy Drain
//:: NW_S0_EneDrain.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target loses 2d4 levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2003

//::Added hold ray functionality - HackyKid

#include "prc_inc_spells"
#include "prc_alterations"
#include "x2_inc_spellhook"
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
    int nDrain = d4(2);

    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    //Undead Gain HP from Energy Drain
    int nHP = d4(2);
    nHP = nHP + nHP + nHP + nHP +nHP;
    effect eHP = EffectTemporaryHitpoints(nHP);

    //Enter Metamagic conditions
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE, TRUE);
    if (nMetaMagic == METAMAGIC_MAXIMIZE || iBlastFaith)
    {
        nDrain = 8;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    effect eDrain = EffectNegativeLevel(nDrain);
    eDrain = SupernaturalEffect(eDrain);

    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(1),TRUE,-1,nCasterLevel);
    }
    else if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERGY_DRAIN));
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))
        {

           if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget,0.0f,TRUE,-1,nCasterLevel);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
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
        if (GetLocalInt(oCaster, PRC_SPELL_HOLD) && GetHasFeat(FEAT_EF_HOLD_RAY, oCaster) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
	if (oCaster != oTarget)	//cant target self with this spell, only when holding charge
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
