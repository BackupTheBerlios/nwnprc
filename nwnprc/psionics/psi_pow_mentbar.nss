/*
   ----------------
   Mental Barrier
   
   prc_pow_mentbar
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   Your mind generates a tangible field of force that provides a +4 bonus to AC.
   This is a deflection bonus.
   
   Augment: For every 4 additional power points you spend, the AC bonus improves by 1 and the duration increases by 4 rounds.
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
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nAC = 4;    	
	int nDur = nCaster;
	

    	if (nSurge > 0) nAugment += nSurge;
		
	// Augmentation effects to armour class
	if (nAugment > 0)	
	{
		nAC += nAugment;
		nDur += (nAugment * 4);
	}
	
	if (nMetaPsi == 2)	nDur *= 2;    	
	
	effect eArmor = EffectACIncrease(nAC, AC_DEFLECTION_BONUS);
	effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
	effect eLink = EffectLinkEffects(eArmor, eDur);

	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
    }
}