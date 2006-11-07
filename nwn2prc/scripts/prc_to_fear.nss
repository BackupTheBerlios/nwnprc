//::///////////////////////////////////////////////
//:: Thrall of Orcus Touch of Fear
//:: prc_to_fear
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ORCUS);
    int nDC    =  GetLevelByClass(CLASS_TYPE_ORCUS) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_FEAR, nLevel, nDC);
}

