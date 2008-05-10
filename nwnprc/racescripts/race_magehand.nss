/*
    Whisper Gnome Mage Hand
    Also used for Irda
*/

#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_MAGE_HAND, CasterLvl);
}