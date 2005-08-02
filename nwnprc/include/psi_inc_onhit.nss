/*
    Psionic OnHit.
    This scripts holds all functions used for psionics on hit powers and abilities.

    Stratovarius
*/

// Include Files:
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "psi_inc_psifunc"
#include "X0_I0_SPELLS"
#include "psi_inc_pwresist"
#include "prc_inc_combat"



// Applies the effect to the target from the Energy Retort power.
void PsiEnergyRetort(object oCaster, object oTarget);

// Applies the effects to the target from the Fate Link power
void FateLink(object oCaster);

// Applies the effects to the target from the Share Pain, and Share Pain, Forced powers
void SharePain(object oCaster);

// Applies the effects to the target from the Empathic Feedback power
void EmpathicFeedback(object oPC);

// Does the concentration check on damage for the Energy Current power.
void EnergyCurrent(object oCaster);

// ---------------
// BEGIN FUNCTIONS
// ---------------

void PsiEnergyRetort(object oCaster, object oTarget)
{
    int nDC = GetManifesterDC(oCaster);
    int nCaster = GetManifesterLevel(oCaster);
    int nPen = GetPsiPenetration(oCaster);
        
    int nDamage;
    effect eVis;
    effect eRay;
    int nSavingThrow;
    int nSaveType;
    int nDamageType;
    int nElement = GetLocalInt(oCaster, "PsiEnRetort");
    
    if (nElement == 1)
    {
        nDamage = (d6(4) + 4);
        eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        eRay = EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_HAND);
        nSavingThrow = SAVING_THROW_FORT;
        nSaveType = SAVING_THROW_TYPE_COLD;
        nDamageType = DAMAGE_TYPE_COLD;
    }
    else if (nElement == 2)
    {
        nDamage = d6(4);
        eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
        eRay = EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND);
        nSavingThrow = SAVING_THROW_REFLEX;
        nSaveType = SAVING_THROW_TYPE_ELECTRICITY;
        nDamageType = DAMAGE_TYPE_ELECTRICAL;
        nDC += 2;
        nPen += 2;
    }
    else if (nElement == 3)
    {
        nDamage = (d6(4) + 4);
        eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eRay = EffectBeam(VFX_BEAM_FIRE, oCaster, BODY_NODE_HAND);
        nSavingThrow = SAVING_THROW_REFLEX;
        nSaveType = SAVING_THROW_TYPE_FIRE;
        nDamageType = DAMAGE_TYPE_FIRE;
    }
    else if (nElement == 4)
    {
        nDamage = (d6(4) - 4);
        eVis = EffectVisualEffect(VFX_IMP_SONIC);
        eRay = EffectBeam(VFX_BEAM_MIND, oCaster, BODY_NODE_HAND);
        nSavingThrow = SAVING_THROW_REFLEX;
        nSaveType = SAVING_THROW_TYPE_SONIC;
        nDamageType = DAMAGE_TYPE_SONIC;
    }
        
    SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
        
    // Perform the Touch Attach
    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
    if (nTouchAttack > 0)
    {
        //Check for Power Resistance
        if (PRCMyResistPower(oCaster, oTarget, nPen))
        {
            if(PRCMySavingThrow(nSavingThrow, oTarget, nDC, nSaveType))
            {
                nDamage /= 2;
            }
            effect eDam = EffectDamage(nDamage, nDamageType);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
        }
    }
}

void FateLink(object oCaster)
{
	object oTarget = GetLocalObject(oCaster, "FatedPartner");
	int nDam = GetTotalDamageDealt();
	int nDC;
	effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	
	if (GetIsDead(oCaster))
	{
		nDC = GetLocalInt(oTarget, "FateLinkDC");
		effect eDrain = EffectNegativeLevel(2);
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget);
		}
	}
	if (GetIsDead(oTarget))
	{
		nDC = GetLocalInt(oCaster, "FateLinkDC");
		effect eDrain = EffectNegativeLevel(2);
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oCaster, nDC, SAVING_THROW_TYPE_NONE))
		{
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oCaster);
		}
	}	
}

void SharePain(object oCaster)
{
     int iDamageTaken = GetTotalDamageDealt();
     int iHalf = iDamageTaken/2;
     object oTarget = GetLocalObject(oCaster, "SharePainTarget");
     
     effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_L);
     effect eHeal = EffectHeal(iHalf);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oCaster);
     
     effect eDam = EffectDamage(iHalf, DAMAGE_TYPE_POSITIVE);
     effect eVisHarm = EffectVisualEffect(VFX_IMP_HARM);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHarm, oTarget);
     
     if (GetIsDead(oTarget))	DeleteLocalInt(oCaster, "SharePain");
}

void EmpathicFeedback(object oPC)
{
     object oFoe = GetLastDamager();
     
     int iDR = GetLocalInt(oPC, "EmpathicFeedback");
     int iDamageTaken = GetTotalDamageDealt();
     
     int nDam = 0;
          
     if (iDR > iDamageTaken)
     {
     	nDam = iDamageTaken;
     }
     else
     {
     	nDam = iDR;
     }
          
     effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oFoe);
}

void EnergyCurrent(object oCaster)
{
	int nElement = GetLocalInt(oCaster, "PsiEnCurrent");
	int iDamageTaken = GetTotalDamageDealt();
	int nSpell;
     
     	// DC is 10 + spell level
	int nCheck = GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, (10 + iDamageTaken));
	
	// If the check is failed, remove the spell.
	if (!nCheck)
	{
		// Replace these with the proper spell Ids when they are added
		if (nElement == 1) nSpell = -1;
		if (nElement == 2) nSpell = -1;
		if (nElement == 3) nSpell = -1;
		if (nElement == 4) nSpell = -1;
		
		RemoveSpellEffects(nSpell, oCaster, oCaster);
		DeleteLocalInt(oCaster, "PsiEnCurrent");
	}
}
