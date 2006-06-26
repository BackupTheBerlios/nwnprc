//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Slow
//:: FileName  sp_ray_slow.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = 13;
	int nDC = 18;
	float fDur = RoundsToSeconds(nCasterLvl);
	
	SPRaiseSpellCastAt(oTarget);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{	
		//SR
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (nDC))
			{
				effect eSlow = EffectSlow();
				effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				effect eLink = EffectLinkEffects(eSlow, eDur);
				effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
				
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
	}
}