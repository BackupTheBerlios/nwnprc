/////////////////////////////////////////////////
// Crusader Smite 
//-----------------------------------------------
// Created By: Stratovarius
/////////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_smite"

void main()
{       
    DoSmite(OBJECT_SELF, GetSpellTargetObject(), SMITE_TYPE_GOOD_ANTIPALADIN);
}    
