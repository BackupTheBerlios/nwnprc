//::///////////////////////////////////////////////
//:: Name      Black Candle
//:: FileName  mys_black_cndl.nss
//:://////////////////////////////////////////////
/**@file BLACK CANDLE
Fundamental
Level/School: 1st/Evocation [Light or Darkness]
Range: Touch
Target: Object touched
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: No

This mystery functions like the spell light or the spell darkness. Only one of 
these two effects is possible per use, and you must decide which effect is desired 
when casting.

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