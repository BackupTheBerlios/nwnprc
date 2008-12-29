

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    if (!PreInvocationCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int bValid = FALSE;
    int nBPIndex = 0;
    int nBPTIndex = 0;
    
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    
    //Add to array on target of breaths they're protected from

    if(!array_exists(oTarget, "BreathProtected"))
         array_create(oTarget, "BreathProtected");
    
    while(!bValid)
    {
    	//find the first empty spot and add it
    	if(array_get_object(oTarget, "BreathProtected", nBPIndex) == OBJECT_INVALID)
    	{
              array_set_object(oTarget, "BreathProtected", nBPIndex, oCaster);
              bValid = TRUE;
        }
        else
              nBPIndex++;
    }

    //add to array on caster of targets protected by their spell for resting cleanup

    if(!array_exists(oCaster, "BreathProtectTargets"))
         array_create(oCaster, "BreathProtectTargets");
    
    while(!bValid)
    {
    	//find the first empty spot and add it
    	if(array_get_object(oCaster, "BreathProtectTargets", nBPTIndex) == OBJECT_INVALID)
    	{
              array_set_object(oCaster, "BreathProtectTargets", nBPTIndex, oTarget);
              if(DEBUG) DoDebug("Storing target: " + GetName(array_get_object(oCaster, "BreathProtectTargets", nBPTIndex)));
              bValid = TRUE;
        }
        else
              nBPTIndex++;
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
