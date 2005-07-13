/*
    Race Pack Charm Person
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl, DC;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { CasterLvl = GetHitDice(OBJECT_SELF); }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_OMAGE) { CasterLvl = 9; }
    
    DoRacialSLA(SPELL_CHARM_PERSON, CasterLvl, DC);
}
