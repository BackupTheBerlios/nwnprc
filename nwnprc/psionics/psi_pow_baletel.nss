/*
    ----------------
    Baleful Teleport
    
    psi_psi_baletel
    ----------------

    21/10/04 by Stratovarius

    Class: Psion (Nomad)
    Power Level: 5
    Range: Short
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude half
    Power Resistance: Yes
    Power Point Cost: 9
 
    You psychoportively disperse miniscule portions of the target, dealing 9d6 points of damage.

    Augment: For every additional power point spend, this power's damage increases by 1d6. 
    For each extra 2d6 points of damage, this power's save DC increases by 1, 
    and your manifester level increases by 1.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

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
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);

    if (nMetaPsi > 0)
    {
        int nDC = GetManifesterDC(oCaster);
        int nCaster = GetManifesterLevel(oCaster);
        int nPen = GetPsiPenetration(oCaster);

        int nDice = 9;
        int nDiceSize = 6;

        //Augmentation effects to DC/Damage/Caster Level
        if (nAugment > 0)
        {
            nDC += (nAugment/2);
            nPen += (nAugment/2);
            nDice += nAugment;
        }

        int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);

        effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);

        //Check for Power Resistance
        if (PRCMyResistPower(oCaster, oTarget, nPen))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, POWER_BALEFULTEL));
        
            //Make a saving throw check
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
            {
                nDamage /= 2;
            }
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
            //Apply the VFX impact and effects
            DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
}
