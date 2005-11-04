//:://////////////////////////////////////////////
//:: Spell: Teleportation Circle
//:: sp_telecircle
//:://////////////////////////////////////////////
/** @file

    Teleportation Circle

    Conjuration (Teleportation)
    Level: Sor/Wiz 9
    Components: V
    Casting Time: 10 minutes
    Range: 0 ft.
    Effect: 5-ft.-radius circle that teleports those who activate it
    Duration: 10 min./level
    Saving Throw: None
    Spell Resistance: Yes

    You create a circle on the floor or other horizontal surface that teleports, as greater teleport,
    any creature who stands on it to a designated spot. Once you designate the destination for the
    circle, you can’t change it. The spell fails if you attempt to set the circle to teleport
    creatures into a solid object, to a place with which you are not familiar and have no clear
    description, or to another plane.

    The circle itself is subtle and nearly impossible to notice. If you intend to keep creatures from
    activating it accidentally, you need to mark the circle in some way.

    Teleportation circle can be made permanent with a permanency spell. A permanent teleportation circle
    that is disabled becomes inactive for 10 minutes, then can be triggered again as normal.

    Note: Magic traps such as teleportation circle are hard to detect and disable. A rogue (only) can
    use the Search skill to find the circle and Disable Device to thwart it. The DC in each case is
    25 + spell level, or 34 in the case of teleportation circle.

    Material Component: Amber dust to cover the area of the circle (cost 1,000 gp).


    @note At this time, the circle does not act as a trap, merely as a normal area of effect.
          This means that though it can be dispelled, it cannot be disarmed. Due to this, the
          option to have the circle be hidden is also disabled.

    @author Ornedan
    @date   Created - 24.06.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"
#include "inc_utility"


/**
 * @todo: Ask Primo about making this a PRGT trap. Otherwise, no disarming
 * @todo: Make the OnEnter HB not teleport the caster the first time they enter.
 */

const int SPELLID_VISIBLE = 2878;
const int SPELLID_HIDDEN  = 2879;

//PRC_TELECIRCLE_TRIG_VISIBLE_ORIG
//PRC_TELECIRCLE_TRIG_HIDDEN_ORIG


void main()
{
    // Set the spell school
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    object oCaster = OBJECT_SELF;

    // Get whether we are executing the first or the second part of the script
    if(!GetLocalInt(oCaster, "PRC_Spell_TeleportCircle_FirstPartDone"))
    {
        // Spellhook
        if(!X2PreSpellCastCode()) return;
        int nCasterLvl = PRCGetCasterLevel();
        int nSpellID   = GetSpellId();

        // Store the caster level
        SetLocalInt(oCaster, "PRC_Spell_TeleportCircle_CasterLvl", nCasterLvl);
        // Store the spellID
        SetLocalInt(oCaster, "PRC_Spell_TeleportCircle_SID", nSpellID);
        // Mark the first part done
        SetLocalInt(oCaster, "PRC_Spell_TeleportCircle_FirstPartDone", TRUE);
        // Now, get the location to have the circle point at.
        ChooseTeleportTargetLocation(oCaster, "sp_telecircle", "PRC_Spell_TeleportCircle_TargetLocation", FALSE, TRUE);
    }
    // We now have the location for the circle to toss people to.
    else
    {
        // Retrieve the target location from the variable
        location lCircleTarget = GetLocalLocation(oCaster, "PRC_Spell_TeleportCircle_TargetLocation");
        int bVisible = TRUE;/*GetLocalInt(oCaster, "PRC_Spell_TeleportCircle_SID") == SPELLID_VISIBLE;*/ ///FIXME
        location lTarget;
        float fFacing  = GetFacing(oCaster);
        float fDistance = FeetToMeters(5.0f) + 0.2;
        vector vTarget = GetPosition(oCaster);
               vTarget.x += cos(fFacing) * fDistance;
               vTarget.y += sin(fFacing) * fDistance;
        lTarget = Location(GetArea(oCaster), vTarget, fFacing);

        // Create the actual circle, in front of the caster
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                              EffectAreaOfEffect(AOE_PER_TELEPORTATIONCIRCLE, "prc_telecirc_oe"),
                              lTarget,
                              GetLocalInt(oCaster, "PRC_Spell_TeleportCircle_CasterLvl") * 10 * 60.0f
                              );
        // Get an object reference to the newly created AoE
        object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        while(GetIsObjectValid(oAoE))
        {
            // Test if we found the correct AoE
            if(GetTag(oAoE) == Get2DACache("vfx_persistent", "LABEL", AOE_PER_TELEPORTATIONCIRCLE) &&
               !GetLocalInt(oAoE, "PRC_TeleCircle_AoE_Inited")
               )
            {
                break;
            }
            // Didn't find, get next
            oAoE = GetNextObjectInShape(SHAPE_SPHERE, 1.0f, lTarget, FALSE, OBJECT_TYPE_AREA_OF_EFFECT);
        }
        if(DEBUG && !GetIsObjectValid(oAoE)) DoDebug("ERROR: Can't find area of effect for Teleportation Circle!");

        // Store data on the AoE
        SetLocalLocation(oAoE, "TargetLocation", lCircleTarget);
        SetLocalInt(oAoE, "IsVisible", bVisible);

        // Make the AoE initialise the trap trigger and possibly the VFX heartbeat
        ExecuteScript("prc_telecirc_aux", oAoE);


        // A VFX (momentary, circular, impressive :D ) at the circle's location.
        // Do even if hidden circle so that the caster knows where it really ended up
        DrawRhodonea(DURATION_TYPE_INSTANT, VFX_IMP_HEAD_MIND, lTarget, FeetToMeters(5.0f), 0.25, 0.0, 180, 12.0, 4.0, 0.0, "z");

        // Cleanup
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_CasterLvl");
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_SID");
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_FirstPartDone");
        DeleteLocalLocation(oCaster, "PRC_Spell_TeleportCircle_TargetLocation");
    }

    SPSetSchool();
}
