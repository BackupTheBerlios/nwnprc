//::///////////////////////////////////////////////
//:: Extend Power switch
//:: psi_meta_extend
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Extend Power on or off.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 25.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Can't activate too many feats
    if(!GetLocalInt(oPC, "PsiMetaExtend") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaExtend", !GetLocalInt(oPC, "PsiMetaExtend"));
    FloatingTextStringOnCreature("Extend Power " + (GetLocalInt(oPC, "PsiMetaExtend") ? "Activated":"Deactivated"), oPC, FALSE);
}