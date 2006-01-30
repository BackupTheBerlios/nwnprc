/*
   ----------------
   Metaphysical Claw
   
   psi_pow_metaclaw
   ----------------

   29/10/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: Caster
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   If you have a claw attack, or a bite attack, you can use this power to provide a +1 enhancement bonus to your attacks.
   
   Augment: It costs 4 power points for each augmentation of this power. 
   If you augment the power once, the duration increases to 1 Hour/level
   If you augment the power twice, the enhancement bonus increases to +2. 
   If you augment the power three times, the enhancement bonus increases to +3. 
   If you augment the power four times, the enhancement bonus increases to +4. 
   If you augment the power five times, the enhancement bonus increases to +5.
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
    object oTarget = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster);
    if (!GetIsObjectValid(oTarget))
    {
    	FloatingTextStringOnCreature("You do not have a valid target for Metaphysical Claw", oCaster, FALSE);
    	return;
    }
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = 60.0 * nCaster;
	
	if (nAugment > 0) fDur = HoursToSeconds(nCaster);
	if (nMetaPsi == 2) fDur *= 2;
	
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	DoPsyWarUnarmed(oCaster, POWER_METAPHYSICAL_CLAW, nAugment, fDur);
	
	// Pulsing effect on the target
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDur);
	
    }
}