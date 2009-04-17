//::///////////////////////////////////////////////
//:: Name      Bolster
//:: FileName  mys_bolster.nss
//:://////////////////////////////////////////////
/**@file BOLSTER
Initiate, Body and Soul
Level/School: 4th/Transmutation
Range: Touch
Target: Creature touched
Duration: 10 minutes/level 
Saving Throw: Will negates (harmless)
Spell Resistance: Yes (harmless)

You grant the subject 5 temporary hit points for each of its
Hit Dice (maximum 75). For the duration of the effect, the
subject’s shadow grows larger than normal, and its movements
are very slightly uncoordinated with those of the subject. An
observer can notice this characteristic by making a DC 20
Spot check.

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