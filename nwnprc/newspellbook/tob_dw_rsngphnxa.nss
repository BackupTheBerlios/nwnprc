/*
   ----------------
   Rising Phoenix, Feat strike
   
   tob_dw_rsngphnx.nss
   ----------------

    01/11/07 by Stratovarius
*/ /** @file

    Rising Phoenix

    Desert Wind (Stance) [Fire]
    Level: Swordsage 8
    Prerequisite: Three Desert Wind maneuvers
    Initiation Action: 1 Swift Action
    Range: Personal
    Target: You
    Duration: Stance
    
    Hot winds swirl about your feet, lifting you skyward as flames begin to flick below.
    
    You gain freedom of movement. You may attack an adjacent enemy with an extra 3d6 fire damage. 
    (Use the feat added).
    This is a supernatural maneuver.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();

    if(GetHasSpellEffect(MOVE_DW_RISING_PHOENIX, oInitiator))
    {
    	effect eNone;
	DelayCommand(0.0, PerformAttackRound(oTarget, oInitiator, eNone, 0.0, 0, d6(3), DAMAGE_TYPE_FIRE, TRUE, "Rising Phoenix Hit", "Rising Phoenix Miss"));
    }
}