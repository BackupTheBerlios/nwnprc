

#include "prc_alterations"
#include "spinc_common"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	SPRaiseSpellCastAt(oTarget,TRUE, INVOKE_DREAD_SEIZURE, oPC);
	
	//SR
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			effect eSlow = EffectMovementSpeedDecrease(50);
			effect eAttack = EffectAttackDecrease(5);
			effect eLink = EffectLinkEffects(eSlow, eAttack);
            effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5),TRUE,-1,nCasterLvl);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
}
	
			
				
		
	