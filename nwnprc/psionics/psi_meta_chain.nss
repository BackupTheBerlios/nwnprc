//::///////////////////////////////////////////////
//:: Chain Power switch
//:: psi_meta_chain
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Chain Power on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaChain") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaChain", !GetLocalInt(oPC, "PsiMetaChain"));
    FloatingTextStringOnCreature("Chain Power " + (GetLocalInt(oPC, "PsiMetaChain") ? "Activated":"Deactivated"), oPC, FALSE);
}