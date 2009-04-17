//::///////////////////////////////////////////////
//:: Name      Congress of Shadows
//:: FileName  mys_congrs_shad.nss
//:://////////////////////////////////////////////
/**@file CONGRESS OF SHADOWS
Apprentice, Ebon Whispers
Level/School: 2nd/Divination [Mind-Affecting]
Range: 1 mile/level
Target: One living creature whose exact location is known to
you, or one living creature you know well whose approximate
location (within 100 ft.) is known to you
Duration: Instantaneous
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You speak, and your words appear in the mind of a distant
creature. The message can consist of up to five words, plus
one additional word per caster level. It cannot deliver
command words for magic items, or in any other respect
function as anything but normal speech. If the subject is
where you believe it to be, the message is delivered. The
subject recognizes the identity of the sender of the message
if it knows you. The creature can then reply, using the same
number of words that you used. The message cannot cross
planar boundaries.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;
        PRCSetSchool();
        
        
        
        PRCSetSchool();
}