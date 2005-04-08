//::///////////////////////////////////////////////
//:: Soulknife: Psychic Strike
//:: psi_sk_psychstrk
//::///////////////////////////////////////////////
/*
    Charges the mindblade. Next hit against a
    living, non-mindless creature will deal extra
    dice of damage based on SK level.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"


void main()
{
    object oPC = OBJECT_SELF;
    
    if(!GetLocalInt(oPC, PSYCHIC_STRIKE))
        SetLocalInt(oPC, PSYCHIC_STRIKE, TRUE);
    else
        SendMessageToPCByStrRef(oPC, 16824498);
}