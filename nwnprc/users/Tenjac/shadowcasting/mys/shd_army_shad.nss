//::///////////////////////////////////////////////
//:: Name      Army of Shadow
//:: FileName  mys_army_shad.nss
//:://////////////////////////////////////////////
/**@file ARMY OF SHADOW
Master, Shadow Calling
Level/School: 9th/Conjuration (Summoning)
Range: Close (25 ft. + 5 ft./2 levels)
Effect: One or more summoned creatures, no two of which are more than 30 ft. apart
Duration: 1 minute/ level 
Saving Throw: None
Spell Resistance: No

This mystery functions like the spell summon monster I, except
as noted here. You can summonone elder, two greater, four Huge,
or eight Large shadow elementals.

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