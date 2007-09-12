//////////////////////////////////////////////////
// Strength of Stone
// tob_stdr_strston.nss
// Tenjac  9/12/07
//////////////////////////////////////////////////
/** @file Strength of Stone
Stone Dragon (Stance)
Level: Crusader 8, swordsage 8, warblade 8
Prerequisite: Three Stone Dragon maneuvers
Initiation Action: 1 swift action
Range: Personal
Target: You
Duration: Stance

You enter an impenetrable defensive stance, making it almost impossible for an attack to 
strike you in a vulnerable area.

While you are in this stance, you focus your efforts on preventing any devastating attacks from 
penetrating your defenses. You are immune to critical hits while you are in this stance.

This stance immediately ends if you move more than 5 feet for any reason, such as from a 
bull rush attack, a telekinesis spell, and so forth.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void LocMon(object oInitiator, location lOrig);

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
        location lOrig;
        
        if(move.bCanManeuver)
        {
                effect eImmune = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
                eImmune = SupernaturalEffect(eImmune);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmune, oInitiator, HoursToSeconds(1));
                lOrig = GetLocation(oInitiator);
        }
        
        LocMon(oInitiator, lOrig);
        
}

void LocMon(object oInitiator, location lOrig)
{
        float fDist = GetDistanceBetweenLocations(lOrig, GetLocation(oInitiator));
        
        if(fDist < FeetToMeters(5.0))
        {
                DelayCommand(1.0f, LocMon(oInitiator, lOrig));
        }
        
        else
        {
                effect eTest = GetFirstEffect(oInitiator);
                
                while(GetIsEffectValid(eTest))
                {
                        if(GetEffectType(eTest == EFFECT_TYPE_IMMUNITY))
                        {
                                if(GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
                                {
                                        if(GetEffectDurationType(eTest) == DURATION_TYPE_TEMPORARY)
                                        {
                                                RemoveEffect(eTest);
                                        }
                                }
                                
                        }
                        eTest = GetNextEffect(oInitiator);
                }
        }
}
        
                