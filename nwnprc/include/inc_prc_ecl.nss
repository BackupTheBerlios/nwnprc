#include "inc_utility"

//Use this to get the Effective Character Level
//of a creature, instead of depending on GetHitDice.
//ECL is HitDice + Level Adjustment (LA)
//This is used for PC XP/loot distribution and encounter
//difficulty only.
int GetECL(object oTarget);


int GetECL(object oTarget)
{
    int nECL;
    nECL = GetHitDice(oTarget);
    nECL += StringToInt(Get2DACache("ECL", "LA", GetRacialType(oTarget)));

    return nECL;
}
