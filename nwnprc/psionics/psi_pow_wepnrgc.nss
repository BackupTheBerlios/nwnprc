/*
   ----------------
   Weapon of Energy, Cold
   
   psi_pow_wepnrgc
   ----------------

   5/11/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Caster
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You can use this power to provide your equipped weapon an extra 1d6 enhancement of cold,
   electricty, or fire to damage. This power does not stack with itself, and will fail if it is manifested while already in use.
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
    object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
    if (!GetIsObjectValid(oTarget))
    {
    	FloatingTextStringOnCreature("You do not have a valid target for Weapon of Energy", oCaster, FALSE);
    	return;
    }
    if (GetLocalInt(oCaster, "WeaponEnergy"))
    {
    	FloatingTextStringOnCreature("You already have Weapon of Energy manifested", oCaster, FALSE);
    	return;
    }    
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2) nDur *= 2;
	
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_COLD);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	itemproperty ipClaw = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6);
	AddItemProperty(DURATION_TYPE_TEMPORARY, ipClaw, oTarget, RoundsToSeconds(nDur));
	
	// Pulsing effect on the target
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, RoundsToSeconds(nDur));
	SetLocalInt(oCaster, "WeaponEnergy", TRUE);
	DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "WeaponEnergy"));	
    }
}