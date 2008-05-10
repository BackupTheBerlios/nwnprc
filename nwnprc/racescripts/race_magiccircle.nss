/*
    Racial Magic Circle spells
*/
#include "prc_alterations"

void main()
{
    int CasterLvl = GetHitDice(OBJECT_SELF);

    if(GetSpellId() == SPELL_RACIAL_CIRCLE_VS_GOOD)
        DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_GOOD, CasterLvl);
    
    if(GetSpellId() == SPELL_RACIAL_CIRCLE_VS_EVIL)
        DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, CasterLvl);
    
    if(GetSpellId() == SPELL_RACIAL_CIRCLE_VS_LAW)
        DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_LAW, CasterLvl);
    
    if(GetSpellId() == SPELL_RACIAL_CIRCLE_VS_CHAOS)
        DoRacialSLA(SPELL_MAGIC_CIRCLE_AGAINST_CHAOS, CasterLvl);
}
