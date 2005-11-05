//::///////////////////////////////////////////////
//:: Spell Include: Teleport
//:: spinc_teleport
//::///////////////////////////////////////////////
/** @file
    Handles the internal functioning of the (Greater)
    Teleport -type spells, powers and SLAs.

    @author Ornedan
    @date   Created - 2005.11.04
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

// Internal constants
const string TP_LOCATION         = "PRC_GreaterTeleport_TargetLocation";
const string TP_ERRORLESS        = "PRC_GreaterTeleport_Errorless";
const string TP_FIRSTSTAGE_DONE  = "PRC_GreaterTeleport_FirstPartDone";

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Runs the using of a Dimension Door (-like) spell / power / SLA.
 * The target location is either the location of a target object gotten
 * with PRCGetSpellTargetObject() or if the target was a location on the
 * ground, PRCGetSpellTargetLocation(). The actual target location may
 * be different if bUseDirDist is TRUE.
 *
 * @param oCaster       The creature using a spell / power / SLA to Dimension Door
 * @param nCasterLvl    The creature's caster / manifester level in regards to this use
 * @param nSpellID      The spellID currently in effect. If not specified, PRCGetSpellId()
 *                      will be used to retrieve it.
 * @param sScriptToCall Optionally, a script may be ExecuteScript'd for each of the teleportees
 *                      after they have reached their destination. This is used to specify
 *                      the name of such script.
 *
 * @param bSelfOrParty  Determines whether this use of Dimension Door teleports only oCaster or
 *                      also all it's faction memers within 10ft radius (subject to the general
 *                      teleporting carry limits).
 *                      Valid values: DIMENSIONDOOR_SELF and DIMENSIONDOOR_PARTY
 *
 * @param bUseDirDist   If TRUE, the target location of the spell given via targeting cursor
 *                      is used only to specify the direction of actual target location,
 *                      relative to oCaster, and distance is specified via a listener.
 *                      Otherwise, the target location specified via targeting cursor is used
 *                      as the actual target.
 */
void DimensionDoor(object oCaster, int nCasterLvl, int nSpellID = -1, string sScriptToCall = "",
                   int bSelfOrParty = DIMENSIONDOOR_SELF, int bUseDirDist = FALSE
                   );


/********************\
* Internal Functions *
\********************/

/**
 * Extracts data from local variables, calls DoDimensionDoorTeleport() using
 * that data and then does CleanLocals().
 *
 * @param oCaster  creature using Dimension Door
 */
void DimensionDoorAux(object oCaster);

/**
 * Determines the target location of a Dimension Door. If using the
 * direction & distance listener trick, the direction of the location
 * is calculated from the base target location and distance is based
 * on the caster's speech.
 * Otherwise, the base target location is used.
 *
 * @param oCaster     creature using Dimension Door
 * @param nCasterLvl  oCaster's caster or manifester level in regards to this
 *                    Dimension Door use
 * @param lBaseTarget the base target location, obtained via normal targeting
 * @param fDistance   the distance specified by speech for the direction &
 *                    distance trick. If this is 0.0f, the trick is not used.
 *
 * @return            The location where this Dimension Door is supposed jump
 *                    it's targets to.
 */
location GetDimensionDoorLocation(object oCaster, int nCasterLvl, location lBaseTarget, float fDistance);

/**
 * Does the actual teleporting and VFX.
 *
 * @param oCaster           The user of the Dimension Door being run
 * @param lTarget           The location to teleport to
 * @param bTeleportingParty Whether this dimension door is teleporting only the user
 *                          or also surrounding party. Determines the size of the VFX
 * @param sScriptToCall     The script to call for each teleporting object once it has
 *                          reached the destination
 */
void DoDimensionDoorTeleport(object oCaster, location lTarget, int bTeleportingParty, string sScriptToCall);

/**
 * Deletes local variables used to preserve state over delays by these functions.
 *
 * @param oCaster  creature on whom the data was stored
 */
void CleanLocals(object oCaster);

/**
 * A wrapper for assigning two commands at once after a delay from DoDimensionDoorTeleport().
 * First, the jump command and then, if the script is non-blank, a call to ExecuteScript
 * the given post-jump script.
 *
 * @param oJumpee       creature being teleported by Dimension Door
 * @param lTarget       the location to jump to
 * @param sScriptToCall script for oJumpee to execute once it has jumped
 */
void AssignDimensionDoorCommands(object oJumpee, location lTarget, string sScriptToCall);



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

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

void TeleportAux(object oCaster)
{
    // Retrieve the target location from the variable
    location lTarget = GetLocalLocation(oCaster, TP_LOCATION);
    location lCaster = GetLocation(oCaster);
    // If not errorless, run the location through the erroring code
    if(!GetLocalInt(oCaster, TP_ERRORLESS))
        lTarget = GetTeleportError(lTarget, oCaster);

    int i;
    object oTarget;

    // Check if it's valid for the caster to teleport. If he can't go, no-one goes
    if(GetCanTeleport(oCaster, lTarget, TRUE))
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
    }

    // Cleanup
    DeleteLocalInt(oCaster, TP_FIRSTSTAGE_DONE);
    DeleteLocalLocation(oCaster, TP_LOCATION);
    DeleteLocalInt(oCaster, TP_ERRORLESS);
    array_delete(oCaster, PRC_TELEPORTING_OBJECTS_ARRAY);
}

void Teleport(object oCaster, int nCasterLvl, int bTeleportParty, int bErrorLess, string sScriptToCall = "")
{
    if(DEBUG) DoDebug("spinc_teleport: Running Teleport()" + (GetLocalInt(oCaster, TP_FIRSTSTAGE_DONE) ? ": ERROR: Called while in second stage!":""));

    // Get whether we are executing the first or the second part of the script
    if(!GetLocalInt(oCaster, TP_FIRSTSTAGE_DONE))
    {
        location lCaster = GetLocation(oCaster);

        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oCaster, nCasterLvl, bTeleportParty);

        // Do VFX while waiting for the location select. Only for party TP
        if(bTeleportParty)
            DelayCommand(0.01f, VFX_HB(oCaster, lCaster));

        // Mark the first part done
        SetLocalInt(oCaster, TP_FIRSTSTAGE_DONE, TRUE);
        // Store whether this usage is errorless
        SetLocalInt(oCaster, TP_ERRORLESS, bErrorLess);
        // Now, get the location to teleport to.
        ChooseTeleportTargetLocation(oCaster, "prc_teleport_aux", TP_LOCATION, FALSE, TRUE);
    }
}


// Test main
//void main(){}