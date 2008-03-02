
#include "spinc_common"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    effect eSlow = EffectMovementSpeedDecrease(33);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
         if(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE)
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), INVOKE_CAUSTIC_MIRE));
            //Spell resistance check
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
            {
                //Slow down the creature within the mire
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            }
            
            SetLocalLocation(oTarget, "LastMirePos", GetLocation(oTarget));
        }
    }

}
