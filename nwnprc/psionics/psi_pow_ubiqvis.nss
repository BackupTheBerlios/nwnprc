/*
   ----------------
   Ubiquitous Vision
   
   prc_pow_ubiqvis
   ----------------

   25/3/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You have metaphoric "eyes in the back of your head", and on the sides and top as well, granting you benefits. These include
   rogues being unable to sneak you due to flanking, and a +4 bonus to spot and search.
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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;     	
	
	//Massive effect linkage, go me
	effect eVis2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eSpot = EffectSkillIncrease(SKILL_SPOT, 4);
	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 4);
	effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK)	;
	effect eLink = EffectLinkEffects(eVis2, eDur);
    	eLink = EffectLinkEffects(eLink, eSpot);
    	eLink = EffectLinkEffects(eLink, eSearch);
    	eLink = EffectLinkEffects(eLink, eSneak);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur,TRUE,-1,nCaster);
    }
}