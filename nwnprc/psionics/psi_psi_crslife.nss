/*
    ----------------
    Crisis of Life
    
    psi_psi_crslife
    ----------------

    21/10/04 by Stratovarius

    Class: Psion (Telepath)
    Power Level: 7
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude partial, see text.
    Power Resistance: Yes
    Power Point Cost: 13
 
    You interrupt the target's autonomic heart rhythm, killing it instantly on a 
    failed saving throw if it has 11 Hit Dice or less. If the target makes its 
    saving throw or has greater than 11 Hit Dice, it takes 7d6 damage.

    Augment: For every additional power point spend, this power can kill
    a subject that has Hit Dice equal to 11 + the number of additional points spent. 
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    int nAugment = GetLocalInt(oCaster, "Augment");
    object oTarget = GetSpellTargetObject();
    
    if (GetCanManifest(oCaster, nAugCost, oTarget)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nDamage = d6(7);
	int nHD = 11;
	int nTargetHD = GetHitDice(oTarget);
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    	effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	
	//FloatingTextStringOnCreature("Target's Hit Dice: " + IntToString(nTargetHD), oCaster, FALSE);
	
	//Augmentation effects to DC/Damage/Caster Level
	if (nAugment > 0)	nHD += nAugment;
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nCaster))
	{
	
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                //Make a saving throw check
                if(nHD >= nTargetHD)
                {
                	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                	{
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                	}
                	else 
                	{
                		//Apply the VFX impact and effects
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                	}
                }
                else
                {
                	//Apply the VFX impact and effects
                	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
	}
    }
}