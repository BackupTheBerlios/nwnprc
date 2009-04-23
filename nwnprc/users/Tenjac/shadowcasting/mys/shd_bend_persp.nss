//::///////////////////////////////////////////////
//:: Name      Bend Perspective
//:: FileName  mys_bend_persp.nss
//:://////////////////////////////////////////////
/**@file BEND PERSPECTIVE
Apprentice, Eyes of Darkness
Level/School: 1st/Divination (Scrying)
Range: Personal
Target: You
Duration: 1 minute/level (D)

You view the world as though you were standing in a different spot, up to a maximum 
distance of 25 feet plus 5 feet per two caster levels. You cannot see through solid
objects. You can, however, look around corners or over barriers, obtain a bird’s-eye
view of your area, and the like. Essentially, you shift your perspective as though 
you were located at any spot in range to which you have line of effect. You can switch
back and forth between your own eyes and your alternate viewpoint as a swift action. 
You can move your alternate perspective, as in the spell arcane eye. Its speed is only
10 feet per round, however, and every round of such movement decreases the mystery’s 
duration by 1 minute (if you move the perspective in the last minute of the duration,
you gain a few seconds of vision at the new position before the effect expires).

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