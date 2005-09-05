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
#include "inc_utility"

const int SPELLID_TELEPORT_SELF_ONLY = 2894;
const int SPELLID_TELEPORT_PARTY     = 2895;

void VFX_HB(object oCaster, location lCaster)
{
    // End the VFX once the caster either finishes the spell or moves
    if(GetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone") && GetLocation(oCaster) == lCaster)
    {
        // Draw to circles, going in the opposite directions
        DrawCircle(DURATION_TYPE_INSTANT, VFX_IMP_CONFUSION_S, lCaster, FeetToMeters(10.0f), 0.0, 100, 1.0, 6.0, 0.0, "z");
        DrawCircle(DURATION_TYPE_INSTANT, VFX_IMP_CONFUSION_S, lCaster, FeetToMeters(10.0f), 0.0, 100, 1.0, 6.0, 180.0, "z");
        DelayCommand(6.0f, VFX_HB(oCaster, lCaster));
    }
}

void main()
{
    // Set the spell school
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    /* Main script */
    object oCaster   = OBJECT_SELF;
    //object oVFXKeeper;
    location lCaster = GetLocation(oCaster);

    // Get whether we are executing the first or the second part of the script
    if(!GetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone"))
    {
        // Spellhook
        if(!X2PreSpellCastCode()) return;
        int nCasterLvl = PRCGetCasterLevel();
        int nSpellID   = GetSpellId();

        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oCaster, nCasterLvl, nSpellID == SPELLID_TELEPORT_PARTY);

        // Do VFX while waiting for the location select. Only for party TP
        if(nSpellID == SPELLID_TELEPORT_PARTY)
            //oVFXKeeper = ObjectPlaceHemisphere("prc_invisobj", lCaster, 0.0, 4.0, 2.3, 0.0, 75, 5.0, 0.0, 6.0, "z", 2, 479, 0.0, 1.0, 7.0);
            DelayCommand(0.01f, VFX_HB(oCaster, lCaster));

        /* DEPRECATED
        // Store the reference holder object so that the group can be destroyed once the spell is done
        SetLocalObject(oCaster, "PRC_Spell_GreaterTeleport_VFXKeeper", oVFXKeeper);
        // Schedule the group to be destroyed in 1.5 mins no matter what to prevent the VFX from sticking around forever
        DelayCommand(90.0f, GroupDestroyObject(oVFXKeeper, 0.0f, 0.5f, FALSE));*/

        // Mark the first part done
        SetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone", TRUE);
        // Now, get the location to teleport to.
        ChooseTeleportTargetLocation(oCaster, "sp_grtr_teleport", "PRC_Spell_GreaterTeleport_TargetLocation", FALSE, TRUE);
    }
    // We now have the location and the list of targets. Jump away.
    else
    {
        // Retrieve the target location from the variable
        location lTarget = GetLocalLocation(oCaster, "PRC_Spell_GreaterTeleport_TargetLocation");
        int i;
        object oTarget;
        /* DEPRECATED
        // Terminate VFX from the first stage here
        oVFXKeeper = GetLocalObject(oCaster, "PRC_Spell_GreaterTeleport_VFXKeeper");
        GroupDestroyObject(oVFXKeeper, 0.0f, 0.5f, FALSE);*/

        // Check if it's valid for the caster to teleport. If he can't go, no-one goes
        if(GetCanTeleport(oCaster, lTarget))
        {
            // VFX on the starting location
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TELEPORT_OUT), lCaster);

            // Loop over the targets, checking if they can teleport. Redundant check on the caster, but shouldn't cause any trouble
            for(i = 0; i < array_get_size(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY); i++)
            {
                oTarget = array_get_object(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY, i);
                if(GetCanTeleport(oTarget, lTarget))
                {
                    DelayCommand(1.0f, AssignCommand(oTarget, JumpToLocation(lTarget)));
                }
            }

            // VFX at arrival location. May run out before the teleporting people arrive
            DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_TELEPORT_IN), lTarget));
            //DrawRhodonea(0, VFX_IMP_MAGBLUE, lCaster, 4.0, 0.4, 0.0, 110, 5.0, 0.0, 0.0, "z");
        }

        // Cleanup
        DeleteLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone");
        DeleteLocalLocation(oCaster, "PRC_Spell_GreaterTeleport_TargetLocation");
        array_delete(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY);
    }

    SPSetSchool();
}
