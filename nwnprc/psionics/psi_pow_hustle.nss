/*
   ----------------
   Hustle
   
   prc_pow_hustle
   ----------------

   26/3/05 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: Psion 3, Psychic Warrior 2
   Range: Personal
   Target: Self
   Duration: 1 Round
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: Psion 5, PW 3
   
   When you manifest this power, you gain all the benefits of haste for one round. This is an instant power. 
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
        int nCaster = GetManifesterLevel(oCaster);
        effect eHaste = EffectHaste();
	effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
    	effect eLink = EffectLinkEffects(eHaste, eVis);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1,nCaster);
    }
}