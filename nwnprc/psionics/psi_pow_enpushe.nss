/*
   ----------------
   Energy Push Electricity
   
   prc_all_enpushe
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 3
   
   You create a ray of energy of the chosen type that shoots forth from your finger tips,
   doing 2d6 electricity damage. On a successful Reflex safe, damage is cut in half. On
   a failed save, the target is knocked down. Electricity increases DC and Spell Penetration by +2.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6, 
   and the DC increases by 1. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!PsiPrePowerCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = (GetManifesterDC(oCaster) + 2);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nDamage = d6(2);
	effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
	effect eRay = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
	effect eKnock = EffectKnockdown();
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDamage += (d6(nAugment) + nAugment);
		nDC += nAugment;
	}
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, (nCaster + 2)))
	{
	        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY))
	        {
		        nDamage /= 2;
		        eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
               	}
               	else
               	{
               		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0,TRUE,-1,nCaster);
               	}
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
	}
    }
}