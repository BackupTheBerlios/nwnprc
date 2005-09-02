/*
   ----------------
   Burst
   
   prc_pow_burst
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad), Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, you gain a 50% increase to your speed. This is an instant power. 
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
    object oTarget = PRCGetSpellTargetObject();
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
        int nCaster = GetManifesterLevel(oCaster);
        effect eFast = EffectMovementSpeedIncrease(150);
	effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    	effect eLink = EffectLinkEffects(eFast, eVis);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1,nCaster);
    }
}