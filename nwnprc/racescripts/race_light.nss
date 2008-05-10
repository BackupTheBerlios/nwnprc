/*
    Racepack Light
    Used for: Gloaming, Aasimar, Irda
*/
#include "prc_alterations"


void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    if (CasterLvl < 1)
    {
        CasterLvl = 1;
    }

    DoRacialSLA(SPELL_LIGHT, CasterLvl);
}

