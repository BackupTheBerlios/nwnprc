//////////////////////////////////////////////////
// Feral Death Blow
// tob_tgcw_ferdbl.nss
// Tenjac  10/5/07
//////////////////////////////////////////////////
/** @file Feral Death Blow
Tiger Claw (Strike)
Level: Swordsage 9, warblade 9
Prerequisite: Four Tiger Claw maneuvers
Initiation Action: 1 full round action
Range: Melee attack
Target: One creature
Saving Throw: Fortitude partial

With a pirmal howl, you leap into the air and land on your opponent, hacking and clawing at his neck.

You leap upon your opponent, rending and tearing with your weapons in an attempt to kill him
with a brutally overwhelming assault. You grab onto your foe as you slash and hack at his
neck, face, and other vulnerable areas.

To use this maneuver, you muste be adjacent to your intended target. As part of this maneuver
make a Jump check with a DC equal to your opponent's AC. If the check succeeds, you can then
make a single melee attack afainst your foe, also as part of this maneuver. The target is 
considered flat-footed against this attack. If your attack deals damage, your target must 
attempt a Fortitude save (DC19 + your Str modifier). If this save fails, your target is
instantly slain (his hit points drop to -10). If the save is successful, you deal an extra
20d6 points of damage to the target in addition to your normal weapon damage. Creatures immune
to critical hits are immune to the death effect of this strike.

If your Jump check fails, you can make a singe attack normally. The maneuver is still considered
expended.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
        if (!PreManeuverCastCode())
        {
                // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
                return;
        }
        
        // End of Spell Cast Hook
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
        AssignCommand(oTarget, ClearAllActions(TRUE));
        int nArmor           = GetAC(oTarget);
        effect eNone = EffectVisualEffect(VFX_COM_BLOOD_CRT_RED);
        object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
        
        if(move.bCanManeuver)
        {
                if(GetIsSkillSuccessful(oInitiator, SKILL_JUMP, nArmor))
                {
                        int nHP = GetCurrentHitPoints(oTarget);
                        PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Feral Death Blow Hit", "Feral Death Blow Miss");
                        
                        if(GetCurrentHitPoints(oTarget) < nHP)
                        {
                                //Save
                                int nDC = 19 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator);
                                if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
                                {
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(20), GetWeaponDamageType(oWeap)), oTarget);
                                }
                                
                                else
                                {
                                        DeathlessFrenzyCheck(oTarget);
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM), oTarget);
                                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                                }
                        }
                }
                
                else PerformAttack(oTarget, oInitiator, eNone, 0.0, 0, 0, 0, "Hit", "Miss");
        }
}
                                     
                                
                                
                        