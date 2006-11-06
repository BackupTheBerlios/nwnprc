/*
    Racepack Fear
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { CasterLvl = 3; }

    DoRacialSLA(SPELL_FEAR, CasterLvl);
}

