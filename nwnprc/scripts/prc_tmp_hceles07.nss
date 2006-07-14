/*

 Half-Celestial Template SLA script

*/

#include "prc_alterations"
#include "prc_inc_smite"


void main()
{       
    DoRacialSLA(SPELL_NEUTRALIZE_POISON, GetHitDice(OBJECT_SELF));
}