//::///////////////////////////////////////////////
//:: Sassone Leaf Residue On Hit
//:: NW_S0_1Sassone
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 2d12 damage on hit.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_effect_inc"

void main()
{
    object oTarget = OBJECT_SELF; 
    effect eDam = EffectDamage(d12(2), DAMAGE_TYPE_ACID);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
}
