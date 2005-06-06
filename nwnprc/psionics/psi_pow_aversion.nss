/*
   ----------------
   Aversion
   
   prc_all_daze
   ----------------

   19/4/05 by Stratovarius

   Class: Psion (Telepath)
   Power Level: 2
   Range: Close
   Target: One Creature
   Duration: 1 Hour/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You plant a powerful aversion in the mind of the subject. The target flees from you at every opportunity.
   
   Augment: For every 2 additional power points spent, this power's save DC increases by 1 and the duration by 1 hour.
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
    object oTarget = GetSpellTargetObject();
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
   
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectFrightened();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);
    	effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    	int nDur = 2;
    			
	//Augmentation effects to HD
	if (nAugment > 0) 
	{
		nDC += nAugment;
		nDur += nAugment;
	}
	
	if (nMetaPsi > 0)	nDur *= 2;
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
			
	    //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
            //Make a saving throw check
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
	        //Apply VFX Impact and daze effect
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	    }
	}
    }
}