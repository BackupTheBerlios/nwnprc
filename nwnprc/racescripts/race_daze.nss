/*
	Racepack Daze
*/
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHYANKI) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GITHZERAI) { CasterLvl = 3; }    
    
    ActionCastSpell(SPELL_DAZE, CasterLvl);
}
