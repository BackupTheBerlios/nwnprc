//::///////////////////////////////////////////////
//:: Spell: Dimension Door
//:: sp_dimens_door
//::///////////////////////////////////////////////
/** @ file
    Dimension Door

    Conjuration (Teleportation)
    Level: Brd 4, Sor/Wiz 4, Travel 4
    Components: V
    Casting Time: 1 standard action
    Range: Long (400 ft. + 40 ft./level)
    Target: You and other touched willing creatures (ie. party members within 10ft of you)
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired—whether by simply visualizing the area or by
    stating direction**. You may also bring one additional willing Medium or smaller creature
    or its equivalent per three caster levels. A Large creature counts as two Medium creatures,
    a Huge creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
    * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
    ** The direction is the same as the direction of where you target the spell relative to you.
       A listener will be created so you can say the distance.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.07.2005
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"
#include "inc_draw"
#include "prc_inc_listener"
#include "x0_i0_position"

const int SPELLID_TELEPORT_SELF_ONLY         = 2891;
const int SPELLID_TELEPORT_PARTY             = 2892;
const int SPELLID_TELEPORT_SELF_ONLY_DIRDIST = 2896;
const int SPELLID_TELEPORT_PARTY_DIRDIST     = 2897;


location GetDimensionDoorLocation(object oCaster, int nCasterLvl, location lBaseTarget, float fDistance)
{
//SendMessageToPC(oCaster, "Debug: Running GetDimensionDoorLocation(" + GetName(oCaster) + ", " + IntToString(nCasterLvl) + ", " + LocationToString(lBaseTarget) + ", " + FloatToString(fDistance) + ")");
    // First, check if we are using the Direction & Distance mode
    if(fDistance != 0.0f)
    {
//SendMessageToPC(oCaster, "Debug: Calculating the new location based on direction and distance");
        // Make sure the distance jumped is in range
        if(fDistance > FeetToMeters(400.0 + 40.0 * nCasterLvl))
        {
            fDistance = FeetToMeters(400.0 + 40.0 * nCasterLvl);
            string sPretty = FloatToString(fDistance);
                   sPretty = GetSubString(sPretty, 0, FindSubString(sPretty, ".") + 2); // Trunctate decimals to the last two
            //                      "You can't teleport that far, distance limited to"
            SendMessageToPC(oCaster, GetStringByStrRef(16825210) + " " + sPretty);
        }
        location lCaster   = GetLocation(oCaster);
        vector vCaster     = GetPositionFromLocation(lCaster);
        vector vBaseTarget = GetPositionFromLocation(lBaseTarget);
//SendMessageToPC(oCaster, "Debug: Calling acos((" + FloatToString(vBaseTarget.x) + " - " + FloatToString(vCaster.x) + ") / " + FloatToString(GetDistanceBetweenLocations(lCaster, lBaseTarget)) + ")");
        float fAngle       = acos((vBaseTarget.x - vCaster.x) / GetDistanceBetweenLocations(lCaster, lBaseTarget));
        // The above formula only returns values [0, 180], so it needs to be mirrored if the caster is moving towards negative y
        if((vBaseTarget.y - vCaster.y) < 0.0f)
            fAngle         = -fAngle;
//SendMessageToPC(oCaster, "Debug: Angle is " + FloatToString(fAngle));
        vector vTarget     = Vector(vCaster.x + cos(fAngle) * fDistance,
                                    vCaster.y + sin(fAngle) * fDistance,
                                    vCaster.z
                                    );
        // Sanity checks to make sure the location is not out of map bounds in the negative direction.
        if(vTarget.x < 0.0f) vTarget.x = 0.0f;
        if(vTarget.y < 0.0f) vTarget.y = 0.0f;

        return Location(GetAreaFromLocation(lBaseTarget), vTarget, GetFacingFromLocation(lBaseTarget));
    }
    else if(GetHasTeleportQuickSelection(oCaster, PRC_TELEPORT_ACTIVE_QUICKSELECTION))
    {
//SendMessageToPC(oCaster, "Debug: Quickselect is active");
        location lTest = MetalocationToLocation(GetActiveTeleportQuickSelection(oCaster, FALSE));

        if(GetArea(oCaster) == GetAreaFromLocation(lTest))
        {
//SendMessageToPC(oCaster, "Debug: Quickselect is in same area");
            if(GetDistanceBetweenLocations(GetLocation(oCaster), lTest) <= FeetToMeters(400.0 + 40.0 * nCasterLvl))
            {
//SendMessageToPC(oCaster, "Debug: Quickselect is in range");
                // Used the active quickselection, so clear it
                RemoveTeleportQuickSelection(oCaster, PRC_TELEPORT_ACTIVE_QUICKSELECTION);
                return lTest;
            }
        }
    }

    // Just return the spell's base target location
    return lBaseTarget;
}

void DoDimensionDoor(object oCaster, int nSpellID, location lTarget)
{
    location lCaster = GetLocation(oCaster);
    object oTarget;
    int i;

    // Check if it's valid for the caster to teleport. If he can't go, no-one goes
    if(GetCanTeleport(oCaster, lTarget))
    {
        // Loop over the targets, checking if they can teleport. Redundant check on the caster, but shouldn't cause any trouble
        for(i = 0; i < array_get_size(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY); i++)
        {
            oTarget = array_get_object(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY, i);
            if(GetCanTeleport(oTarget, lTarget))
            {
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oTarget, 0.55));
                DelayCommand(1.5, AssignCommand(oTarget, JumpToLocation(lTarget)));
            }
        }

        // VFX //
        //DrawLineFromCenter(DURATION_TYPE_INSTANT, VFX_IMP_WIND, lCenter, 21.0, 0.0, 0.0, 29, 2.0, "z");
        //BeamPolygon(1, 73, lCenter, 5.0, 8, 3.0, "invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);

        // Make the caster animate for the second of delay
        AssignCommand(oCaster, ClearAllActions());
        AssignCommand(oCaster, SetFacingPoint(GetPositionFromLocation(lTarget)));
        AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 1.0f));

        // First, spawn a circle of ligntning around the caster
        BeamPolygon(DURATION_TYPE_PERMANENT, VFX_BEAM_LIGHTNING, lCaster,
                    nSpellID == SPELLID_TELEPORT_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
                    nSpellID == SPELLID_TELEPORT_PARTY ? 15 : 10, // More nodes for the group VFX
                    1.5, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);


        //BeamPolygon(1, 73, lCaster, 5.0, 8, 3.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);

        // After a moment, draw a line from the caster to the destination
        DelayCommand(1.0, DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oCaster), GetPositionFromLocation(lCaster), GetPositionFromLocation(lTarget), 0.0,
                                                     FloatToInt(GetDistanceBetweenLocations(lCaster, lTarget)), // One VFX every 5 meters
                                                     0.5));
        // Then, spawn a circle of ligtning at the destination
        DelayCommand(0.5, BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lTarget,
                          nSpellID == SPELLID_TELEPORT_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0),
                          nSpellID == SPELLID_TELEPORT_PARTY ? 15 : 10,
                          1.5, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0));
    }

    // Cleanup
    array_delete(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY);
}

void CleanLocals(object oCaster)
{
    DeleteLocalInt     (oCaster, "PRC_Spell_DimensionDoor_SpellID");
    DeleteLocalInt     (oCaster, "PRC_Spell_DimensionDoor_CasterLvl");
    DeleteLocalLocation(oCaster, "PRC_Spell_DimensionDoor_Location");
    DeleteLocalFloat   (oCaster, "PRC_Spell_DimensionDoor_Distance");
    DeleteLocalInt     (oCaster, "PRC_Spell_DimensionDoor_FirstStageDone");
}

void main()
{
//SendMessageToPC(OBJECT_SELF, "Running sp_dimens_door");
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    /* Main spellscript */
    object oCaster   = OBJECT_SELF;
    if(!GetLocalInt(oCaster, "PRC_Spell_DimensionDoor_FirstStageDone"))
    {
        // Spellhook
        if(!X2PreSpellCastCode()) return;
        int nCasterLvl   = PRCGetCasterLevel();
        int nSpellID     = GetSpellId();
        // Get the spell's base target location
        location lTarget = GetIsObjectValid(GetSpellTargetObject()) ? // Are we teleporting to some object, or just at a spot on the ground?
                            GetLocation(GetSpellTargetObject()) :     // Teleporting to some object
                            GetSpellTargetLocation();                 // Teleporting to a spot on the ground


        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oCaster, nCasterLvl,
                              nSpellID == SPELLID_TELEPORT_PARTY ||
                              nSpellID == SPELLID_TELEPORT_PARTY_DIRDIST
                              );

        if(nSpellID == SPELLID_TELEPORT_SELF_ONLY ||
           nSpellID == SPELLID_TELEPORT_PARTY
           )
        {
            SetLocalInt(oCaster, "PRC_Spell_DimensionDoor_FirstStageDone", TRUE);
        }
        else
        {
            SpawnListener("sp_dimens_door_b", GetLocation(oCaster), "**", oCaster, 10.0f);
            SendMessageToPCByStrRef(oCaster, 16825211); // "You have 10 seconds to speak the distance (in meters)"
            DelayCommand(10.0f, CleanLocals(oCaster));
        }

        // Store the location in either case. For the direction and distance version, it's used to determine direction.
        SetLocalLocation(oCaster, "PRC_Spell_DimensionDoor_Location", lTarget);

        // Store the spellID and caster level for use in DoDimensionDoor()
        SetLocalInt(oCaster, "PRC_Spell_DimensionDoor_SpellID", nSpellID);
        SetLocalInt(oCaster, "PRC_Spell_DimensionDoor_CasterLvl", nCasterLvl);
    }
    if(GetLocalInt(oCaster, "PRC_Spell_DimensionDoor_FirstStageDone"))
    {
       DoDimensionDoor(oCaster,
                        GetLocalInt(oCaster, "PRC_Spell_DimensionDoor_SpellID"),
                        GetDimensionDoorLocation(oCaster,
                                                 GetLocalInt(oCaster, "PRC_Spell_DimensionDoor_CasterLvl"),
                                                 GetLocalLocation(oCaster, "PRC_Spell_DimensionDoor_Location"),
                                                 GetLocalFloat(oCaster, "PRC_Spell_DimensionDoor_Distance")
                                                 )
                        );
        CleanLocals(oCaster);
    }

    // Cleanup
    SPSetSchool();
}