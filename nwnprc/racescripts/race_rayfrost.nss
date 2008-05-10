/*
    Racepack Ray of Frost
*/
#include "prc_alterations"

void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ICE_GNOME) { CasterLvl = 1; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ULDRA) { CasterLvl = GetHitDice(OBJECT_SELF); }

    DoRacialSLA(SPELL_RAY_OF_FROST, CasterLvl);
}
