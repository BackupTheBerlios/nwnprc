//////////////////////////////////////////////////
// Profane Life Leech
// prc_prflflch.nss
//////////////////////////////////////////////////
/** @file Profane Lifeleech [Divine]

Prerequisite: Ability to rebuke undead.

Benefit: As a standard action, you can spend two of your rebuke attempts to deal
1d6 points of damage to all living creatures within a 30-foot burst. You are healed of
an amount of damage equal to the total amount of hit points that you drain from 
affected creatures, but this healing does not allow you to exceed your full normal
hit point total.

Special: This feat deals no damage to constructs or undead.
*/
///////////////////////////////////////////////////////////////////////////////////
// Author: Tenjac
// Created: 4/22/08
///////////////////////////////////////////////////////////////////////////////////

#include "prc_alterations"

void main()
{
        object oPC = OBJECT_SELF;
        location lLoc = GetLocation(oPC);
        
        //Rebuke check
        if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_EVIL)
        {
                SendMessageToPC(oPC, "You must be able to Rebuke Undead to use this feat.");
                return;
        }        
        
        //If they have zero left, uncermoniously boot them without incrementing
        if(!GetHasFeat(oPC, FEAT_TURN_UNDEAD))
        {
                SendMessageToPC(oPC, "You do not have enough uses of Rebuke Undead left.");
                return;
        }        
        
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
        
        //Check for a remaining use
        if(GetHasFeat(oPC, FEAT_TURN_UNDEAD))
        {
                //burn the other use required
                DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
                
                int nDam;
                
                object oTarget = MyGetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
                
                while(GetIsObjectValid(oTarget))
                {
                        if(PRCGetIsAliveCreature(oTarget) && (!GetIsReactionTypeFriendly(oTarget)))
                        {
                                nDam = d6(1);
                                
                                //Damage
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_DIVINE), oTarget);
                                
                                //Heal
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nDam), oTarget);                                
                        }
                        
                        oTarget = MyGetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
                }
        
        else
        {
                IncrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
                SendMessageToPC(oPC, "You do not have enough uses of Rebuke Undead left.")
        }
} 