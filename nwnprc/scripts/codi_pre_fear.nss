//::///////////////////////////////////////////////
//:: codi_pre_fear
//:://////////////////////////////////////////////
/*
      Ocular Adept: Fear
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    //SendMessageToPC(OBJECT_SELF, "Fear script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetLevelByTypeDivine();
    float fDuration = RoundsToSeconds(nCasterLevel);
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eFear = EffectFrightened();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eFear, eMind);
    eLink = EffectLinkEffects(eLink, eDur);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    int bHit = TouchAttackRanged(oTarget,FALSE)>0;

    if(bHit) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_FEARRAY, TRUE));
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make a will save
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nOcSv, SAVING_THROW_TYPE_FEAR, OBJECT_SELF)) {
                //Apply the linked effects and the VFX impact
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
            }
        }
    } else {
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray missed.");
        }
    }

}
