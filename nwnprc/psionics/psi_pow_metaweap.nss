/*
   ----------------
   Metaphysical Weapon

   psi_pow_metaweap
   ----------------

   29/10/05 by Stratovarius
*/ /** @file

    Metaphysical Weapon

Metacreativity
Level: Psychic warrior 1
Manifesting Time: 1 standard action
Range: Touch
Target: Weapon touched
Duration: 1 min./level
Saving Throw: None
Power Resistance: No
Power Points: 1
Metapsionics: Extend

Metaphysical weapon gives a weapon a +1 enhancement bonus on attack rolls and damage rolls.

Alternatively, you can affect up to 99 arrows, bolts, or bullets. The projectiles must be of the same type, and they have to be together (in the same stack).

You can’t manifest this power on most natural weapons, including a psychic warrior’s claw strike. This power does work on a weapon brought into being by the graft weapon power.

Augment: If you spend 4 additional power points, this power’s duration increases to 1 hour per level.
In addition, for every 4 additional power points you spend, this power improves the weapon’s enhancement bonus on attack rolls and damage rolls by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
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

    object oManifester = OBJECT_SELF;
    object oTarget     = PRCGetSpellTargetObject();
    struct manifestation manif =
        EvaluateManifestation(oManifester, oTarget,
                              PowerAugmentationProfile(4,
                                                       4, PRC_UNLIMITED_AUGMENTATION
                                                       ),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nBonus           = 1 + manif.nTimesAugOptUsed_1;
        effect eDur          = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eVis          = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
        itemproperty ipBonus = ItemPropertyEnhancementBonus(nBonus);
        float fDuration      = (manif.nTimesAugOptUsed_1 == 0 ? 60.0f : HoursToSeconds(1)) * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Determine if we targeted a weapon
        //IPGetTargetedOrEquippedMeleeWeapon();
        // Add the enhancement bonus
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oTarget, fDuration);

        // Do VFX
                          SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}
/*
    object oCaster = OBJECT_SELF;
    object oTarget =
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
*/