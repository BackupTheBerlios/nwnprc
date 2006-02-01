/*
   ----------------
   Control Object

   prc_pow_ctrlobj
   ----------------

   31/7/05 by Stratovarius
*/ /** @file

    Control Object

    Psychokinesis
    Level: Kineticist 1
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Target: One unattended object
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: No
    Power Points: 1
    Metapsionics: Extend

    You telekinetically “bring to life” an inanimate object. Though it is not
    actually alive, the object moves under your control. If it is a weapon, it
    deals the weapons damage plus your Intelligence modifier, otherwise it deals
    1d6 plus your intelligence modifier. This power only works on weapons and
    armour.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"

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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        float fDelay    = 3.0f;
        float fDuration = 6.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        MultisummonPreSummon();
        effect eSummon = EffectSummonCreature("psi_ctrlobj", VFX_FNF_SUMMON_CELESTIAL, 0.0f);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);

        int i = 1;
        object oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oManifester, i);

        while (GetIsObjectValid(oHench))
        {
            if (GetResRef(oHench) == "psi_ctrlobj")
            {
                break;
            }
            i += 1;
            oHench = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oManifester, i);
        }

        if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
        {
            CopyItem(oTarget, oHench, FALSE);
            DestroyObject(oTarget);
        }
        int nWeap = GetWeaponDamageType(oTarget);
        if (nWeap != -1)
        {
            ForceEquip(oHench, oTarget, INVENTORY_SLOT_RIGHTHAND);
        }
        else
        {
            ForceEquip(oHench, oTarget, INVENTORY_SLOT_CHEST);
        }

        int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oManifester);
        // Work around for the damage bonus
        string sDam = "DAMAGE_BONUS_" + IntToString(nInt);
        FloatingTextStringOnCreature("Your Damage Bonus is " + sDam, oManifester, FALSE);

        effect eAttack = EffectAttackIncrease(nInt);
        effect eDam = EffectDamageIncrease(StringToInt(sDam), DAMAGE_TYPE_BASE_WEAPON);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttack, oHench);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oHench);
    }// end if - Successfull manifestation
}
