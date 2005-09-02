/*
   ----------------
   Inflict Pain
   
   prc_all_inpain
   ----------------

   25/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Short
   Target: One Creature
   Duration: 1 Round/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 3
   
   You telepathically stab the mind of your foe, causing horrible agony. The subject
   suffers wracking pain that imposes a -4 on attack rolls and skill checks. If the target
   makes its save, the penalty is -2.
   
   Augment: For every 2 additional power points spent, this power's DC increases by 1,
   and affects another hostile creature within 15 feet of the first.    
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
	object oFirstTarget = PRCGetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

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
		int nDur = nCaster;
		if (nMetaPsi == 2)	nDur *= 2;

		effect eSkillFail = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);
		effect eAttackFail = EffectAttackDecrease(4);
		effect eSkillSucceed = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
		effect eAttackSucceed = EffectAttackDecrease(2);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		effect eDur2 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

		effect eLink = EffectLinkEffects(eSkillFail, eDur);
		eLink = EffectLinkEffects(eAttackFail, eLink);
		eLink = EffectLinkEffects(eDur2, eLink);

		effect eLink2 = EffectLinkEffects(eSkillSucceed, eDur);
		eLink2 = EffectLinkEffects(eAttackSucceed, eLink);
		eLink2 = EffectLinkEffects(eDur2, eLink);

		effect eVis = EffectVisualEffect(VFX_IMP_DOOM);

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
			//Make a saving throw check
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oFirstTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				//Apply VFX Impact and daze effect
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFirstTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
			}
			else
			{
				//Apply VFX Impact and daze effect
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oFirstTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);
			}
		}

		if (nTargetCount > 1)
		{

			location lTarget = PRCGetSpellTargetLocation();
			int nTargetsLeft = nTargetCount - 1;
			//Declare the spell shape, size and the location.  Capture the first target object in the shape.
			object oAreaTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

			//Cycle through the targets within the spell shape until you run out of targets.
			while (GetIsObjectValid(oAreaTarget) && nTargetsLeft > 0)
			{
				if (spellsIsTarget(oAreaTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
				    && oAreaTarget != OBJECT_SELF
				    && oAreaTarget != oFirstTarget // Do not affect the same creature twice
				   )
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oAreaTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

					//Check for Power Resistance
					if (PRCMyResistPower(oCaster, oAreaTarget, nPen))
					{
						//Make a saving throw check
						if(!PRCMySavingThrow(SAVING_THROW_WILL, oAreaTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
						{
							//Apply VFX Impact and daze effect
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oAreaTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
							SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAreaTarget);
						}
						else
						{
							//Apply VFX Impact and daze effect
							SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oAreaTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
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