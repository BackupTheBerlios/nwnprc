//::///////////////////////////////////////////////
//:: codi_pre_sleep
//:://////////////////////////////////////////////
/*

    Ocular Adept - Sleep

*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    //SendMessageToPC(OBJECT_SELF, "Sleep script online");
    int nOcLvl = GetLevelByClass(51, OBJECT_SELF);
    int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nOcSv = 10 + (nOcLvl/2) + nChaMod;

    object oTarget = PRCGetSpellTargetObject();
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectSleep();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    int nDuration = GetLevelByTypeDivine();
    nDuration = 3 + GetScaledDuration(nDuration, oTarget);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());
    string sSpellLocal = "BIOWARE_SPELL_LOCAL_SLEEP_" + ObjectToString(OBJECT_SELF);
    //Enter Metamagic conditions
    nDuration += 2;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
        && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 1502, TRUE));
        int bHit = PRCDoRangedTouchAttack(oTarget);;
        if(bHit) {
            //Make SR check
            if (!MyResistSpell(OBJECT_SELF, oTarget)) {
                //Make Fort save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nOcSv, SAVING_THROW_TYPE_MIND_SPELLS)) {
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP) == FALSE) {
                        effect eLink2 = EffectLinkEffects(eLink, eVis);
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
                    }
                    else
                    // * even though I am immune apply just the sleep effect for the immunity message
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSleep, oTarget, RoundsToSeconds(nDuration));
                    }
                }
            }
        } else {
            if(GetIsPC(OBJECT_SELF)) {
                SendMessageToPC(OBJECT_SELF, "The ray missed.");
            }
        }
    }
}
