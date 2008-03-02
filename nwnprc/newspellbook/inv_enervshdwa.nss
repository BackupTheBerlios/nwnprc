

#include "spinc_common"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    
    //Declare major variables
    object oTarget = GetEnteringObject();
    int CasterLvl = GetInvokerLevel(GetAreaOfEffectCreator(), GetInvokingClass());
    int nDC = SPGetSpellSaveDC(oTarget, GetAreaOfEffectCreator());
    effect eConceal = EffectConcealment(20);
    effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);

    if(oTarget == GetAreaOfEffectCreator())
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eConceal, oTarget, RoundsToSeconds(5),TRUE,-1,CasterLvl);

    else if(!GetLocalInt(oTarget, "EnervatingShadowLock"))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), INVOKE_ENERVATING_SHADOW, FALSE));
        
        //SR
    	if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget, SPGetPenetrAOE(GetAreaOfEffectCreator())))
    	{
    		//save
    		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
    		{
                //Apply VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStrength, oTarget, RoundsToSeconds(5),TRUE,-1,CasterLvl);
                SetLocalInt(oTarget, "EnervatingShadowLock", TRUE);
                DelayCommand(HoursToSeconds(24), DeleteLocalInt(oTarget, "EnervatingShadowLock"));
            }
        }
    }
}
