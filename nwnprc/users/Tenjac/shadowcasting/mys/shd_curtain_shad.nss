//::///////////////////////////////////////////////
//:: Name      Curtain of Shadows
//:: FileName  mys_curtain_shad.nss
//:://////////////////////////////////////////////
/**@file CURTAIN OF SHADOWS
Initiate, Veil of Shadows
Level/School: 5th/Transmutation
Range: Close (25 ft. + 5 ft./2 levels)
Effect: Shadowy wall whose area is up to one 10-ft. square/level (S)
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: No

You create a wall of shadow that completely blocks line of
sight. Any creature passing through the wall takes 1d6 points
of cold damage per caster level (maximum 15d6).

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"
#include "shd_inc_shdfunc"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool();
        
        
        
        PRCSetSchool();
}