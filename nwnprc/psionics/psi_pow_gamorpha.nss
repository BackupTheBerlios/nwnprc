/*
   ----------------
   Greater Concealing Amorpha
   
   prc_all_gamorpha
   ----------------

   22/10/04 by Stratovarius

   Class: Psion (Shaper), Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   When you manifest this power, you weave a quasi-real membrane around yourself. 
   This distortion grants you 50% concealment.
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
    	int CasterLvl = GetManifesterLevel(oCaster);
    	effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
	effect eConceal = EffectConcealment(50);
	effect eDur = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
	effect eLink = EffectLinkEffects(eDur, eConceal);
	
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(CasterLvl),TRUE,-1,CasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}