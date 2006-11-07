/*

 Celestial Template Smite Evil script

*/

#include "prc_alterations"
#include "prc_inc_smite"


void main()
{       
    DoSmite(OBJECT_SELF, PRCGetSpellTargetObject(), SMITE_TYPE_EVIL_TEMPLATE_CELESTIAL);
}