//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Finger of Death
//:: FileName  sp_ray_fingdth.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = 13;
	int nDC = 18;
	float fDur = RoundsToSeconds(nCasterLvl);
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
	effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		
	SPRaiseSpellCastAt(oTarget);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{
		if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
		{
			//SR
			if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
			{
				if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC))
				{
					DeathlessFrenzyCheck(oTarget);
					
					//Apply the death effect and VFX impact
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
				}
				
				else
				{
					// Target shouldn't take damage if they are immune to death magic.
					if (!GetIsImmune( oTarget, IMMUNITY_TYPE_DEATH))
					{
						//Roll damage
						nDamage = d6(3) + nCasterLvl;
						//Make metamagic checks
						if ((nMetaMagic & METAMAGIC_MAXIMIZE))
						{
							nDamage = 18 + nCasterLvl;
						}
						if ((nMetaMagic & METAMAGIC_EMPOWER))
						{
							nDamage = nDamage + (nDamage/2);
						}
						nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
						//Set damage effect
						
						eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
						//Apply damage effect and VFX impact
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
						SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
					}
				}
			}
		}
	}
}