 //::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
//:: added hold ray functionality - HackyKid

#include "spinc_common"
#include "prc_inc_sp_tch"
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

    int iAttackRoll = 0;    //placeholder

    int nDam = d4(1) + 1;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

        iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            //Make SR Check
            if(!PRCMyResistSpell(OBJECT_SELF, oTarget, nPenetr))
            {
                 //Enter Metamagic conditions
                 if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                 {
                     nDam = 5 ;//Damage is at max
                 }
                 else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                 {
                     nDam = nDam + nDam/2; //Damage/Healing is +50%
                 }

                 // perform ranged touch attack and apply sneak attack if any exists
                 int eDamageType = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_COLD);
                 ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDam, eDamageType);
                 PRCBonusDamage(oTarget);

                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
             }
        }
        effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND, !iAttackRoll);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
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
    SPSetSchool();
}
