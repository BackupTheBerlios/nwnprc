/*
   ----------------
   Darkvision
   
   prc_all_darkvis
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: Psion/Wilder 3, Psychic Warrior 2
   Range: Personal
   Target: Caster
   Duration: 1 hour/level
   Saving Throw: None
   Power Resistance: None
   Power Point Cost: Psion/Wilder 5, Psychic Warrior 3
   
   You psionically enhance your eyes to gain the effects of darkvision.
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
	effect eUltra = EffectUltravision();
	effect eLink = EffectLinkEffects(eVis, eDur);
	eLink = EffectLinkEffects(eLink, eVis2);
    	eLink = EffectLinkEffects(eLink, eUltra);
    	int nDur = nCaster;
    	if (nMetaPsi == 2)	nDur *= 2;
    	
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);

    }
}