/*
   ----------------
   Touchsight
   
   prc_pow_tchsght
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: Psion/Wilder 3
   Range: Personal
   Target: Caster
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: 5
   
   You generate a subtle telekinetic field of mental contact, allowing you to "feel" your surroundings. You can spot creatures
   hidden, even by magical means. 
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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	
	effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eUltra = EffectTrueSeeing();
	effect eLink = EffectLinkEffects(eVis, eDur);
	eLink = EffectLinkEffects(eLink, eVis2);
    	eLink = EffectLinkEffects(eLink, eUltra);
    	float fDur = (nCaster * 60.0);
    	if (nMetaPsi == 2)	fDur *= 2;
    	
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);

    }
}