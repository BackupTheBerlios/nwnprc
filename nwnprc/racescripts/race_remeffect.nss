/*
	Yuan-ti Neutralize Poison
*/
#include "X0_I0_SPELLS"
#include "spinc_common"
void main()
{
    object oTarget = GetSpellTargetObject();
    int nEffect1;
    int nEffect2;
    int nEffect3;
    effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
    nEffect1 = EFFECT_TYPE_POISON;
    nEffect2 = EFFECT_TYPE_DISEASE;
    nEffect3 = EFFECT_TYPE_ABILITY_DECREASE;
    
    RemoveSpecificEffect(nEffect1, oTarget);
    if(nEffect2 != 0)
    {
        RemoveSpecificEffect(nEffect2, oTarget);
    }
    if(nEffect3 != 0)
    {
        RemoveSpecificEffect(nEffect3, oTarget); 
    }
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}


