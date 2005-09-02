//:://////////////////////////////////////////////
//:: Teleportation Circle OnEnter
//:: sp_telecircle_oe
//:://////////////////////////////////////////////
/** @file Teleportation Circle OnEnter
 * This script is fired by an area of effect that
 * acts as the circle resulting from a Teleportation
 * Circle spell.
 * On it's first run, it gets the location it is
 * supposed to teleport the enterer to from the caster.
 * Either way, the creature that just entered the circle
 * is jumped to the destination.
 *
 *
 * @author Ornedan
 * @date   Created - 21.09.2005
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_teleport"
#include "inc_vfx_const"
#include "x0_i0_position"


void main()
{
    object oAOE = OBJECT_SELF;

    // Check whether the circle has gotten it's target yet. If not, grab it now
    if(!GetLocalInt(oAOE, "INIT_DONE"))
    {
        object oCreator = GetAreaOfEffectCreator();
SendMessageToPC(oCreator, "Getting circle data");
        SetLocalLocation(oAOE, "Target_Location",
                         GetLocalLocation(oCreator, "PRC_Spell_TeleportCircle_TargetLocation")
                         );
SendMessageToPC(oCreator, "Got location: " + LocationToString(GetLocalLocation(oCreator, "PRC_Spell_TeleportCircle_TargetLocation")));
SendMessageToPC(oCreator, "Stored location: " + LocationToString(GetLocalLocation(oAOE, "Target_Location")));
        DeleteLocalLocation(oCreator, "PRC_Spell_TeleportCircle_TargetLocation");

        // Release the lock on casting more teleportation circles now that the newest one has gotten it's data out of the way
        DeleteLocalInt(oCreator, "PRC_Spell_TeleportationCircle_Lock");

        SetLocalInt(oAOE, "INIT_DONE", TRUE);
    }

    // Get the creature to teleport and the location to move it to
    object oTarget = GetEnteringObject();
    location lTarget = GetLocalLocation(oAOE, "Target_Location");
SendMessageToPC(oTarget, "Teleporting you to " + LocationToString(lTarget));

    // Assign the jump if the target can be teleported
    if(GetCanTeleport(oTarget, lTarget))
        DelayCommand(0.5f, AssignCommand(oTarget, JumpToLocation(lTarget)));

    /// @todo: Some neat VFX here. Maybe the conjuration pillar effect?
    // Some VFX at the location the creature suddenly disappears from
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_CONJ_MIND), GetLocation(oTarget), 2.0f);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_CONJ_MIND), GetLocation(oTarget));
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_CONJ_MIND), oTarget);
}