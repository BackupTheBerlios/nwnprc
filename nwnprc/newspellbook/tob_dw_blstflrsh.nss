/*
   ----------------
   Blistering Flourish

   tob_dw_blstflrsh.nss
   ----------------

    28/03/07 by Stratovarius
*/ /** @file

    Blistering Flourish

    Desert Wind (Strike)
    Level: Swordsage 1
    Initiation Action: 1 Standard Action
    Range: 30ft.
    Area: 30-ft burst 
    Duration: 1 Minute

    Your weapons bursts into flames as you twirl it over your head. 
    With a flourish, you cause the fire to explode with a blinding flash.
    
    All creatures other than you in the area must make a Fortitude save vs 11 + Wisdom modifier or be dazzled.
    This is a supernatural maneuver.
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
    	location lTarget = GetLocation(oInitiator);
    	effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    	int nDC = 11 + GetAbilityModifier(ABILITY_WISDOM, oInitiator);
    	//Get the first target in the radius around the caster
    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    	while(GetIsObjectValid(oTarget))
    	{
    		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        	if(oInitiator != oTarget && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
        	{
        		effect eDazzle = SupernaturalEffect(EffectDazzle());
        		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazzle, oTarget, 60.0);
        	}
        	//Get the next target in the specified area around the caster
        	oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lTarget);
    	}
    }
}