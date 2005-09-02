/*
   ----------------
   Ectoplasmic Cocoon
   
   prc_pow_ectococ
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 3
   Range: Medium
   Target: One Medium or smaller creature
   Duration: 1 Round/level
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 5
   
   You draw writhing strands of ectoplasm from the Astral Plane that wrap the subject up like a mummy. The subject can still
   breathe but is otherwise helpless. 
   
   Augment: For every 4 additional power points spent, this power can affect a creature one size larger and its DC increases by 1. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDur = nCaster;
	int nAllowedSize = CREATURE_SIZE_MEDIUM;
	int nSize = GetCreatureSize(oTarget);
	if (nMetaPsi == 2)	nDur *= 2;	
	
   			
	//Augmentation effects to Size
	if (nAugment > 0) 
	{
		nAllowedSize += nAugment;
		//Max size of creature
		if (nAllowedSize > 5) nAllowedSize = 5;
		nDC += nAugment;
	}
	
	effect ePara = EffectCutsceneParalyze();
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
	effect eVis = EffectVisualEffect(VFX_DUR_TENTACLE);
	effect eLink = EffectLinkEffects(ePara, eDur);
	

 	if(nSize <= nAllowedSize)
    	{
	 	//Fire cast spell at event for the specified target
         	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
	}
	

    }
}