/*
   ----------------
   Body Equilibrium
   
   prc_all_bdyequib
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 2, Psychic Warrior 2
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You adjust your bodies equilibrium to correspond with the surface you are walking on,
   making you able to move easily across unusual and unstable surfaces. This makes you
   immune to entangle.
   
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
       	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	
    	effect eEntangle = EffectImmunity(IMMUNITY_TYPE_ENTANGLE);
        effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eVis, eEntangle);
        eLink = EffectLinkEffects(eLink, eDur);
    	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (600.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}