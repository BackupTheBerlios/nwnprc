//::///////////////////////////////////////////////
//:: Name      Eye of the Beholder: Sleep
//:: FileName  sp_ray_sleep.nss
//:://////////////////////////////////////////////

#include "spinc_common"


void main()
{
	//Declare major variables
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	effect eSleep =  EffectSleep();
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
	effect eLink = EffectLinkEffects(eSleep, eMind);
	eLink = EffectLinkEffects(eLink, eDur);
	int CasterLvl = 13;
	int nDuration = CasterLvl + 3;
	int nDC = 18;
	
	//Make touch attack
	int nTouch = PRCDoRangedTouchAttack(oTarget);
	
	//Beam VFX.  Ornedan is my hero.
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_MIND, oPC, BODY_NODE_HAND, !nTouch), oTarget, 1.0f); 
	
	if (nTouch)
	{		
		//Make SR check
		if (!MyPRCResistSpell(oPC, oTarget ,nPenetr))
		{			
			//Make Fort save
			if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{				
				if((!GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP) && GetHitDice(oTarget) < 5)
				{
					effect eLink2 = EffectLinkEffects(eLink, eVis);
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
				}				
			}
		}
	}
}