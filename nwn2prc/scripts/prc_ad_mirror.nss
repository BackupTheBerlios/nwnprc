#include "prc_alterations"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST);
    int nDC    =  GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_MIRROR_IMAGE, nLevel, nDC);
}
