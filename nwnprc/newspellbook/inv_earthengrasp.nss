
#include "prc_alterations"
#include "inc_utility"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
    
    object oArea = GetArea(OBJECT_SELF);
    if(GetSpellId() == INVOKE_EARTHEN_GRASP && 
       GetIsAreaNatural(oArea) != AREA_NATURAL && 
       GetIsAreaAboveGround(oArea) != AREA_ABOVEGROUND)
    {
        FloatingTextStringOnCreature("You can only use this invocation in natural, above-ground areas.", OBJECT_SELF, FALSE);
        return;
    }
    
    //Declare major variables
    int nDuration = GetInvokerLevel(OBJECT_SELF, GetInvokingClass());
    effect eSummon = EffectSummonCreature("inv_earthenhand");
    float fDuration = RoundsToSeconds(nDuration * 2);
    effect eDR = EffectDamageReduction(4, DAMAGE_POWER_ENERGY);
    effect eHP = EffectTemporaryHitpoints(nDuration * 3 - 3);
    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
    if(GetSpellId() == INVOKE_STONY_GRASP)
    {
        eSummon = EffectSummonCreature("inv_stonyhand");
        fDuration = RoundsToSeconds(nDuration);
        eDR = EffectDamageReduction(8, DAMAGE_POWER_ENERGY);
        eHP = EffectTemporaryHitpoints(nDuration * 4 - 4);
    }
    effect eAOE = EffectAreaOfEffect(INVOKE_AOE_EARTHEN_GRASP_GRAPPLE);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);
    int i = 1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
    while(GetIsObjectValid(oSummon))
    {
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
        i++;
    }
    SetLocalInt(oSummon, "SourceOfGrapple", TRUE);
    eAOE = EffectLinkEffects(eAOE, EffectCutsceneParalyze());
    effect eLink = EffectLinkEffects(eDR, eHP);
    eLink = EffectLinkEffects(eLink, eHand);
    eLink = EffectLinkEffects(eLink, eAOE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oSummon);
    

}

