/*
   ----------------
   Disintegrate
   
   prc_all_disin
   ----------------

   27/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Long
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude partial
   Power Resistance: Yes
   Power Point Cost: 11
   
   A thin ray springs from your fingers at the target. You must succeed on a ranged touch attack
   to deal damage to the target. The ray deals 22d6 points of damage.
   
   Augment: For every additional power point spend, the target takes an additional
   2d6 points of damage if it fails its save.
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	nAugCost = 0;
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nDamage = d6(22);
	
	effect eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
		
	if (nSurge > 0) nAugment = nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDamage += d6((2 * nAugment));
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
			if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
			{
				nDamage = d6(5);
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
			}
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
		}
	}
	

    }
}