//::///////////////////////////////////////////////
//:: Power Specialization spellscript
//:: psi_power_spec
//::///////////////////////////////////////////////
/*
    Switches the feat Power Specialization on or off.
    When on, the creature gains a bonus to damage
    with ray and ranged touch attack powers equal
    to it's manifesting stat.
    When off, the bonus is 2.
    Using Power Specialization in the active way
    requires expending psionic focus during the
    power's manifestation.
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
    if(!GetLocalInt(oPC, "PowerSpecializationActive") &&
       GetPsionicFocusUsingFeatsActive(oPC) >= GetPsionicFocusUsesPerExpenditure(oPC))
    {
        FloatingTextStringOnCreature("You cannot activate more feats that require psionic focus", oPC, FALSE);
        return;
    }
    
    SetLocalInt(oPC, "PowerSpecializationActive", !GetLocalInt(oPC, "PowerSpecializationActive"));
    FloatingTextStringOnCreature("Power Specialization " + (GetLocalInt(oPC, "PowerSpecializationActive") ? "Activated":"Deactivated"), oPC, FALSE);
}