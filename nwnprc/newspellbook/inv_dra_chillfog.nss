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

void DispelMonitor(object oAoE);

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
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());

    int nDuration = CasterLvl;
    effect eImpact = EffectVisualEffect(257);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    
    
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, TurnsToSeconds(nDuration));
    
    SetLocalInt(OBJECT_SELF, "ChillingFogLock", TRUE);
    DelayCommand(TurnsToSeconds(nDuration), DeleteLocalInt(OBJECT_SELF, "ChillingFogLock"));
    
        // Get an object reference to the newly created AoE
        object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oAoE))
        {
            // Test if we found the correct AoE
            if(GetTag(oAoE) == Get2DACache("vfx_persistent", "LABEL", INVOKE_AOE_CHILLFOG))
            {
                break;
            }
            // Didn't find, get next
            oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }    
    
    DispelMonitor(oAoE);
}

void DispelMonitor(object oAoE)
{
    // Has the power ended since the last beat, or does the duration run out now
    if(GetIsObjectValid(oAoE))
    {
        if(DEBUG) DoDebug("inv_dra_chillfog: The lock effect has been removed");
    	DeleteLocalInt(OBJECT_SELF, "ChillingFogLock");

    }
    else
       DelayCommand(6.0f, DispelMonitor(oAoE));
}