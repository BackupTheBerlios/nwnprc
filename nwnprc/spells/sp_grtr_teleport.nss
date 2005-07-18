//::///////////////////////////////////////////////
//:: Greater Teleport spellscript
//:: sp_grtr_teleport
//:://////////////////////////////////////////////
/** @file
    Teleport, Greater

    Conjuration (Teleportation)
    Level: Sor/Wiz 7, Travel 7
    Components: V
    Casting Time: 1 standard action
    Range: Personal and touch
    Target: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None and Will negates (object)
    Spell Resistance: No and Yes (object)

    This spell instantly transports you to a designated destination. You may also
    bring one additional willing Medium or smaller creature or its equivalent per
    three caster levels. A Large creature counts as two Medium creatures, a Huge
    creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 24.06.2005
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"

const int SPELLID_TELEPORT_SELF_ONLY = -1; /// @TODO
const int SPELLID_TELEPORT_PARTY     = -1; /// @TODO
/*
VFX:
At the end of the first stage, create:
 For single: A vertical circle in front of the caster
 For Party: A hemisphere of 10' radius.

These last until the second stage starts or 120s, whichever ends sooner.
*/

void main()
{//TODO: Prespellcodehook, preteleportcodehook, school setting. Maybe do these in the first part? Spellhook probably shouldn't run twice.
    // Set the spell school
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    /* Main script */
    object oCaster = OBJECT_SELF;
SendMessageToPC(oCaster, "Running Greater Teleport");
    // Get whether we are executing the first or the second part of the script
    if(!GetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone"))
    {
SendMessageToPC(oCaster, "First part");
        // Spellhook
        if(!X2PreSpellCastCode()) return;    
SendMessageToPC(oCaster, "Passed spellhook");
        int nCasterLvl = PRCGetCasterLevel();
        int nSpellID   = GetSpellId();

SendMessageToPC(oCaster, "CLvl: " + IntToString(nCasterLvl));
SendMessageToPC(oCaster, "SID: " + IntToString(nSpellID));

        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oCaster, nCasterLvl, nSpellID == SPELLID_TELEPORT_PARTY);

        /// @TODO: VFX here
        
        // Mark the first part done
        SetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone", TRUE);
SendMessageToPC(oCaster, "Getting location");
        // Now, get the location to teleport to.
        ChooseTeleportTargetLocation(oCaster, "sp_grtr_teleport", "PRC_Spell_GreaterTeleport_TargetLocation", FALSE, TRUE);
SendMessageToPC(oCaster, "Returned from location getter");
    }
    // We now have the location and the list of targets. Jump away.
    else
    {
        // Retrieve the target location from the variable
        location lTarget = GetLocalLocation(oCaster, "PRC_Spell_GreaterTeleport_TargetLocation");
        int i;
        object oTarget;
SendMessageToPC(oCaster, "Second part");
        /// @TODO: Terminate VFX from the first stage here

        // Check if it's valid for the caster to teleport. If he can't go, no-one goes
        if(GetCanTeleport(oCaster, lTarget))
        {
SendMessageToPC(oCaster, "Can teleport");
            // Loop over the targets, checking if they can teleport. Redundant check on the caster, but shouldn't cause any trouble
            for(i = 0; i < array_get_size(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY); i++)
            {
                oTarget = array_get_object(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY, i);
                if(GetCanTeleport(oTarget, lTarget))
                {
                    DelayCommand(1.0f, AssignCommand(oTarget, JumpToLocation(lTarget)));
SendMessageToPC(oCaster, GetName(oTarget) + " jumping");
                }
            }


            /// @TODO: VFX at arrival location. Make a few seconds long so the teleporters get to see at least a bit
            ///        even if they get loading screens. Use gaoneng's stuff.
        }

        // Cleanup
        DeleteLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone");
        DeleteLocalLocation(oCaster, "PRC_Spell_GreaterTeleport_TargetLocation");
        array_delete(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY);
    }

    SPSetSchool();
}


/*
void main()
{   
    SPSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main spellscript
    object oCaster   = OBJECT_SELF;
    object oTarget;
    int nCasterLvl   = PRCGetCasterLevel();
    int nSpellID     = GetSpellId();
    int i;
    location lTarget = GetDimensionDoorLocation(oCaster, nCasterLvl);
    location lCaster = GetLocation(oCaster);
    // Run the code to build an array of targets on the caster
    GetTeleportingObjects(oCaster, nCasterLvl, nSpellID == SPELLID_TELEPORT_PARTY);
    
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
                    15, 1.5, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);
        
        
        //BeamPolygon(1, 73, lCaster, 5.0, 8, 3.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);

        // After a moment, draw a line from the caster to the destination
        DelayCommand(1.0, DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oCaster), GetPositionFromLocation(lCaster), GetPositionFromLocation(lTarget), 0.0,
                                                     FloatToInt(GetDistanceBetweenLocations(lCaster, lTarget)), // One VFX every 5 meters
                                                     0.5));
        // Then, spawn a circle of ligtning at the destination
        DelayCommand(0.5, BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lTarget, nSpellID == SPELLID_TELEPORT_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), 15, 2.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0));
    }

    // Clean the school variable
    SPSetSchool();
}*/