/*
    Racepack Chill Touch
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "prc_racial_const"
#include "prc_spell_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_MORTIF) { CasterLvl = (GetHitDice(OBJECT_SELF))+2; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FROST_DWARF) { CasterLvl = GetHitDice(OBJECT_SELF); }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ZAKYA_RAKSHASA) { CasterLvl = 7; }

    DoRacialSLA(SPELL_CHILL_TOUCH, CasterLvl);
}

