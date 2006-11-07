//::///////////////////////////////////////////////
//:: Blur
//:: prc_ad_blur.nss
//:://////////////////////////////////////////////
/*
    20% concealment to all attacks

    Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"



void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST);
    int nDC    =  GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_BLUR, nLevel, nDC);
}

