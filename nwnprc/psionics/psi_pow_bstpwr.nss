/*
   ----------------
   Bestow Power
   
   prc_all_bstpwr
   ----------------

   22/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 2
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When you manifest this power, the subject gains up to 2 power points. You can transfer only
   as many power points to a subject as it has manifester levels.
   
   Augment: For every 3 additional power points spent, subject gains 2 additional power points.
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
    int nAugCost = 3;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nTargetSurge = GetLocalInt(oTarget, "WildSurge");
	int nTargetPP = GetLocalInt(oTarget, "PowerPoints");
	int nTarget = GetManifesterLevel(oTarget);
	int nPPGiven = 2;
	int nTotalPP;
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
	
	if (nSurge > 0) nAugment += nSurge;
	
	// Augmentation effects to point transfer
	if (nAugment > 0)	nPPGiven = nPPGiven + (2 * nAugment);
	
	// Make sure the target does not have a boosted caster level from Wild Surge
	if (nTargetSurge > 0)	nTarget = nTarget - nTargetSurge;
	
	// Can't give more power points than the target has manifester levels
	if (nPPGiven > nTarget) nPPGiven = nTarget;
	
	// Apply the PP Boost to target.
	nTotalPP = nPPGiven + nTargetPP;
	SetLocalInt(oTarget, "PowerPoints", nTotalPP);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nTotalPP), oTarget, FALSE);
    }
}