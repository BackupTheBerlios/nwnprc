/*
   ----------------
   Danger Sense
   
   prc_all_dngrsns
   ----------------

   12/12/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You can sense the prescence of danger before your senses would normally allow it. Your intuitive sense
   alerts you to danger from traps, granting a +4 bonus to reflex saves and armour class vs traps.
   
   Augment: For 3 additional power points spent, gain the +2 to each bonus.
   
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
    int nAugCost = 3;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);    
    
    if (nSurge > 0)
    {
       	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nBonus = 4;
    	int nDur = nCaster;
    	if (nMetaPsi == 2)	nDur *= 2;
    	
    	if (nSurge > 0) nAugment += nSurge;
    	
    	//Augmentation effects to Saves/AC
    	if (nAugment > 0) nBonus += (nAugment * 2);
    
    	effect eReflex = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nBonus, SAVING_THROW_TYPE_TRAP);
    	effect eAC = VersusTrapEffect(EffectACIncrease(nBonus));
        effect eVis = EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT);
    	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    	effect eLink = EffectLinkEffects(eVis, eReflex);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eAC);
    	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
    }
}