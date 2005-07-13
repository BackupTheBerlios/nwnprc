/*
    Duegar Invisibility
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = (GetHitDice(OBJECT_SELF) * 2);

    DoRacialSLA(SPELL_INVISIBILITY, CasterLvl);
}

