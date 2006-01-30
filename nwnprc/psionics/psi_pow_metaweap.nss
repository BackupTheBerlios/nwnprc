/*
   ----------------
   Metaphysical Weapon
   
   psi_pow_metaweap
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
   
   If you have an equipped weapon, including ranged weapons, you can use this power to provide a +1 enhancement bonus to your attacks.
   In the case of ranged weapons with ammo, it affects the currently equipped stack of ammo.
   
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
    object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
    
    if (nMetaPsi > 0) 
    {
	int nCaster = GetManifesterLevel(oCaster);
	float fDur = 60.0 * nCaster;
	int nEnhance = 0;
	
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
	
	// Ammoed weapons
	if (BASE_ITEM_LONGBOW == GetBaseItemType(oItem) || BASE_ITEM_SHORTBOW == GetBaseItemType(oItem)) oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster);
	if (BASE_ITEM_HEAVYCROSSBOW == GetBaseItemType(oItem) || BASE_ITEM_LIGHTCROSSBOW == GetBaseItemType(oItem) ) oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster);
	if (BASE_ITEM_SLING == GetBaseItemType(oItem)) oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster);
	
	if (nAugment > 0) fDur = HoursToSeconds(nCaster);
	if (nMetaPsi == 2) fDur *= 2;
	
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	
	// Number of times the power has been augmented determines the enhancement bonus.
	if (nAugment >= 5) nEnhance = 5;
	else if (nAugment >= 4) nEnhance = 4;
	else if (nAugment >= 3) nEnhance = 3;
	else if (nAugment >= 2) nEnhance = 2;
	else nEnhance = 1;	
	
	// Pulsing effect on the target
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDur);
	
	// Enhancement bonus from Metaphsyical Weapon
	AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyEnhancementBonus(nEnhance),oItem, fDur);	
	
    }
}