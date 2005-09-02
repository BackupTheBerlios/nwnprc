/*
   ----------------
   Energy Wall, Sonic
   
   prc_pow_enwalls
   ----------------

   26/3/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Medium
   Target: Self
   Duration: Instant
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   Upon manifesting this power, you create an immobile sheet of energy of the chosen type. All creatures within 10 feet of the wall
   take 2d6 damage, while those actually in the wall take 2d6 + 1 per manifester level, to a max of +20. This stacks with the extra
   damage provided by certain damage types.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget= OBJECT_SELF;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	location lTarget = PRCGetSpellTargetLocation();
    	effect eAOE = EffectAreaOfEffect(AOE_MOB_ENERGYWALL);
    	int nDuration = nCaster;
	if (nMetaPsi == 2)	nDuration *= 2;
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
       	SetLocalInt(oCaster, "PsiEnWall", 4);
	DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(oCaster, "PsiEnRetort"));
    }
}