/*
    ----------------
    Boulder Roll

    tob_stdr_bldrrll
    ----------------

    19/08/07 by Stratovarius
*/ /** @file

    Boulder Roll

    Stone Dragon (Strike)
    Level: Crusader 4, Swordsage 4, Warblade 4
    Prerequisite: Two Stone Dragon maneuvers
    Initiation Action: 1 Standard Action
    Range: Melee Attack
    Target: One Creature

    Like a boulder tumbling down the mountain, you slam through your enemies.
    
    You make an overrun attempt against each creature in a line with a +4 bonus. You do not
    provoke attacks of opportunity, and if you fail, you are not knocked prone, you simply halt.
*/

#include "tob_inc_move"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
    if (!PreManeuverCastCode())
    {
    // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oInitiator    = OBJECT_SELF;
    object oTarget       = PRCGetSpellTargetObject();
    struct maneuver move = EvaluateManeuver(oInitiator, oTarget);

    if(move.bCanManeuver)
    {
    	location lTarget = GetSpellTargetLocation();
    	float fLength = FeetToMeters(30.0); // Normal movement speed
    	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    	int nSucceed = TRUE;
            // Loop over targets in the line shape
            oTarget = MyFirstObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            while(GetIsObjectValid(oTarget) && nSucceed)
            {
                if(oTarget != oInitiator && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oInitiator))
                {
			nSucceed = DoOverrun(oInitiator, oTarget, FALSE, 4, TRUE, FALSE);
			// Move to the next target with each hit
		        AssignCommand(oInitiator, ClearAllActions(TRUE));
            		AssignCommand(oInitiator, JumpToLocation(GetLocation(oTarget)));
                }// end if - Target validity check

               // Get next target
                oTarget = MyNextObjectInShape(SHAPE_SPELLCYLINDER, fLength, lTarget, TRUE, OBJECT_TYPE_CREATURE);
            }// end while - Target loop
    }
}