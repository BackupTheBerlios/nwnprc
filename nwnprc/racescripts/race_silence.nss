/*
    Whisper Gnome Silence
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    DoRacialSLA(SPELL_SILENCE, CasterLvl);
}
