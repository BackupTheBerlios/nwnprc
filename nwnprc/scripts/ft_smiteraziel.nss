
/*

 Fist of Raziel Smite Evil script

*/


#include "prc_alterations"
#include "prc_inc_smite"


void main()
{       
    DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_EVIL_FIST_OF_RAZIEL);
}