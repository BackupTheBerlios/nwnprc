#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    
    if (GetLocalInt(oPC, "PsionicFocus") == 1)
    {
        SetCompositeBonus(oPC, "PsionicDodge", 1, ITEM_PROPERTY_AC_BONUS);
        return;
    }
    
    SetCompositeBonus(oPC, "PsionicDodge", 0, ITEM_PROPERTY_AC_BONUS);
}
