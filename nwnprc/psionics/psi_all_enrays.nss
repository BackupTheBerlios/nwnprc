/*
   ----------------
   Energy Ray Sonic
   
   prc_all_enrays
   ----------------

   30/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 1d6-1 sonic damage on a successful ranged touch attack.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6-1. 
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
	int nDamage = (d6(1) - 1);
	if (nDamage == 0) nDamage = 1;
	
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
		
	if (nSurge > 0) nAugment = nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDamage += (d6(nAugment) - nAugment);
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
		}
	}
	

    }
}