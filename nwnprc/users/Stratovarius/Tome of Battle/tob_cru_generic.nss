/*
    generic maneuver calling function
*/
#include "tob_inc_tobfunc"

void main()
{
    UseManeuver(GetPowerFromSpellID(PRCGetSpellId()), CLASS_TYPE_CRUSADER);
}