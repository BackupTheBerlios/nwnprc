/*
    Zenythri True Strike
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_TRUE_STRIKE, CasterLvl);
}
