//::///////////////////////////////////////////////
//:: Aura of Fear
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "prc_alterations"
void main()
{
    int AOESize = AOE_MOB_FEAR;
    //Set and apply AOE object
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOESize,"hound_aurafeara"));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);
}
