//::///////////////////////////////////////////////
//:: Widen Power switch
//:: psi_meta_widen
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Widen Power on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaWiden") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaWiden", !GetLocalInt(oPC, "PsiMetaWiden"));
    FloatingTextStringOnCreature("Widen Power " + (GetLocalInt(oPC, "PsiMetaWiden") ? "Activated":"Deactivated"), oPC, FALSE);
}