/*
    Racepack Darkness
*/
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_TIEFLING) { CasterLvl = GetHitDice(OBJECT_SELF); }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_MALE) { CasterLvl = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_FEMALE) { CasterLvl = 3; }
    
    if (CasterLvl < 1)
    {
        CasterLvl = 1;
    }

    ActionCastSpell(SPELL_DARKNESS, CasterLvl);
}
