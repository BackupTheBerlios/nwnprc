/*
    Zenythri True Strike
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_TRUE_STRIKE, CasterLvl);
}
