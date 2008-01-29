//::///////////////////////////////////////////////
//:: Acid Fog
//:: NW_S0_AcidFog.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    or their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if(GetLocalInt(OBJECT_SELF, "ChillingFogLock"))
    {
    	SendMessageToPC(OBJECT_SELF, "You can only have one Chilling Fog cast at any given time.");
    	return;
    }


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_CHILLFOG);
    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = GetInvocationLevel(OBJECT_SELF);

    int nDuration = CasterLvl;
    effect eImpact = EffectVisualEffect(257);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    
    
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, TurnsToSeconds(nDuration));
    
    SetLocalInt(OBJECT_SELF, "ChillingFogLock", TRUE);
    DelayCommand(TurnsToSeconds(nDuration), DeleteLocalInt(OBJECT_SELF, "ChillingFogLock"));

}
