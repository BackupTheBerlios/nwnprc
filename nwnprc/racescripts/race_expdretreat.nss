/*
    Racial Expiditious retreat spell
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_EXPEDITIOUS_RETREAT, CasterLvl);
}
