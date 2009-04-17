//::///////////////////////////////////////////////
//:: Name      Aura of Shade
//:: FileName  mys_aura_shade.nss
//:://////////////////////////////////////////////
/**@file AURA OF SHADE
Initiate, Elemental Shadows
Level/School: 4th/Abjuration [Cold]
Range: Touch
Target: Creature touched
Duration: 1 round/level (D)
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You protect the subject from low temperatures and cold energy with a thin layer of 
that energy’s shadowy reflection. This grants the subject immunity to normal extremes
of temperature and absorbs cold damage from attacks and effects. When an aura of shade
absorbs a total of 12 points of cold damage per caster level (maximum 120), it expires.
For as long as the aura is active, the subject’s weapon or natural weapon melee attacks
deal an extra 1d6 points of cold damage.

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