//::///////////////////////////////////////////////
//:: Twin Power switch
//:: psi_meta_twin
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Twin Power on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaTwin") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaTwin", !GetLocalInt(oPC, "PsiMetaTwin"));
    FloatingTextStringOnCreature("Twin Power " + (GetLocalInt(oPC, "PsiMetaTwin") ? "Activated":"Deactivated"), oPC, FALSE);
}