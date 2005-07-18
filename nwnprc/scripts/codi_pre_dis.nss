//::///////////////////////////////////////////////
//:: codi_pre_dis
//:://////////////////////////////////////////////
/*
     Ocular Adept: Disintegrate
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:: Modified By: Ornedan
//:: Modified On: 30.03.2005
//:: Modfication: Changed to work as the spell Disintegrate
//:://////////////////////////////////////////////
/*#include "X0_I0_SPELLS"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"*/
#include "spinc_common"
#include "prc_inc_sp_tch"

void main()
{
    object oTarget = GetSpellTargetObject();

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        int nOcLvl = GetLevelByClass(CLASS_TYPE_OCULAR, OBJECT_SELF);
        int nChaMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
        int nOcSv = 10 + (nOcLvl/2) + nChaMod;
        //effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
        effect eVis2 = EffectVisualEffect(VFX_IMP_PULSE_WIND);
        //effect eLink = EffectLinkEffects(eVis, eVis2);


        // Make the touch attack
        int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
        if(nTouchAttack > 0){
            // Singal hostile event
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_OA_DISRAY, TRUE));

            // Make SR check
            if(!SPResistSpell(OBJECT_SELF, oTarget))
            {
                // Fire the beam VFX
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                EffectBeam(VFX_BEAM_DISINTEGRATE, OBJECT_SELF, BODY_NODE_HAND), oTarget, 1.0, FALSE);

                int nDamage = 9999;

                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nOcSv))
                {
                    nDamage = d6(1 == nTouchAttack ? 5 : 10);
                }
                else
                {
                    // If FB passes saving throw it survives, else it dies
                    DeathlessFrenzyCheck(oTarget);

                    // For targets with > 9999 HP. Uncomment if you have such in your module and would like Disintegrate
                    // to be sure to blast them
                    //DelayCommand(0.30, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
                }

                //Apply damage effect and VFX impact
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                ApplyTouchAttackDamage(OBJECT_SELF, oTarget, nTouchAttack, nDamage, DAMAGE_TYPE_MAGICAL);
            }
        }
    }
}