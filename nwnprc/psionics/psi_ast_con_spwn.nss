//::///////////////////////////////////////////////
//:: Astral Construct OnSpawn eventscript
//:: psi_ast_con_spwn
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.01.2005
//:://////////////////////////////////////////////

#include "psi_inc_ac_spawn"

void main()
{
    object oSpawn = OBJECT_SELF;

    // Handle the main Astral Construct spawn stuff
    // Farmed out to an include file. This one is just to link it
    // and the default spawn handling
    HandleAstralConstructSpawn(oSpawn);
    
    // Execute other OnSpawn stuff
    ExecuteScript("nw_ch_acani9", OBJECT_SELF);
}
