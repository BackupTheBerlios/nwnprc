//::///////////////////////////////////////////////
//:: codi_pre_slow
//:://////////////////////////////////////////////
/*
        Ocular Adept - Slow
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
    //SendMessageToPC(OBJECT_SELF, "Slow script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;

    object oTarget = GetSpellTargetObject();
    int bHit = PRCDoRangedTouchAttack(oTarget);;

    if(bHit) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_SLOWRAY, TRUE));
        if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nOcSv)) {
                effect e1 = EffectSlow();
                effect eVis = EffectVisualEffect(VFX_IMP_SLOW);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(GetLevelByTypeDivine()));
            }
        }
    } else {
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray missed.");
        }
    }
}
