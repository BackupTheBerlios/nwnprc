/*
	Whisper Gnome Silence
*/
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    ActionCastSpell(SPELL_BLESS, CasterLvl);
}
