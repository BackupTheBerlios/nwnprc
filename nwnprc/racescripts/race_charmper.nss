/*
	Race Pack Charm Person
*/
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { CasterLvl = GetHitDice(OBJECT_SELF); }
    
    ActionCastSpell(SPELL_CHARM_PERSON, CasterLvl);
}
