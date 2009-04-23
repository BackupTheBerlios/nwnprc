//::///////////////////////////////////////////////
//:: Name      Carpet of Shadow
//:: FileName  mys_carpet_shad.nss
//:://////////////////////////////////////////////
/**@file CARPET OF SHADOW
Apprentice, Dark Terrain
Level/School: 1st/Conjuration (Creation)
Range: Close (25 ft. + 5 ft./2 levels)
Area: One 5-ft. square/level (S)
Duration: 1 minute/level (D)
Saving Throw: None
Spell Resistance: No

You cloak the ground with an uneven and hard to traverse
surface. The terrain becomes difficult, meaning that each
5-foot square within the area costs double to move into. For
instance, each light undergrowth square (normally costing
2 squares of movement to move into) now costs 4 squares of
movement to move into. If you cast this mystery a second
time on the same area (or a portion of the same area) while
the first casting is still active, the second casting does not
worsen the terrain further (although it would extend the
duration of the effect on that area).

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