//::///////////////////////////////////////////////
//:: codi_pre_chper
//:://////////////////////////////////////////////
/*

    Ocular Adept - Charm Person

*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-29
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main() {

    //SendMessageToPC(OBJECT_SELF, "Charm Person script online");
    int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm = EffectCharmed();
    //eCharm = GetScaledEffect(eCharm, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);


    //Link persistant effects
    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);
    int nCasterLevel = GetLevelByTypeDivine();
    int nDuration = 2 + nCasterLevel;
    //nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = MyPRCGetRacialType(oTarget);

    if(!GetIsReactionTypeFriendly(oTarget))
    {

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_CHPERRAY, TRUE));
        //Make SR Check
        int bHit = TouchAttackRanged(oTarget,FALSE)>0;
        if(bHit) {
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Verify that the Racial Type is humanoid
                if  ((nRacial == RACIAL_TYPE_DWARF) ||
                    (nRacial == RACIAL_TYPE_ELF) ||
                    (nRacial == RACIAL_TYPE_GNOME) ||
                    (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                    (nRacial == RACIAL_TYPE_HALFLING) ||
                    (nRacial == RACIAL_TYPE_HUMAN) ||
                    (nRacial == RACIAL_TYPE_HALFELF) ||
                    (nRacial == RACIAL_TYPE_HALFORC) ||
                    (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                    (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
                    (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
                {
                    //Make a Will Save check
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nOcSv, SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                        //SendMessageToPC(OBJECT_SELF, "Failed Save - duration " + FloatToString(RoundsToSeconds(nDuration)));
                        //Apply impact and linked effects
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                } else {
                    SendMessageToPC(OBJECT_SELF, "The target is immune to this spell.");
                }
            }
        } else {
            if(GetIsPC(OBJECT_SELF)) {
                SendMessageToPC(OBJECT_SELF, "The ray missed.");
            }
        }
    }
}
