/*
    nw_s0_aid

    Target creature gains +1 to attack rolls and
    saves vs fear. Also gain +1d8 temporary HP.

    By: Preston Watamaniuk
    Created: Sept 6, 2001
    Modified: Jun 12, 2006
*/

#include "prc_sp_func"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    if (!PreInvocationCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    
    //Declare major variables
    int nBonus = nCasterLevel;
    
    //  Spell does not stack with itself
    if (GetHasSpellEffect(INVOKE_DRACONIC_TOUGHNESS,oTarget))
    {
         RemoveSpellEffects(INVOKE_DRACONIC_TOUGHNESS, oCaster, oTarget);
    }

    effect eHP = EffectTemporaryHitpoints(nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_DRACONIC_TOUGHNESS, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(24),TRUE,-1,nCasterLevel);
}