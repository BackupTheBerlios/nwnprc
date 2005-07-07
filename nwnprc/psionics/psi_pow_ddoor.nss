/*
   ----------------
   Dimension Door, Psionic
   
   psi_pow_ddoor
   ----------------

   19/2/04 by Stratovarius
   05.07.2005 by Ornedan
*/
/** @file
    Dimension Door, Psionic
    
    Level: Psion/Wilder 4, Psychic Warrior 4
    Range: Long (400 ft. + 40 ft./level)
    Target or Targets: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 7
    
    You instantly transfer yourself from your current location to any other spot within range.
    You always arrive at exactly the spot desired�whether by simply visualizing the area or by
    stating direction. You may also bring one additional willing Medium or smaller creature or
    its equivalent per three caster levels. A Large creature counts as two Medium creatures, a
    Huge creature counts as two Large creatures, and so forth. All creatures to be transported
    must be in contact with you. *
    
    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"
#include "prc_inc_teleport"
#include "inc_draw"

void main()
{
    /*
    Spellcast Hook Code
    Added 2004-11-02 by Stratovarius
    If you want to make changes to all powers,
    check psi_spellhook to find out more

    */
    if (!PsiPrePowerCastCode())
    {
        // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }
/*
    // End of Spell Cast Hook

    object oCaster   = OBJECT_SELF;
    int nAugCost     = 0;
    int nMetaPsi     = GetCanManifest(oCaster, nAugCost, oCaster, 0, 0, 0, 0, 0, 0, 0);
    location lTarget = GetIsObjectValid(GetSpellTargetObject()) ? // Are we teleporting to some object, or just at a spot on the ground?
                        GetLocation(GetSpellTargetObject()) :     // Teleporting to some object
                        GetSpellTargetLocation();                 // Teleporting to a spot on the ground
    
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
        DelayCommand(0.4, AssignCommand(oCaster, JumpToLocation(lTarget)));
    }
*/    
/* Main spellscript */
    object oManifester = OBJECT_SELF;
    object oTarget;
    int nAugCost       = 0;
    int nMetaPsi       = GetCanManifest(oManifester, nAugCost, OBJECT_INVALID, 0, 0, 0, 0, 0, 0, 0);
    int nManifesterLvl = GetManifesterLevel();
    int nSpellID       = GetSpellId();
    int i;
    location lTarget   = GetIsObjectValid(GetSpellTargetObject()) ? // Are we teleporting to some object, or just at a spot on the ground?
                          GetLocation(GetSpellTargetObject()) :     // Teleporting to some object
                          GetSpellTargetLocation();                 // Teleporting to a spot on the ground
    location lManifester = GetLocation(oManifester);
    
    // Check if it's valid for the caster to teleport. If he can't go, no-one goes
    if(nMetaPsi > 0 && GetCanTeleport(oManifester, lTarget))
    {
    
        // Run the code to build an array of targets on the caster
        GetTeleportingObjects(oManifester, nManifesterLvl, nSpellID == POWER_DIMENSIONDOOR_PARTY);
        // Loop over the targets, checking if they can teleport. Redundant check on the caster, but shouldn't cause any trouble
        for(i = 0; i < array_get_size(oManifester, PRC_TELEPORTING_OBJECTS_ARRAY); i++)
        {
            oTarget = array_get_object(oManifester, PRC_TELEPORTING_OBJECTS_ARRAY, i);
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
        AssignCommand(oManifester, ClearAllActions());
        //AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 1.0f));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS), oManifester, 1.0f);
        
        // First, spawn a circle of ligntning around the caster
        BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lManifester,
                    nSpellID == POWER_DIMENSIONDOOR_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
                    15, 1.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);
        
        //BeamPolygon(1, 73, lCaster, 5.0, 8, 3.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0);
        
        // After a moment, draw a line from the caster to the destination
        DelayCommand(1.0, DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oManifester), GetPositionFromLocation(lManifester), GetPositionFromLocation(lTarget), 0.0,
                                   FloatToInt(GetDistanceBetweenLocations(lManifester, lTarget)), // One VFX every 5 meters
                                   0.5));
        // Then, spawn a circle of ligtning at the destination
        DelayCommand(0.5, BeamPolygon(DURATION_TYPE_TEMPORARY, VFX_BEAM_LIGHTNING, lTarget, nSpellID == POWER_DIMENSIONDOOR_PARTY ? FeetToMeters(10.0) : FeetToMeters(3.0), 15, 2.0, "prc_invisobj", 1.0, 0.0, 0.0, "z", -1, -1, 0.0, 1.0, 2.0));
    }
}