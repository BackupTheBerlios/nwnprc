/*
   ----------------
   Mind Trap
   
   prc_pow_mindtrap
   ----------------

   17/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   You set up a trap in your mind against psionic intruders. Anyone who attacks you with a telepathy power immediately loses
   1d6 power points. This does not negate the power being cast.
   
   Augment: For every additional power point spent, the duration increases by 1 round.
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
	SetLocalInt(oTarget, "MindTrap", TRUE);
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	
	if (nSurge > 0) nAugment += nSurge;
			
	// Augmentation effects to armour class
	if (nAugment > 0)	nDur += nAugment;
	if (nMetaPsi == 2)	nDur *= 2;  
	DelayCommand(RoundsToSeconds(nDur), SetLocalInt(oTarget, "MindTrap", FALSE));
    }
}