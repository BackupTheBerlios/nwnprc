/*
   ----------------
   Ectoplasmic Cocoon, Mass
   
   prc_pow_ectococm
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 7
   Range: Medium
   Target: 20' Burst
   Duration: 1 Hour/level
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 13
   
   You draw writhing strands of ectoplasm from the Astral Plane that wrap the subjects up like a mummy. The subjects can still
   breathe but are otherwise helpless. 
   
   Augment: For every 2 additional power points spent, this power's radius increases by 5 feet.
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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, METAPSIONIC_WIDEN);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;	
	float fSize = RADIUS_SIZE_LARGE;
	location lTarget = PRCGetSpellTargetLocation();
	
   			
	//Augmentation effects to Size
	if (nAugment > 0) 
	{
		//Max size of creature
		fSize += (1.5 * nAugment);
	}
	
	float fWidth = DoWiden(RADIUS_SIZE_SMALL, nMetaPsi);
	effect ePara = EffectCutsceneParalyze();
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
	effect eVis = EffectVisualEffect(VFX_DUR_TENTACLE);
	effect eLink = EffectLinkEffects(ePara, eDur);
	

	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }		
	//Select the next target within the spell shape.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	

    }
}