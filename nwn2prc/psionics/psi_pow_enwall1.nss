/*
   ----------------
   Energy Wall, OnEnter

   psi_pow_enwall1
   ----------------

   26/3/05 by Stratovarius
*/ /** @file

    Energy Wall, OnEnter

    Metacreativity (Creation) [see text]
    Level: Psion/wilder 3
    Manifesting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./ level)
    Area: An opaque sheet of energy 10m long and 2m wide
    Duration: 1d4 rounds + 1 round/level
    Saving Throw: Reflex half or Fortitude half; see text
    Power Resistance: No
    Power Points: 5
    Metapsionics: Extend, Empower, Maximize, Twin, Widen

    Upon manifesting this power, you choose cold, electricity, fire, or sonic.
    You create an immobile sheet of energy of the chosen type formed out of
    unstable ectoplasm. The wall sends forth waves of energy, dealing 2d6 points
    of damage to creatures entering the wall. In addition, anyone that remains
    within the energy wall takes 2d6 points of damage +1 point per manifester
    level (maximum +20).

    If you manifest the wall so that it appears where creatures are, each
    creature takes damage as if passing through the wall.

    Cold: A sheet of this energy type deals +1 point of damage per die. The
          saving throw to reduce damage from a cold wall is a Fortitude save
          instead of a Reflex save.
    Electricity: Manifesting a sheet of this energy type provides a +2 bonus to
                 the save DC.
    Fire: A sheet of this energy type deals +1 point of damage per die.
    Sonic: A sheet of this energy type deals -1 point of damage per die
           and ignores an object�s hardness.

    This power�s subtype is the same as the type of energy you manifest.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "spinc_common"
#include "psi_inc_enrgypow"

void main()
{
    object oAoE    = OBJECT_SELF;
    object oTarget = GetEnteringObject();
    struct manifestation manif      = GetLocalManifestation(oAoE, "PRC_Power_EnergyWall_Manifestation");
    struct energy_adjustments enAdj =
        EvaluateEnergy(manif.nSpellID, POWER_ENERGYWALL_COLD, POWER_ENERGYWALL_ELEC, POWER_ENERGYWALL_FIRE, POWER_ENERGYWALL_SONIC);
    int nDC                         = GetLocalInt(oAoE, "PRC_Power_EnergyWall_DC") + enAdj.nDCMod;
    int nNumberOfDice               = 2;
    int nDieSize                    = 6;
    int nDamage;
    effect eVis                     = EffectVisualEffect(enAdj.nVFX1);
    effect eDamage;

    // Let the AI know
    SPRaiseSpellCastAt(oTarget, TRUE, manif.nSpellID, manif.oManifester);

    // Roll damage
    nDamage = MetaPsionicsDamage(manif, nDieSize, nNumberOfDice, 0, enAdj.nBonusPerDie, TRUE, FALSE);
    // Target-specific stuff
    nDamage = GetTargetSpecificChangesToDamage(oTarget, manif.oManifester, nDamage, TRUE, TRUE);

    // Do save
    if(enAdj.nSaveType == SAVING_THROW_TYPE_COLD)
    {
        // Cold has a fort save for half
        if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, enAdj.nSaveType))
        {
		if (GetHasMettle(oTarget, SAVING_THROW_FORT))
		// This script does nothing if it has Mettle, bail
			nDamage = 0;          
            nDamage /= 2;
        }
    }
    else
        // Adjust damage according to Reflex Save, Evasion or Improved Evasion
        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, enAdj.nSaveType);

    // Apply VFX and damage the target, assuming there is still damage left to deal after modification
    if(nDamage > 0)
    {
        eDamage = EffectDamage(nDamage, enAdj.nDamageType);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}