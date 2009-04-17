//::///////////////////////////////////////////////
//:: Name      
//:: FileName  
//:://////////////////////////////////////////////
/**@file AFRAID OF THE DARK
Apprentice, Umbral Mind
Level/School: 3rd/Illusion (Mind-Affecting, Shadow)
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature
Duration: Instantaneous
Saving Throw: Will half
Spell Resistance: Yes

You draw forth a twisted reflection of your foe from the 
Plane of Shadow. The image unerringly touches the subject, 
causing Wisdom damage equal to 1d6 points +1 point per four
caster levels (maximum +5). A Will saving throw halves the 
Wisdom damage.

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