//::///////////////////////////////////////////////
//:: Blur
//:: race_blur.nss
//:://////////////////////////////////////////////
/*
    20% concealment to all attacks

    Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: WodahsEht
//:: Created On: October 3, 2004
//:://////////////////////////////////////////////

#include "spinc_common"



void main()
{


     //Declare major variables
    object oTarget = OBJECT_SELF;
    int nDuration;
    if (GetRacialType(oTarget) == RACIAL_TYPE_DEEP_GNOME) { nDuration = 3; }
    else if (GetRacialType(oTarget) == RACIAL_TYPE_GITHYANKI) { nDuration = 3; }
    int CasterLvl = nDuration;
    effect eVis = EffectVisualEffect(VFX_DUR_BLUR);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    effect eShield =  EffectConcealment(20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eShield, eDur);
           eLink = EffectLinkEffects(eLink, eVis);
    RemoveSpellEffects(GetSpellId(), oTarget, oTarget);

    //Apply the armor bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration * 60.0, TRUE, -1, CasterLvl);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Erasing the variable used to store the spell's spell school
}

