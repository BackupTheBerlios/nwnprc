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

    Metaphysical weapon gives a weapon a +1 enhancement bonus on attack rolls
    and damage rolls.

    Alternatively, you can affect up to 99 arrows, bolts, or bullets. The
    projectiles must be of the same type, and they have to be together (in the
    same stack).

    You can’t manifest this power on most natural weapons, including a psychic
    warrior’s claw strike. This power does work on a weapon brought into being
    by the graft weapon power.

    Augment: If you spend 4 additional power points, this power’s duration
             increases to 1 hour per level.
             In addition, for every 4 additional power points you spend, this
             power improves the weapon’s enhancement bonus on attack rolls and
             damage rolls by 1.
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

        // Determine if we targeted a weapon or a creature
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            // It's a creature, target their primary weapon
            oTarget = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
        }
        // Make sure the target is either weapon or ammo
        if(!(GetWeaponRanged(oTarget) || IPGetIsMeleeWeapon(oTarget) ||
             GetBaseItemType(oTarget) == BASE_ITEM_ARROW ||
             GetBaseItemType(oTarget) == BASE_ITEM_BOLT  ||
             GetBaseItemType(oTarget) == BASE_ITEM_BULLET
           ) )
            oTarget = OBJECT_INVALID;

        // Make sure we have a valid target
        if(!GetIsObjectValid(oTarget))
        {
            // "Target is not a weapon!"
            FloatingTextStrRefOnCreature(16826667, oManifester, FALSE);
            return;
        }

        // Add the enhancement bonus
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oTarget, fDuration);

        // Do VFX
                          SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDur, oTarget, fDuration);
    }// end if - Successfull manifestation
}
