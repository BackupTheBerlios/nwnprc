/*
   ----------------
   Conceal Thought
   
   prc_all_cncltght
   ----------------

   6/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: 1 Hour/Level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You protect the subjects thoughts from analysis. While the duration lasts, the subject gains a +10 bonus
   to Bluff checks. 
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
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    int nAugCost = 0;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
    	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eBluff = EffectSkillIncrease(SKILL_BLUFF, 10);
    	effect eLink = EffectLinkEffects(eDur, eBluff);
    	int nDur = nCaster;
    	if (nMetaPsi == 2)	nDur *= 2;

	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
    }
}