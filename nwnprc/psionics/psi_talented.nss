//::///////////////////////////////////////////////
//:: Talented feat spellscript
//:: psi_talented
//::///////////////////////////////////////////////
/*
    Switches the feat Talented on or off.
    When on, overchanneling a power of 3rd or
    lower level does not cause damage.
    That happening requires expending psionic focus.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 22.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Can't activate too many feats
    if(!GetLocalInt(oPC, "TalentedActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "TalentedActive", !GetLocalInt(oPC, "TalentedActive"));
    FloatingTextStringOnCreature("Talented " + (GetLocalInt(oPC, "TalentedActive") ? "Activated":"Deactivated"), oPC, FALSE);
}