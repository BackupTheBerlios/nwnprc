//::///////////////////////////////////////////////
//:: Astral Construct Psion script for slot 1
//:: psi_psi_astcon1
//:://////////////////////////////////////////////
/*
    Astral Construct
    
    Metacreativity (Creation)
    Level: Shaper 1
    Range: Close (25 ft. + 5 ft./2 levels)
    Duration: 1 round/level
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 1
    
    This power creates one 1st-level astral construct of
    solidified ectoplasm that attacks your enemies.
    It appears where you designate.
    
    Astral constructs are not summoned; they are created
    on the plane you inhabit (using ectoplasm drawn from
    the Astral Plane). Thus, they are not subject to
    effects that hedge out or otherwise affect outsiders;
    they are constructs, not outsiders.
    
    Augment: For every 2 additional power points you
    spend, the level of the astral construct increases
    by one.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 08.03.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"

void main()
{
    UsePower(POWER_ASTRALCONSTRUCT_SLOT1, CLASS_TYPE_PSION);
}