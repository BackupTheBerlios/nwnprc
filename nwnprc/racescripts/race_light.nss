/*
    Racepack Light
*/
#include "prc_inc_clsfunc"
#include "prc_racial_const"
void main()
{
    int CasterLvl;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_AASIMAR) { CasterLvl = GetHitDice(OBJECT_SELF); }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_GLOAMING) { CasterLvl = GetHitDice(OBJECT_SELF); }

    if (CasterLvl < 1)
    {
        CasterLvl = 1;
    }

    ActionCastSpell(SPELL_LIGHT, CasterLvl);
}

