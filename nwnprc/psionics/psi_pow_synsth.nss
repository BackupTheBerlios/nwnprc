/*
   ----------------
   Synesthete
   
   prc_all_synsth
   ----------------

   1/11/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   Using this power lets you feel sound and light upon your face, giving you a +4 bonus to Search, Spot, and List,
   as well as making you immune to blindness and deafness.
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
    	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;     	
	
	//Massive effect linkage, go me
	effect eVis = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eSpot = EffectSkillIncrease(SKILL_SPOT, 4);
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 4);
	effect eListen = EffectSkillIncrease(SKILL_LISTEN, 4);
	effect eBlind = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
	effect eDeaf = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
	effect eLink = EffectLinkEffects(eVis, eDur);
	eLink = EffectLinkEffects(eLink, eVis2);
    	eLink = EffectLinkEffects(eLink, eSpot);
    	eLink = EffectLinkEffects(eLink, eSearch);
    	eLink = EffectLinkEffects(eLink, eListen);
    	eLink = EffectLinkEffects(eLink, eBlind);
    	eLink = EffectLinkEffects(eLink, eDeaf);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}