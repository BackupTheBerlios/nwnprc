/*
   ----------------
   Empty Mind
   
   prc_all_emptymnd
   ----------------

   29/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You empty your mind of all transitory and distracting thoughts, gaining a +2 bonus to will saves.
   
   Augment: For every 2 additional power points you spend, the will save bonus improves by 1.
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
    int nAugCost = 2;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
    	int CasterLvl = GetManifesterLevel(oCaster);
    	int nBonus = 2;

    	if (nSurge > 0) nAugment += nSurge;
		
	// Augmentation effects to armour class
	if (nAugment > 0)	nBonus += nAugment;
	
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nBonus);
    	effect eLink = EffectLinkEffects(eSave, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(CasterLvl),TRUE,-1,CasterLvl);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    }
}