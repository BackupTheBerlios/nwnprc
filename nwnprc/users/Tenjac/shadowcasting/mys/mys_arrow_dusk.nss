//::///////////////////////////////////////////////
//:: Name      Arrow of Dusk
//:: FileName  mys_arrow_dusk.nss
//:://////////////////////////////////////////////
/**@file ARROW OF DUSK
Fundamental
Level/School: 1st/Evocation
Range: Medium (100 ft. + 10 ft./level)
Effect: Ray
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You must succeed on a ranged touch attack to deal 2d4 points of nonlethal damage to the target.
If you score a critical hit, triple the damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool(SPELL_SCHOOL_EVOCATION);
        
        
        
        PRCSetSchool();
}