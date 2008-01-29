

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvocationLevel(oCaster);
    if (!PreInvocationCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int bValid = FALSE;
    int nBPIndex = 0;
    
    effect eVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
    
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
        
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}