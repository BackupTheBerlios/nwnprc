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



// Applies the effect to the target from the Energy Retort power.
void PsiEnergyRetort(object oCaster, object oTarget);




// ---------------
// BEGIN FUNCTIONS
// ---------------

void PsiEnergyRetort(object oCaster, object oTarget)
{
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
		
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
		nCaster += 2;
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
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
			if(PRCMySavingThrow(nSavingThrow, oTarget, nDC, nSaveType))
			{
				effect eDam = EffectDamage(nDamage, nDamageType);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
			}
		}
	}
}

