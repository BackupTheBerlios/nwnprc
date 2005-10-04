//::///////////////////////////////////////////////
//:: Truestrike
//:: x0_s0_truestrike.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+20 attack bonus for 9 seconds.
CHANGE: Miss chance still applies, unlike rules.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "prc_alterations"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE);
    DoRacialSLA(SPELL_TRUE_STRIKE, nLevel, 0);
}

