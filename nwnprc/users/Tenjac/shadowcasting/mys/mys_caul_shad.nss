//::///////////////////////////////////////////////
//:: Name      Caul of Shadow
//:: FileName  sp_caul_shad.nss                 
//:://////////////////////////////////////////////
/**@file CAUL OF SHADOW
Fundamental
Level/School: 1st/Abjuration
Range: Personal
Target: You
Duration: 1 minute/level

Caul of shadow faintly darkens your form, but does not provide
any bonuses on Hide checks or similar efforts. You gain a +1
deflection bonus to AC, with an additional +1 for every six
caster levels (maximum bonus +4).

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