/*
	Feyri Clairaudience
*/
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    ActionCastSpell(SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE, CasterLvl);
}

