/*
   ----------------
   Steadfast Perception
   
   prc_war_stdfstpr
   ----------------

   28/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 4
   
   Your vision cannot be distracted or mislead, granting you immunity to all figments and glamers,
   such as invisibility. Moreover, your Spot and Search skills gain +6 for the duration of the spell,
   as well as See Invisibility.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 3);

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
    	
    	effect eSpot = EffectSkillIncrease(SKILL_SPOT, 6);
    	effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 6);
	effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eSight = EffectSeeInvisible();
	effect eLink = EffectLinkEffects(eVis, eDur);
    	eLink = EffectLinkEffects(eLink, eSearch);
    	eLink = EffectLinkEffects(eLink, eSpot);
    	eLink = EffectLinkEffects(eLink, eSight);


	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, (600.0 * CasterLvl),TRUE,-1,CasterLvl);
    }
}