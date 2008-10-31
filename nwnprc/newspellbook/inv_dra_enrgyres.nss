/*
    sp_eimmunity

    Energy Immunity scripts combined

    By: Flaming_Sword
    Created: Jul 1, 2006
    Modified: Aug 26, 2006
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
    
    int nSpellID = PRCGetSpellId();
    int nDamageType, nVfx;
    switch(nSpellID)
    {
        case (INVOKE_ENERGY_RESISTANCE_ACID):
        {
            nDamageType = DAMAGE_TYPE_ACID;
            nVfx = VFX_IMP_ACID_L;
            break;
        }
        case (INVOKE_ENERGY_RESISTANCE_COLD):
        {
            nDamageType = DAMAGE_TYPE_COLD;
            nVfx = VFX_IMP_FROST_L;
            break;
        }
        case (INVOKE_ENERGY_RESISTANCE_ELEC):
        {
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nVfx = VFX_IMP_LIGHTNING_M;
            break;
        }
        case (INVOKE_ENERGY_RESISTANCE_FIRE):
        {
            nDamageType = DAMAGE_TYPE_FIRE;
            nVfx = VFX_IMP_FLAME_M;
            break;
        }
        case (INVOKE_ENERGY_RESISTANCE_SONIC):
        {
            nDamageType = DAMAGE_TYPE_SONIC;
            nVfx = VFX_IMP_SONIC;
            break;
        }
    }
    float fDuration = HoursToSeconds(24);
    effect eList = EffectDamageResistance(nDamageType, 10);
    eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS));
    eList = EffectLinkEffects(eList, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    PRCSignalSpellEvent(oTarget, FALSE, SPELL_ENERGY_IMMUNITY);
    
    //  Spell does not stack with itself, even if it is different immunity types
    if (GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_ACID,oTarget))
    {
         PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_ACID, oCaster, oTarget);
    }
    if (GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_COLD,oTarget))
    {
         PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_COLD, oCaster, oTarget);
    }
    if (GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_ELEC,oTarget))
    {
         PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_ELEC, oCaster, oTarget);
    }
    if (GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_FIRE,oTarget))
    {
         PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_FIRE, oCaster, oTarget);
    }
    if (GetHasSpellEffect(INVOKE_ENERGY_RESISTANCE_SONIC,oTarget))
    {
         PRCRemoveSpellEffects(INVOKE_ENERGY_RESISTANCE_SONIC, oCaster, oTarget);
    }
    
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eList, oTarget, fDuration,TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget);
    
}