/*
    ----------------
    Psychic Crush
    
    psi_pow_psycrush
    ----------------

    23/2/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 5
    Range: Close
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will partial, see text.
    Power Resistance: Yes
    Power Point Cost: 9
 
    Your will abruptly and brutally crushes the essence of any one creature. The target must make a will save
    with a +4 bonus or be stunned for 1 round and reduced to 1 hit point. If the target makes the save, it takes
    3d6 points of damage.

    Augment: For every 2 additional power points spend, this power's damage on a made save increases by 1d6.
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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    
    if (nMetaPsi > 0) 
    {
	int nDC = (GetManifesterDC(oCaster) - 4);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nCrush = GetCurrentHitPoints(oTarget) - 1;
	int nDamage = d6(3);
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    	effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	
	//Augmentation effects to DC/Damage/Caster Level
	if (nAugment > 0)	nDamage += d6(nAugment);
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	effect eCrush = EffectDamage(nCrush, DAMAGE_TYPE_POSITIVE);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
	
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

               	if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
               	{
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCrush, oTarget);
               		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1),TRUE,-1,nCaster);
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               	}
               	else 
               	{
               		//Apply the VFX impact and effects
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
               	}
	}
    }
}