//::///////////////////////////////////////////////
//:: Metapsionic feat Chain effect include
//:: psi_inc_chain
//::///////////////////////////////////////////////
/*
    Fires beams from the primary target to up to 20 secondary
    targets, dealing each half of what the primary was dealt.
    The secondary targets get their own saving throws to
    affect this damage assuming the modified power allows for
    such.
    
    This file contains the main function, which unfortunately
    requires a lot of parameters. Therefore, I've also supplied
    a wrapper for it that has a smaller parameter list.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 18.01.2005
//:://////////////////////////////////////////////


#include "spinc_common"
#include "psi_inc_pwresist"
#include "psi_inc_psifunc"

#include "inc_target_list"

// 30 feet
const float CHAIN_RADIUS = 9.144f;


void DoChainShortWrap(object oOrigin, int nOrigDamage, int nDamageType, 
                      int nBoltVFX = VFX_BEAM_HOLY, int nVictimVFX = VFX_NONE,
                      int nSavingThrow = SAVING_THROW_REFLEX, int nSaveType = SAVING_THROW_TYPE_SPELL,
                      int bAllowSave = TRUE, int bSaveForHalf = TRUE
                     );


void DoChain(object oOrigin, int nOrigDamage, int nDamageType,
             int nBoltVFX, int nVictimVFX, int bExtraEffect, effect eExtra,  
             int bAllowSave, int bSaveForHalf, int nSavingThrow, int nSaveType, int bAllowSR = TRUE,
             object oCaster = OBJECT_SELF, int nManifesterLevel = -1, int nSpellID = -1, int nDC = -1,
             int nExtraDurationType = DURATION_TYPE_TEMPORARY, int nDamagePower = DAMAGE_POWER_NORMAL,
             float fExtraDuration = 0.0f
            )
{
	// Get manifester level if not given
	if(nManifesterLevel == -1) nManifesterLevel = GetManifesterLevel(oManifester);
	
	// Get the spell ID if it was not given.
	if(nSpellID == -1) nSpellID = GetSpellId();
	
	// Get the DC
	if(nDC == -1 && bAllowSave) nDC = GetManifesterDC(oCaster);
	
	
	int nTargets = 0;
	int nMaxTargets = nManifesterLevel > 20 ? 20 : nManifesterLevel;
	location lOrigin = GetLocation(oOrigin);
	effect eBolt = EffectBeam(nBoltVFX, oOrigin, BODY_NODE_CHEST);
	effect eVictim = EffectVisualEffect(nVictimVFX);
	
	
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, CHAIN_RADIUS, lOrigin, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget)/* && GetDistanceBetween(oOrigin, oTarget) <= CHAIN_RADIUS*/)
	{
		if(oTarget != oCaster &&
           oTarget != oOrigin &&
           spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
		{	
			AddToTargetList(oTarget, oCaster, INSERTION_BIAS_CR, TRUE);
		}// end if - target is valid for this
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, CHAIN_RADIUS, lOrigin, TRUE, OBJECT_TYPE_CREATURE);
	}// end while - loop through all potential targets
	
	
	oTarget = GetTargetListHead(oCaster);
	while(GetIsObjectValid(oTarget) && nTargets < nMaxTargets)
	{
		//Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
		
		// Mark one more target slot as used
		nTargets++;
		
		// Spell resistance
		if(!bAllowSR || PRCMyResistPower(OBJECT_SELF, oTarget, nManifesterLevel + PsiGetPenetr(), fDelay) == POWER_RESIST_FAIL)
		{
			// Damage from a chain is always half the main damage
			int nDamage = nOrigDamage / 2;
			int bNoEffect = FALSE;
			// Saving throw
			if(bAllowSave)
			{
				// Handle cases where the save halves the damage
				if(bSaveForHalf)
				{
					// Reflex saves need to be handled separately - Evasion
					if(nSavingThrow == SAVING_THROW_REFLEX)
						nDamage = PRCGetReflexAdjustedDamage(nOrigDamage, oTarget, nDC, nSaveType, oCaster);
					else
					{
						switch(PRCMySavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oCaster))
						{
							case 1:
								nDamage /= 2;
								break;
							case 2:
								bNoEffect = TRUE;
							default:
								break;
						}
					}
				}// end if - save was for half
				else
				{
					if(PRCMySavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oCaster))
						bNoEffect = TRUE;
				}// end else - save was for negation
			}// end if - saving throw is allowed
			
			if(!bNoEffect)
			{
				// Apply the damage
				effect eDamage = EffectDamage(nDamage, nDamageType, nDamagePower);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0, FALSE);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVictim, oTarget);
				if(bExtraEffect) SPApplyEffectToObject(nExtraDurationType, eExtra, oTarget, fExtraDuration, TRUE, nSpellID, nManifesterLevel, oCaster);
			}// end if - target isn't immune
		}// end if - target didn't resist
		
		oTarget = GetTargetListHead(oCaster);
	}
	
	PurgeTargetList(oCaster);
}


void DoChainShortWrap(object oOrigin, int nOrigDamage, int nDamageType, 
                      int nBoltVFX = VFX_BEAM_HOLY, int nVictimVFX = VFX_NONE,
                      int nSavingThrow = SAVING_THROW_REFLEX, int nSaveType = SAVING_THROW_TYPE_SPELL,
                      int bAllowSave = TRUE, int bSaveForHalf = TRUE
                     )
{
	DoChain(oOrigin, nOrigDamage, nDamageType,
	        nBoltVFX, nVictimVFX, FALSE, EffectVisualEffect(VFX_NONE),
	        bAllowSave, bSaveForHalf, nSavingThrow, nSaveType);
}