#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    if (GetLocalInt(oSkin, "PsionicFocus") == 1)
    {
        SetCompositeBonus(oSkin, "PsionicDodge", 1, ITEM_PROPERTY_AC_BONUS);
        return;
    }
    
    SetCompositeBonus(oSkin, "PsionicDodge", 0, ITEM_PROPERTY_AC_BONUS);
}
