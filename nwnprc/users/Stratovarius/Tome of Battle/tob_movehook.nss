//::///////////////////////////////////////////////
//:: Tome of Battle Maneuver Hook File.
//:: tob_movehook.nss
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the maneuver scripts for Tome of Battle

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 19-3-2007
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "inc_utility"

// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int PreManeuverCastCode();


//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int PreManeuverCastCode()
{
    object oInitiator = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nContinue;

    DeleteLocalInt(oInitiator, "SpellConc");
    nContinue = !ExecuteScriptAndReturnInt("premovecode",oInitiator);

    //---------------------------------------------------------------------------
    // Run NullPsionicsField Check - Adjust so only Supernatural Maneuvers are affected
    //---------------------------------------------------------------------------
    if (nContinue && TOBGetIsManeuverSupernatural)
        nContinue = NullPsionicsField();

    return nContinue;
}

