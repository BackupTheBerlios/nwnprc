/*
    Feyri Clairaudience
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, CasterLvl);
}

