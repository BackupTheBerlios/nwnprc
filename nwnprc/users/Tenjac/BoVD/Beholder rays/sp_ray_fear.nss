//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Fear
//:: FileName  sp_ray_fear.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = 13;
	int nDC = 18;
	effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
	effect eFear = EffectFrightened();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eFear, eMind);
	eLink = EffectLinkEffects(eLink, eDur);
	int nPenetr = CasterLvl + SPGetPenetr();
	
	SPRaiseSpellCastAt(oTarget);
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_ODD, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{	
		//SR
		if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Make a will save
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);
			}
		}
	}
}
			