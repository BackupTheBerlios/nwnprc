/*
   ----------------
   Fuse Flesh
   
   prc_pow_fuseflsh
   ----------------

   24/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Touch
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Fortitude Negates, Fortitude Partial
   Power Resistance: Yes
   Power Point Cost: 11
   
   You cause the victims flesh to ripple, grow together, and fuse into a nearly seamless whole, paralyzing the creature. If the target fails its
   saving throw, it must attempt another fortitude save or be blinded and deafened for the duration of the power.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1.
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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);  
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDur = nCaster;
	effect eParal = EffectParalyze();
	effect eVis = EffectVisualEffect(82);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
	
	effect eLink = EffectLinkEffects(eDur2, eDur);
	eLink = EffectLinkEffects(eLink, eParal);
	eLink = EffectLinkEffects(eLink, eVis);
    	eLink = EffectLinkEffects(eLink, eDur3);
    	
        effect eBlind =  EffectBlindness();
	effect eDeaf = EffectDeaf();
	effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	
	effect eLink2 = EffectLinkEffects(eBlind, eDeaf);
    	eLink2 = EffectLinkEffects(eLink, eVis2);
			
	//Augmentation effects to Damage
	if (nAugment > 0) nDC += nAugment;
	if (nMetaPsi == 2)	nDur *= 2;   
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
	       	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	      	{
	       		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	       	
	       		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
		      	{
		       		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
               		}
               	}
	}
    }
}