//::///////////////////////////////////////////////
//:: codi_pre_infw
//:://////////////////////////////////////////////
/*

    Ocular Adept - Inflict Moderate Wounds

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


    //SendMessageToPC(OBJECT_SELF, "Inflict script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;

    object oTarget = GetSpellTargetObject();
    int nRacial = MyPRCGetRacialType(oTarget);

    int bHit = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_RANGED_SPELL);

    //if(!GetIsReactionTypeFriendly(oTarget) || nRacial == RACIAL_TYPE_UNDEAD)
    //{
        if(bHit) {
            if(nRacial == RACIAL_TYPE_UNDEAD) {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_INFRAY, FALSE));
                effect e1 = EffectHeal(d8(2)+10);
                effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
            } else {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_INFRAY, TRUE));
                //Make SR Check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nOcSv, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        effect e1 = EffectDamage(d8(2)+10);
                        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
                    } else {
                    //Half damage
                        effect e1 = EffectDamage((d8(2)+10)/2);
                        effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                        ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
                    }
                }
            }
        } else {
            if(GetIsPC(OBJECT_SELF)) {
                SendMessageToPC(OBJECT_SELF, "The ray missed.");
            }
        }
    //}
}
