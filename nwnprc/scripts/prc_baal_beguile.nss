//::///////////////////////////////////////////////
//:: [Mass Charm]
//:: [NW_S0_MsCharm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts to charm a group of individuals
    who's HD can be no more than his level combined.
    The spell starts checking the area and those that
    fail a will save are charmed.  The affected persons
    are Charmed for 1 round per 2 caster levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
//#include "prc_alterations" - included via x0_i0_spells

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "prc_class_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL);
    int nDC    =  GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_MASS_CHARM, nLevel, nDC);
}
