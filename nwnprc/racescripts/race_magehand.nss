/*
    Whisper Gnome Mage Hand
*/

#include "prc_inc_racial"
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_MAGE_HAND, CasterLvl);
}