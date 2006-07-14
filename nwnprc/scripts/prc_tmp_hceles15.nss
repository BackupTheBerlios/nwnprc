/*

 Half-Celestial Template SLA script

*/

#include "prc_alterations"
#include "prc_inc_smite"


void main()
{       
    DoRacialSLA(SPELL_SUMMON_CREATURE_IX, GetHitDice(OBJECT_SELF));
}