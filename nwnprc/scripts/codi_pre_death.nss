//::///////////////////////////////////////////////
//:: codi_pre_death
//:://////////////////////////////////////////////
/*
      Ocular Adept: Finger of Death
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
    //SendMessageToPC(OBJECT_SELF, "Death script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int bHit = TouchAttackRanged(oTarget,FALSE)>0;

    if(bHit) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_DEATHRAY, TRUE));
        if (!MyResistSpell(OBJECT_SELF, oTarget)) {
            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, nOcSv, SAVING_THROW_TYPE_DEATH)) {
                //Apply the death effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            } else {
                //Roll damage
                int nDamage = d6(3) + nCasterLvl;
                effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                //Apply damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            }
        }
    } else {
        if(GetIsPC(OBJECT_SELF)) {
            SendMessageToPC(OBJECT_SELF, "The ray missed.");
        }
    }
}
