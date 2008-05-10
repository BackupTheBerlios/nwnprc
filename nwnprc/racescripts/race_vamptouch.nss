/*
    Racepack Vampiric Touch
*/
#include "prc_alterations"

#include "prc_racial_const"
#include "prc_spell_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ZAKYA_RAKSHASA) { CasterLvl = 7; }

    DoRacialSLA(SPELL_VAMPIRIC_TOUCH, CasterLvl);
}

