//::///////////////////////////////////////////////
//:: (Greater) Psionic Endowment spellscript
//:: psi_psionic_endw
//::///////////////////////////////////////////////
/*
    Switches the feat Psionic Endowment on or off.
    When on, the creature gains +2 to power DC
    If the creature has the feat Greater Psionic Endowment,
    the bonus is instead +4.
    
    Using Psionic Endowment requires expending
    psionic focus during the power's manifestation.
*/
//:://////////////////////////////////////////////
//:: Modified By: Ornedan
//:: Modified On: 22.03.2005
//:://////////////////////////////////////////////


#include "prc_inc_function"
#include "inc_item_props"
#include "prc_feat_const"
#include "psi_inc_psifunc"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Can't activate too many feats
    if(!GetLocalInt(oPC, "PsionicEndowmentActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PsionicEndowmentActive", !GetLocalInt(oPC, "PsionicEndowmentActive"));
    FloatingTextStringOnCreature((GetHasFeat(FEAT_GREATER_PSIONIC_ENDOWMENT, oPC) ? "Greater":"") + 
                                 "Psionic Endowment " + (GetLocalInt(oPC, "PsionicEndowmentActive") ? "Activated":"Deactivated"), oPC, FALSE);
}