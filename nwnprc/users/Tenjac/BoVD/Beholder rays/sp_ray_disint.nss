//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Disintegrate
//:: FileName  sp_ray_disint.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = 13;
	int nDC = 18;
	
	SPRaiseSpellCastAt(oTarget);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_DISINTEGRATE, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{	
		//SR
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			int nDamage = 9999;
			if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget,oPC), SAVING_THROW_TYPE_SPELL))
			{
				nDamage = SPGetMetaMagicDamage(DAMAGE_TYPE_MAGICAL, 1 == nTouchAttack ? 5 : 10, 6); 
			}
			else
			{
				// If FB passes saving throw it survives, else it dies
				DeathlessFrenzyCheck(oTarget);
			}
			
			// Apply damage effect and VFX impact, and if the target is dead then apply
			// the fancy rune circle too.
			if (nDamage >= GetCurrentHitPoints (oTarget)) 
			DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), oTarget));
			DelayCommand(0.25, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGBLUE), oTarget));
			
			ApplyTouchAttackDamage(oPC, oTarget, nTouch, nDamage, DAMAGE_TYPE_MAGICAL);	
		}
	}
}