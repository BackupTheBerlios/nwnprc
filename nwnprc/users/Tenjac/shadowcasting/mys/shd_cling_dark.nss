//::///////////////////////////////////////////////
//:: Name      Clinging Darkness
//:: FileName  mys_cling_dark.nss
//:://////////////////////////////////////////////
/**@file CLINGING DARKNESS
Apprentice, Dark Terrain
Level/School: 3rd/Conjuration (Creation)
Range: Close (25 ft. + 5 ft./2 levels)
Area: 20-ft.-radius emanation (D)
Duration: 1 minute/level
Saving Throw: Refl ex negates; see text
Spell Resistance: Yes

Any creature within the area affected by this mystery, or
that enters the area on its turn, must make a Reflex save or
become immobilized (see page 140). Each round on its turn, an 
immobilized subject can attempt a new saving throw to end the 
condition. Because of the subject’s condition, this save is a 
full-round action (but does not provoke attacks of opportunity).
If an immobilized subject succeeds on its save, it still needs 
to save again at the start of its next turn in order to avoid 
succumbing to the darkness again.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "shd_inc_shdfunc"
#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool();
        
        
        
        PRCSetSchool();
}