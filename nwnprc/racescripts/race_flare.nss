/*
    Irda Flare
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);   
    
    DoRacialSLA(SPELL_FLARE, CasterLvl);
}
