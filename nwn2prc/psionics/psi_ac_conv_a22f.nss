// Sets the option Energy Bolt - Fire active on the AC being edited 


#include "psi_inc_ac_const"
#include "psi_inc_ac_convo"


void main()
{
    object oPC = GetPCSpeaker();
    int nFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT);
        nFlags |= ASTRAL_CONSTRUCT_OPTION_ENERGY_BOLT;
    int nElemFlags = GetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS + EDIT);
        nElemFlags |= ELEMENT_FIRE;
    
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_OPTION_FLAGS + EDIT, nFlags);
    SetLocalInt(oPC, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS + EDIT, nElemFlags);
}
