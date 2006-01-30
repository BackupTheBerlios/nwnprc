/*
   ----------------
   Dispelling Buffer
   
   prc_pow_displbuf
   ----------------

   15/8/05 by Stratovarius

   Class: Psion (Kineticist), Psychic Warrior
   Power Level: 6
   Range: Close
   Target: One Creature
   Duration: 1 Hour/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 11
   
   You create a psychokinetic shield around the subject that improves the chance that any powers affecting the subject will resist a 
   dispelling attempt. When dispelling buffer is manifested on a creature, add +5 to the DC of the dispel check for each effect on the
   subject.
   
   Special: A Psychic Warrior may only cast this power on himself.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;
	
	SetLocalInt(oTarget, "DispellingBuffer", TRUE);
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
	DelayCommand(HoursToSeconds(nDur), DeleteLocalInt(oTarget, "DispellingBugger"));
    }
}