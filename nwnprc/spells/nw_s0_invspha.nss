//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Enter
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "spinc_common"
#include "x2_inc_spellhook"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
 ActionDoCommand(SetAllAoEInts(SPELL_INVISIBILITY_SPHERE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    object oTarget = GetEnteringObject();

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eInvis, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    // * don't try and make dead people invisible
    if (GetIsDead(oTarget) == FALSE)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY_SPHERE, FALSE));
        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

