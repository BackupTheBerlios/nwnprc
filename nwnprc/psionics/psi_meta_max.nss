//::///////////////////////////////////////////////
//:: Mazimize Power switch
//:: psi_meta_max
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Mazimize Power on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaMax") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaMax", !GetLocalInt(oPC, "PsiMetaMax"));
    FloatingTextStringOnCreature("Mazimize Power " + (GetLocalInt(oPC, "PsiMetaMax") ? "Activated":"Deactivated"), oPC, FALSE);
}