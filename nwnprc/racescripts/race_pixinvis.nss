/*
    Pixie Invis
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = 8;
    
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GRIG) { CasterLvl = 9; }

    DoRacialSLA(SPELL_INVISIBILITY, CasterLvl);
}


