/*
    Deep Gnome Blindness/Deafness
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);
    // 10 + Spell level (2) + Racial bonus (4) + Cha Mod
    int nDC       = 16 + GetAbilityModifier(ABILITY_CHARISMA);

    DoRacialSLA(SPELL_BLINDNESS_AND_DEAFNESS, CasterLvl, nDC);
}
