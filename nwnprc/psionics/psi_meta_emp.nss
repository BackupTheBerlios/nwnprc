//::///////////////////////////////////////////////
//:: Empower Power switch
//:: psi_meta_emp
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Empower Power on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaEmpower") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaEmpower", !GetLocalInt(oPC, "PsiMetaEmpower"));
    FloatingTextStringOnCreature("Empower Power " + (GetLocalInt(oPC, "PsiMetaEmpower") ? "Activated":"Deactivated"), oPC, FALSE);
}