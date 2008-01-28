/*
    ----------------
    Crashing Mountain Juggernaught

    tob_dpst_crhmntj
    ----------------

    27/01/08 by Stratovarius
*/ /** @file

    Crashing Mountain Juggernaught

    Deepstone Sentinel level 2

    You rush down from the pillar like a living avalanche, tumbling your foes before you.
    
    You end your Mountain Fortress Stance, causing all those adjacent to you to make DC 15 Balance checks
    or fall prone. You charge a single foe with a +2d6 damage bonus.
    You must be in the Mountain Fortress Stance to use this ability.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
    	object oInitiator    = OBJECT_SELF;
    	object oTarget       = PRCGetSpellTargetObject();
    	if (GetHasSpellEffect(MOVE_MOUNTAIN_FORTRESS, oInitiator))
    	{
    		RemoveEffectsFromSpell(oInitiator, MOVE_MOUNTAIN_FORTRESS);
    		object oProneTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator));
    		while(GetIsObjectValid(oProneTarget))
    		{
       	                // Skill check
			if (!GetIsSkillSuccessful(oProneTarget, SKILL_BALANCE, 15))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oProneTarget, 6.0);
       	            	}

        	oProneTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oInitiator));
    		}    		
    
    		// Now the Charge
		int nSucceed = DoCharge(oInitiator, oTarget, TRUE, TRUE, d6(2), -1);
	}
	else
		FloatingTextStringOnCreature("You are not in Mountain Fortress Stance.", oInitiator, FALSE);
}