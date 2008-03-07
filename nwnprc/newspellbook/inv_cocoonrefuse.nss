
//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "prc_alterations"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void DoRefuseEscapeCheck(object oTarget, int nDurationRemaining, object oCaster)
{
    int nStrChk = d20() + GetAbilityModifier(ABILITY_STRENGTH, oTarget);
    if(nStrChk > 20)
    {
        RemoveSpellEffects(INVOKE_COCOON_OF_REFUSE, oCaster, oTarget);
        FloatingTextStringOnCreature("*Strength check successful!*", oTarget, FALSE);
    }
    else if(nDurationRemaining > 0)
        DelayCommand(RoundsToSeconds(1), DoRefuseEscapeCheck(oTarget, nDurationRemaining - 1, oCaster));
}

void main()
{
    if (!PreInvocationCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    effect   eVis         = EffectVisualEffect( VFX_DUR_ENTANGLE );
    int      nCasterLvl   = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    object   oTarget      = PRCGetSpellTargetObject();
    int nDC = SPGetSpellSaveDC(oTarget, OBJECT_SELF);
    object oArea = GetArea(OBJECT_SELF);
    
    effect eEntangle = EffectEntangle();
    effect eLink = EffectLinkEffects(eEntangle, eVis);
    
    if(GetIsAreaNatural(oArea) != AREA_NATURAL && 
       GetIsAreaAboveGround(oArea) == AREA_ABOVEGROUND)
    {
        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLvl),TRUE,-1,nCasterLvl);
            DelayCommand(RoundsToSeconds(1), DoRefuseEscapeCheck(oTarget, nCasterLvl, OBJECT_SELF));
		}
    }
}
