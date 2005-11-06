/*
   ----------------
   Concussion Blast
   
   prc_all_concblst
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Medium
   Target: One Creature + Augmentation
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 3
   
   A subject you select is pummeled with telekinetic force for 1d6 of bludgeoning damage.
   
   Augment: For every 4 additional power points spent, this power's damage increases by 1d6,
   and affects another hostile creature within 15 feet of the first. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
	int nAugCost = 4;
	int nAugment = GetAugmentLevel(oCaster);
	int nSurge = GetLocalInt(oCaster, "WildSurge");
	object oFirstTarget = GetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);

	if (nSurge > 0)
	{
		PsychicEnervation(oCaster, nSurge);
	}

	if (nMetaPsi > 0)
	{
		int nDC = GetManifesterDC(oCaster);
		int nCaster = GetManifesterLevel(oCaster);
		int nPen = GetPsiPenetration(oCaster);
		effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
		int nTargetCount = 1;
		int nDice = 1;
		int nDiceSize = 6;

		if (nSurge > 0) nAugment += nSurge;

		//Augmentation effects to Damage
		if (nAugment > 0)
		{
			nDice += nAugment;
			nTargetCount += nAugment;
		}

		int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);

		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);

		SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oFirstTarget, nPen))
		{
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oFirstTarget);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
		}

		if (nTargetCount > 1)
		{

			location lTarget = GetSpellTargetLocation();
			int nTargetsLeft = nTargetCount - 1;
			//Declare the spell shape, size and the location.  Capture the first target object in the shape.
			object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

			//Cycle through the targets within the spell shape until you run out of targets.
			while (GetIsObjectValid(oAreaTarget) && nTargetsLeft > 0)
			{
				if (spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oAreaTarget != OBJECT_SELF)
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oAreaTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

					if (PRCMyResistPower(oCaster, oAreaTarget, nPen))
					{
						nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
						eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oAreaTarget);
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaTarget);
					}
					
					 // Use up a target slot only if we actually did something to it
					nTargetsLeft -= 1;
				}
				
				//Select the next target within the spell shape.
				oAreaTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
			}
		}
	}
}