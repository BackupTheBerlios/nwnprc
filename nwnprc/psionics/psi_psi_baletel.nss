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
    int nAugment = GetLocalInt(oCaster, "Augment");
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nDamage = d6(9);
	
	//Augmentation effects to DC/Damage/Caster Level
	if (nAugment > 0)
	{
		nDC = nDC + (nAugment/2);
		nCaster = nCaster + (nAugment/2);
		nDamage = nDamage + d6(nAugment);
	}
	
	//FloatingTextStringOnCreature("Augmented DC " + IntToString(nDC), oCaster, FALSE);
	//FloatingTextStringOnCreature("Augmented Manifester Level " + IntToString(nCaster), oCaster, FALSE);
	//FloatingTextStringOnCreature("Augmented Damage " + IntToString(nDamage), oCaster, FALSE);
	
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	effect eRay;
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nCaster))
	{
	
	//FloatingTextStringOnCreature("Target has failed its Power Resistance Check", oCaster, FALSE);
		
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
            eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);

                //Make a saving throw check
                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                }
                //Apply the VFX impact and effects
                DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}
    }
}