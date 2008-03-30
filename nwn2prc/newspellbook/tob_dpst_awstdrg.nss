/*
    ----------------
    Awaken the Stone Dragon

    tob_dpst_awstdrg
    ----------------

    27/01/08 by Stratovarius
*/ /** @file

    Awaken the Stone Dragon

    Deepstone Sentinel level 5

    The ground ripples and rolls, crashing your foes to the ground, battered and sore.
    
    Once per encounter, you may cause a small earthquake, dealing 12d6 damage to all foes within
    60 feet. Those who succeed at a Reflex save remain standing and take 6d6 damage.
*/

#include "tob_inc_tobfunc"
#include "tob_movehook"
#include "prc_alterations"

void main()
{
    	object oInitiator    = OBJECT_SELF;
    	object oTarget       = PRCGetSpellTargetObject();

    		object oProneTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
    		while(GetIsObjectValid(oProneTarget))
    		{
       	                // Save check
			if (!PRCMySavingThrow(SAVING_THROW_WILL, oProneTarget, (10 + GetHitDice(oInitiator)/2 + GetAbilityModifier(ABILITY_STRENGTH, oInitiator))) &&
			    GetIsEnemy(oProneTarget, oInitiator))
			{
				ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oProneTarget, 6.0);
				ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(12)), oProneTarget);
       	            	}
       	            	else //Succeed
       	            		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(6)), oProneTarget);

        	oProneTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(60.0), GetLocation(oInitiator));
    		}    		
}