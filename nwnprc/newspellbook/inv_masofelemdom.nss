/*
    Warlock epic feat
    Master of the Elements dominating
*/
#include "prc_inc_racial"

#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    object oTarget = PRCGetSpellTargetObject();
    int nRacialType = MyPRCGetRacialType(oTarget);

    if(nRacialType != RACIAL_TYPE_ELEMENTAL)
        return;
    
    DoRacialSLA(SPELL_DOMINATE_MONSTER, CasterLvl);
}
