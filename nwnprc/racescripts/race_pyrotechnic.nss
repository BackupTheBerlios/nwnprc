/*
    Grig Pyrotechnics
*/

#include "prc_alterations"


void main()
{
    int CasterLvl = 9;

    if(GetSpellId() == SPELL_GRIG_PYROTECHNICS_FIREWORKS)
        DoRacialSLA(SPELL_PYROTECHNICS_FIREWORKS, CasterLvl);
    else if(GetSpellId() == SPELL_GRIG_PYROTECHNICS_SMOKE)
        DoRacialSLA(SPELL_PYROTECHNICS_SMOKE, CasterLvl);
}
