//:://////////////////////////////////////////////
//:: Teleportation Circle spellscript
//:: sp_telecircle
//:://////////////////////////////////////////////
/** @file Teleportation Circle spellscript

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


    @author Ornedan
    @date   Created - 24.06.2005
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"
#include "inc_draw"


/**
 * @todo: Ask Primo about making this a PRGT trap. Otherwise, no disarming
 * @todo: Make the OnEnter HB not teleport the caster the first time they enter.
 */

const int SPELLID_VISIBLE = 2878;
const int SPELLID_HIDDEN  = 2879;



void main()
{
    // Since the only way for the circle AoE to find out it's parameters is to get data from the caster, we need to make sure
    // the caster does not create another circle before the previous has gotten it's data out of the way.
    if(GetLocalInt(OBJECT_SELF, "PRC_Spell_TeleportationCircle_Lock"))
    {
        SendMessageToPC(OBJECT_SELF, "Due to technical issues, you may not cast another Teleportation Circle yet. For specifics, RTS");
        return;
    }

    // Set the spell school
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    object oCaster = OBJECT_SELF;
SendMessageToPC(oCaster, "This spell is a work-in-progress. If it seems unfinished, it's because it is, so please ignore any problems with it for now");

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
        //location lCaster = GetLocation(oCaster);
        location lTarget;
        float fFacing  = GetFacing(oCaster);
        float fDistance = FeetToMeters(5.0f) + 0.2;
        vector vTarget = GetPosition(oCaster);
               vTarget.x += cos(fFacing) * fDistance;
               vTarget.y += sin(fFacing) * fDistance;
        lTarget = Location(GetArea(oCaster), vTarget, fFacing);

        // Create the actual circle, in front of the caster
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
                              EffectAreaOfEffect(AOE_PER_TELEPORTATIONCIRCLE),
                              lTarget,//lCaster,
                              GetLocalInt(oCaster, "PRC_Spell_TeleportCircle_CasterLvl") * 10 * 60.0f
                              );

        //DelayCommand(0.2f, SetData(, lCircleTarget));

        /// @todo: A VFX (momentary, circular, impressive :D ) at the circle's location.
        /// Do even if hiddencircle so that the caster knows where it really ended up
        DrawRhodonea(DURATION_TYPE_INSTANT, VFX_IMP_HEAD_MIND, lTarget, FeetToMeters(5.0f), 0.25, 0.0, 60, 4.0, 0.0, 0.0, "z");

/*VFX_COM_BLOOD_CRT_WIMPQ
VFX_COM_HIT_SONIC
VFX_DUR_PROTECTION_EVIL_MINOR
VFX_DUR_PROTECTION_GOOD_MINOR
VFX_IMP_FROST
VFX_IMP_HEAD_MIND
plc_flamesmall
s2_plc_scircle
*/
        /// @todo: VFX for visible version here. A detection radius for hidden version.
        //if(GetLocalInt(oCaster, "PRC_Spell_TeleportCircle_SID") == SPELLID_VISIBLE)  - Do this when we have an object reference to the AoE, so we can have this disappear when it gets deleted


        // Lock the caster from creating more teleportation circles until the new one has grabbed it's data
        SetLocalInt(oCaster, "PRC_Spell_TeleportationCircle_Lock", TRUE);
        // Set automatic unlocking to happen in one minute just in case of trouble
        DelayCommand(60.0f, DeleteLocalInt(oCaster, "PRC_Spell_TeleportationCircle_Lock"));

        // Cleanup
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_CasterLvl");
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_SID");
        DeleteLocalInt(oCaster, "PRC_Spell_TeleportCircle_FirstPartDone");
        //DeleteLocalLocation(oCaster, "PRC_Spell_TeleportCircle_TargetLocation");
    }

    SPSetSchool();
}

/*
{
    struct trap tTeleCircle;
    tTeleCircle.nDetectDC       = 34;
    tTeleCircle.nDisarmDC       = 34;
    tTeleCircle.nDetectAOE      = VFX_PER_15M_INVIS;
    tTeleCircle.nTrapAOE        = VFX_PER_5_FT_INVIS;
    tTeleCircle.sResRef         = "prgt_invis";
    tTeleCircle.sTriggerScript  = "sp_telecircle_oe";
    //tTeleCircle.nSpellID;
    //tTeleCircle.nSpellLevel;
    //tTeleCircle.nDamageType;
    //tTeleCircle.nRadius;
    //tTeleCircle.nDamageDice;
    //tTeleCircle.nDamageSize;
    //tTeleCircle.nTargetVFX;
    //tTeleCircle.nTrapVFX;
    //tTeleCircle.nFakeSpell;
    //tTeleCircle.nBeamVFX;
    tTeleCircle.nCR             = GetECL(oCaster);
}
*/