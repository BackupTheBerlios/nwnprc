/*
   ----------------
   Insanity
   
   prc_pow_insane
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: Medium
   Target: One Humanoid
   Duration: Permanent
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 13
   
   Creatures affected by this power are permanently confused, as the spell.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1,
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
	int nAugCost = 2;
	int nAugment = GetAugmentLevel(oCaster);
	int nSurge = GetLocalInt(oCaster, "WildSurge");
	object oFirstTarget = GetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);

	if (nSurge > 0)
	{
		PsychicEnervation(oCaster, nSurge);
	}

	if (nMetaPsi > 0)
	{
		int nDC = GetManifesterDC(oCaster);
		int nCaster = GetManifesterLevel(oCaster);
		int nPen = GetPsiPenetration(oCaster);
		int nTargetCount = 1;
		effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
		effect eConfuse = EffectConfused();
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		effect eLink = EffectLinkEffects(eMind, eConfuse);
    		eLink = EffectLinkEffects(eLink, eDur);
    		eLink = SupernaturalEffect(eLink);

		if (nSurge > 0) nAugment += nSurge;

		//Augmentation effects to Damage
		if (nAugment > 0)
		{
			nDC += nAugment;
			nTargetCount += nAugment;
		}

		SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oFirstTarget, nPen))
		{
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oFirstTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oFirstTarget);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
			}
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
						if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
						{
							SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oAreaTarget);
							SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaTarget);
						}
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