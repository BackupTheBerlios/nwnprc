/*
    race Entangle
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PIXIE) { CasterLvl = 8; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { CasterLvl = 3; }
    //NWN2
    //else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { CasterLvl = 3; }

    DoRacialSLA(SPELL_ENTANGLE, CasterLvl);
}

