/*
   ----------------
   Energy Push Sonic
   
   prc_all_enpushs
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
   doing 2d6-2 Sonic damage. On a successful Reflex safe, damage is cut in half. On
   a failed save, the target is knocked down.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d-+1, 
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
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	object oTarget = GetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
	effect eKnock = EffectKnockdown();
	int nDice = 2;
	int nDiceSize = 6;
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDC += nAugment;
	}
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
		if (nAugment > 0) nDice += nAugment;
		int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
                nDamage -= nDice;
                
	        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
	        {
		        nDamage /= 2;
		}
               	else
               	{
               		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0,TRUE,-1,nCaster);
               	}
               	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
	}
    }
}