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
    stating direction. You may also bring one additional willing Medium or smaller creature or
    its equivalent per three caster levels. A Large creature counts as two Medium creatures, a
    Huge creature counts as two Large creatures, and so forth. All creatures to be transported
    must be in contact with you. *
    
    Notes:
    * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.07.2005
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"
#include "inc_draw"


const int SPELLID_TELEPORT_SELF_ONLY = 2891;
const int SPELLID_TELEPORT_PARTY     = 2892;


location GetDimensionDoorLocation(object oCaster, int nCasterLvl)
{
    if(GetHasTeleportQuickSelectionActive(oCaster))
    {
        location lTest = MetalocationToLocation(GetTeleportQuickSelection(oCaster));

        if(GetArea(oCaster) == GetAreaFromLocation(lTest))
        {
            if(GetDistanceBetweenLocations(GetLocation(oCaster), lTest) <= FeetToMeters(400.0 + 40.0 * nCasterLvl))
                return lTest;
        }
    }

    // Return the spell's target location
    return GetIsObjectValid(GetSpellTargetObject()) ? // Are we teleporting to some object, or just at a spot on the ground?
            GetLocation(GetSpellTargetObject()) :     // Teleporting to some object
            GetSpellTargetLocation();                 // Teleporting to a spot on the ground
}

void main()//TODO: Look at greater teleport for group teleport code. Also, gaoneng for VFX
{   
    SPSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main spellscript */
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
        AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 1.0f));
        
        // First, spawn a circle of ligntning around the caster
        BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lCaster,
                    nSpellID == SPELLID_TELEPORT_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
                    15, 1.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);
        
        //BeamPolygon(1, 73, lCaster, 5.0, 8, 3.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);
        
        // After a moment, draw a line from the caster to the destination
        DelayCommand(1.0, DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oCaster), GetPositionFromLocation(lCaster), GetPositionFromLocation(lTarget), 0.0,
                                   FloatToInt(GetDistanceBetweenLocations(lCaster, lTarget)), // One VFX every 5 meters
                                   0.5));
        // Then, spawn a circle of ligtning at the destination
        DelayCommand(0.5, BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lTarget, nSpellID == SPELLID_TELEPORT_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), 15, 2.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0));
    }
    
    
    
    /*
    // Check if we could manifest, and whether there it is possible to make the teleport
    if(nMetaPsi > 0 && GetCanTeleport(oCaster, lTarget))
    {
        effect eVis    = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);
        // Calculate the locations to apply the VFX at
        vector vOrigin = GetPositionFromLocation(GetLocation(oCaster));
        vector vDest   = GetPositionFromLocation(lTarget);
        vOrigin = Vector(vOrigin.x + 2.0, vOrigin.y - 0.2, vOrigin.z);
        vDest   = Vector(vDest.x   + 2.0, vDest.y   - 0.2, vDest.z);

        // Apply the VFX
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vOrigin, 0.0), 0.8);
        DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, Location(GetArea(oCaster), vDest, 0.0), 0.7));
        
        // Schedule the actual location change
        DelayCommand(0.4, AssignCommand(oCaster, JumpToLocation(lDest)));
    }
    */
    SPSetSchool();
}