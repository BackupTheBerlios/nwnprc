/*
   ----------------
   Duodimensional Claw
   
   psi_pow_duoclaw
   ----------------

   5/11/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 3
   Range: Personal
   Target: Caster
   Duration: 10 Min/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 5
   
   If you have a claw attack, or a bite attack, you can use this power to provide a keen enhancement to your attack.
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
    	FloatingTextStringOnCreature("You do not have a valid target for Duodimensional Claw", oCaster, FALSE);
    	return;
    }
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = 600.0 * nCaster;
	if (nMetaPsi == 2) fDur *= 2;
	
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(), oTarget, fDur);
	
	// Pulsing effect on the target
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDur);
	
    }
}