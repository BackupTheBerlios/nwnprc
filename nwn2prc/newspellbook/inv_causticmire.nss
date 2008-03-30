

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
    
    if(GetLocalInt(OBJECT_SELF, "CausticMireLock"))
    {
        FloatingTextStringOnCreature("You must wait for the previous casting to expire.", OBJECT_SELF, FALSE);
        return;
    }

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_CAUSTIC_MIRE);
    location lTarget = GetSpellTargetLocation();
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    effect eImpact = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    
    SetLocalInt(OBJECT_SELF, "CausticMireLock", TRUE);
    DelayCommand(RoundsToSeconds(nDuration), DeleteLocalInt(OBJECT_SELF, "CausticMireLock"));

}

