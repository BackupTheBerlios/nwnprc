//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_b
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_spell_const"

void main()
{
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(TN_DESECRATE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE) && bValid == FALSE)
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                    if(GetEffectSpellId(eAOE) == TN_DESECRATE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

}
