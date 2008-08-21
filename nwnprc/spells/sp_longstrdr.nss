//::///////////////////////////////////////////////
//:: Name      Longstrider
//:: FileName  sp_longstrdr.nss
//:://////////////////////////////////////////////
/** @file Longstrider
Transmutation
Level: Drd 1, Rgr 1
Components: V, S
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 hour/level 

This spell increases your base land speed by 10 feet.

Author:    Tenjac
Created:   8/14/08
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        
        object oPC = OBJECT_SELF;
        
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(33), oPC, HoursToSeconds(PRCGetCasterLevel(oPC)));
        
        PRCSetSchool();
}