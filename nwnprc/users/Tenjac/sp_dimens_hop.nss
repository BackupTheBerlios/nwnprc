//::///////////////////////////////////////////////
//:: Name      Dimension Hop
//:: FileName  sp_dimens_hop.nss
//:://////////////////////////////////////////////
/**@file Dimension Hop
Conjuration (Teleportation)
Level: Duskblade 2, sorcerer/wizard 2
Components: V
Casting Time: 1 standard action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Will negates
Spell Resistance: Yes

You instantly teleport the subject creature a distance
of 5 feet per two caster levels.  The destination must
be an unoccupied space within line of sight.
**/
/////////////////////////////////////////////////////
// Author: Tenjac (nearly completely copied from Ornedan)
// Date:   3.10.06
/////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
        if(!X2PreSpellCastCode()) return;
        
        SPSetSchool(SPELL_SCHOOL_CONJURATION);
        
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = SPGetSpellSaveDC(oTarget, oPC);
        int nTouch = PRCDoMeleeTouchAttack(oTarget);
        
        // Calculate how far the creature gets pushed
        float fDistance = FeetToMeters(IntToFloat(nCasterLvl * 5));
        
        // Determine if they hit a wall on the way
        location loPC   = GetLocation(oPC);
        location lTargetOrigin = GetLocation(oTarget);
        vector vAngle          = AngleToVector(GetRelativeAngleBetweenLocations(loPC, lTargetOrigin));
        vector vTargetOrigin   = GetPosition(oTarget);
        vector vTarget         = vTargetOrigin + (vAngle * fDistance);
        
        if(nTouch)
        {
                //SR
                if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                {
                        //Saving Throw
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
                        {
                                if(!LineOfSightVector(vTargetOrigin, vTarget))
                                {                                
                                        // Hit a wall, binary search for the wall
                                        float fEpsilon    = 1.0f;          // Search precision
                                        float fLowerBound = 0.0f;          // The lower search bound, initialise to 0
                                        float fUpperBound = fDistance;     // The upper search bound, initialise to the initial distance
                                        fDistance         = fDistance / 2; // The search position, set to middle of the range
                                        
                                        do
                                        {
                                                // Create test vector for this iteration
                                                vTarget = vTargetOrigin + (vAngle * fDistance);
                                                
                                                // Determine which bound to move.             
                                                if(LineOfSightVector(vTargetOrigin, vTarget))
                                                fLowerBound = fDistance;
                                                else
                                                fUpperBound = fDistance;
                                                
                                                // Get the new middle point
                                                fDistance = (fUpperBound + fLowerBound) / 2;
                                        }
                                        
                                        while(fabs(fUpperBound - fLowerBound) > fEpsilon);
                                }
                                // Create the final target vector
                                vTarget = vTargetOrigin + (vAngle * fDistance);
                                
                                // Do some VFX                               
                                
                                DrawLineFromVectorToVector(DURATION_TYPE_INSTANT, VFX_IMP_WIND, GetArea(oPC), vTargetOrigin, GetPositionFromLocation(lTargetDestination), 0.0, FloatToInt(GetDistanceBetweenLocations(GetLocation(oPC), lTarget)), 0.5);
                                
                                // Move the target
                                location lTargetDestination = Location(GetArea(oTarget), vTarget, GetFacing(oTarget));
                                AssignCommand(oTarget, ClearAllActions(TRUE));
                                AssignCommand(oTarget, JumpToLocation(lTargetDestination));
                        }
                }
        }
        SPSetSchool();
}      