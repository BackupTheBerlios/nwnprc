/*
   ----------------
   Bite of the Wolf

   psi_pow_bitewolf
   ----------------

   29/10/05 by Stratovarius
*/ /** @file

    Bite of the Wolf

    Psychometabolism
    Level: Psychic warrior 1
    Manifesting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 1 min./level
    Power Points: 1
    Metapsioncs: Extend

    Your posture becomes stooped forward, and you grow a muzzle complete with
    fangs. You gain a bite attack, that deals 1d8 points of damage (assuming you
    are a Medium creature) when it hits.

    Your bite attack is a natural weapon, so you are considered armed when
    attacking with it, and it can be affected by powers, spells, and effects
    that enhance or improve natural weapons.

    If you are not a Medium creature, your bite attack’s base damage varies as
    follows: Fine 1d2, Diminutive 1d3, Tiny 1d4, Small 1d6, Large 2d6, Huge 2d8,
    Gargantuan 4d6, Colossal 6d6.

    Based on your psychic warrior level, your bite increases in ferocity as
    noted here: at 5th level your bite deals an extra 1d8 points of damage,
    at 10th level an extra 2d8, at 15th level an extra 3d8,
    and at 20th level an extra 4d8 points.


    @todo Invent a trick to make this dispellable
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
                              PowerAugmentationProfile(),
                              METAPSIONIC_EXTEND
                              );

    if(manif.bCanManifest)
    {
        int nEffectivePsyWarLevel = GetLevelByClass(CLASS_TYPE_PSYWAR, oManifester)
                                  + GetLevelByClass(CLASS_TYPE_FIST_OF_ZUOKEN, oManifester)
                                  + GetLevelByClass(CLASS_TYPE_WARMIND, oManifester);
        int nBonusDamage;
        int nBaseDamage;
        effect eVis               = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
        effect eDur               = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        object oCWeapon;
        float fDuration           = 60.0f * manif.nManifesterLevel;
        if(manif.bExtend) fDuration *= 2;

        // Determine base damage
        switch(PRCGetCreatureSize(oTarget))
        {
            case CREATURE_SIZE_FINE:       nBaseDamage = IP_CONST_MONSTERDAMAGE_1d2; break;
            case CREATURE_SIZE_DIMINUTIVE: nBaseDamage = IP_CONST_MONSTERDAMAGE_1d3; break;
            case CREATURE_SIZE_TINY:       nBaseDamage = IP_CONST_MONSTERDAMAGE_1d4; break;
            case CREATURE_SIZE_SMALL:      nBaseDamage = IP_CONST_MONSTERDAMAGE_1d6; break;
            case CREATURE_SIZE_MEDIUM:     nBaseDamage = IP_CONST_MONSTERDAMAGE_1d8; break;
            case CREATURE_SIZE_LARGE:      nBaseDamage = IP_CONST_MONSTERDAMAGE_2d6; break;
            case CREATURE_SIZE_HUGE:       nBaseDamage = IP_CONST_MONSTERDAMAGE_2d8; break;
            case CREATURE_SIZE_GARGANTUAN: nBaseDamage = IP_CONST_MONSTERDAMAGE_4d6; break;
            case CREATURE_SIZE_COLOSSAL:   nBaseDamage = IP_CONST_MONSTERDAMAGE_6d6; break;

            default:{
                string sErr = "psi_pow_bitewolf: ERROR: Unknown creature size (" + IntToString(PRCGetCreatureSize(oTarget)) + ") on creature " + DebugObject2Str(oTarget);
                if(DEBUG) DoDebug(sErr);
                else      WriteTimestampedLogEntry(sErr);
            }
        }

        // Determine bonus damage from Psychic Warrior levels
        if     (nEffectivePsyWarLevel >= 20) nBonusDamage = IP_CONST_DAMAGEBONUS_4d8;
        else if(nEffectivePsyWarLevel >= 15) nBonusDamage = IP_CONST_DAMAGEBONUS_3d8;
        else if(nEffectivePsyWarLevel >= 10) nBonusDamage = IP_CONST_DAMAGEBONUS_2d8;
        else if(nEffectivePsyWarLevel >= 5)  nBonusDamage = IP_CONST_DAMAGEBONUS_1d8;

        // Create the creature weapon
        oCWeapon = GetPsionicCreatureWeapon(oTarget, "PRC_UNARMED_S", INVENTORY_SLOT_CWEAPON_B, fDuration);

        // Add the base damage
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMonsterDamage(nBaseDamage), oCWeapon, fDuration);

        // Add the bonus damage
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, nBonusDamage), oCWeapon, fDuration);

        // Do VFX
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration, FALSE);
    }// end if - Successfull manifestation
}
