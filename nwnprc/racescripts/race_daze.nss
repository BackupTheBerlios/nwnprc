/*
    Racepack Daze
*/
#include "prc_alterations"

#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHYANKI) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHZERAI) { CasterLvl = 3; }    
    
    DoRacialSLA(SPELL_DAZE, CasterLvl);
}
