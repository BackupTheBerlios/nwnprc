//::///////////////////////////////////////////////
//:: Teleport, Psionic Greater spellscript
//:: psi_pow_gtele
//:://////////////////////////////////////////////
/** @file
    Teleport, Psionic Greater

    Psychoportation (Teleportation)
    Level: Psion/wilder 8
    Display: Visual
    Manifesting Time: 1 standard action
    Range: Personal and touch
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None or Will negates (object)
    Power Resistance: No or Yes (object)
    Power Points: 15

    This powerinstantly transports you to a designated destination. You may also bring one additional
    willing Medium or smaller creature or its equivalent per three manifester levels. A Large creature
    counts as two Medium creatures, a Huge creature counts as two Large creatures, and so forth. All
    creatures to be transported must be in contact with you. *

    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.

*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.08.2005
//:://////////////////////////////////////////////

#include "psi_inc_psifunc"
#include "psi_spellhook"
#include "prc_inc_teleport"
#include "inc_draw"

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
    /* Main script */
    object oCaster   = OBJECT_SELF;
    //object oVFXKeeper;
    location lCaster = GetLocation(oCaster);

    // Get whether we are executing the first or the second part of the script
    if(!GetLocalInt(oCaster, "PRC_Spell_GreaterTeleport_FirstPartDone"))
    {
        // Spellhook
        if(!PsiPrePowerCastCode()) return;

        // Check if can manifest
        if(!GetCanManifest(oCaster, 0, OBJECT_INVALID, 0, 0, 0, 0, 0, 0, 0))
            return;

        int nManifesterLvl = GetManifesterLevel();
        int nSpellID       = GetSpellId();

        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oCaster, nManifesterLvl, nSpellID == POWER_GREATER_TELEPORT_PARTY);

        // Do VFX while waiting for the location select. Only for party TP
        if(nSpellID == POWER_GREATER_TELEPORT_PARTY)
            //oVFXKeeper = ObjectPlaceHemisphere("prc_invisobj", lCaster, 0.0, 4.0, 2.3, 0.0, 75, 5.0, 0.0, 6.0, "z", 2, 479, 0.0, 1.0, 7.0);
            DelayCommand(0.01f, VFX_HB(oCaster, lCaster));

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
}
