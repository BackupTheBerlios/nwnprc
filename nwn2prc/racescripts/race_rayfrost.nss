/*
    Racepack Ray of Frost
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ICE_GNOME) { CasterLvl = 1; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ULDRA) { CasterLvl = GetHitDice(OBJECT_SELF); }

    DoRacialSLA(SPELL_RAY_OF_FROST, CasterLvl);
}
