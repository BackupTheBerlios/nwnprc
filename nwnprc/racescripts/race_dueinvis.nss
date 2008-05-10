/*
    Duegar Invisibility
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = (GetHitDice(OBJECT_SELF) * 2);

    DoRacialSLA(SPELL_INVISIBILITY, CasterLvl);
}

