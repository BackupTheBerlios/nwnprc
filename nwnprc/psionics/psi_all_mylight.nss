/*
   ----------------
   My Light
   
   prc_all_mylight
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   When you manifest this power, your body begins to glow with bright white light,
   allowing you to see clearly even in the night.
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
    
    if (GetCanManifest(oCaster, 0)) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	
        effect eVis = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (600.0 * nCaster),TRUE,-1,nCaster);
    }
}