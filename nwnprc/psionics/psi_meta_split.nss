//::///////////////////////////////////////////////
//:: Split Psionic Ray switch
//:: psi_meta_split
//::///////////////////////////////////////////////
/*
    Switches the metapsionic feat Split Psionic Ray on or off.
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
    if(!GetLocalInt(oPC, "PsiMetaSplit") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsiMetaSplit", !GetLocalInt(oPC, "PsiMetaSplit"));
    FloatingTextStringOnCreature("Split Psionic Ray " + (GetLocalInt(oPC, "PsiMetaSplit") ? "Activated":"Deactivated"), oPC, FALSE);
}