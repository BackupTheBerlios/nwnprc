/*
	Duegar Invisibility
*/
#include "prc_inc_clsfunc"
void main()
{
    int CasterLvl = (GetHitDice(OBJECT_SELF) * 2);

    ActionCastSpell(SPELL_INVISIBILITY, CasterLvl);
}

