//::///////////////////////////////////////////////
//:: Name      Black Fire
//:: FileName  mys_black_fire.nss
//:://////////////////////////////////////////////
/**@file BLACK FIRE
Apprentice, Dark Terrain
Level/School: 2nd/Evocation [Cold]
Range: Close (25 ft. + 5 ft./2 levels)
Area: One 5-ft. square/level (S)
Duration: 1 round/level (D)
Saving Throw: Reflex negates; see text
Spell Resistance: Yes

You create a shapeable shadowy curtain of black flame that
covers the affected squares. The fire deals 1d6 points of cold
damage per two caster levels to any creature standing in an
affected square at the beginning of each of your turns until
the effect ends. In addition, the flame deals damage to any
creature entering or passing through an affected square. Black
fire burns only a few feet tall, so a creature can avoid the effect
of the mystery by jumping or flying over the area.

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