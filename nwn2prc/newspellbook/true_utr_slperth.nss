/*
   ----------------
   Anger the Sleeping Earth

   true_utr_slperth
   ----------------

    1/9/06 by Stratovarius
*/ /** @file

    Anger the Sleeping Earth

    Level: Perfected Map 4
    Range: 100 feet
    Area: 20' Radius 
    Duration: 1 Round
    Spell Resistance: No
    Save: Reflex, see text.
    Metautterances: Extend

    Your words shake the foundation of the earth, causing massive devastation and widespread mayhem.
    This utterance functions as the Earthquake spell.
*/

#include "true_inc_trufunc"
#include "true_utterhook"
#include "prc_alterations"

void main()
{
/*
  Spellcast Hook Code
  Added 2006-7-19 by Stratovarius
  If you want to make changes to all utterances
  check true_utterhook to find out more

*/

    if (!TruePreUtterCastCode())
    {
    // If code within the PreUtterCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    object oTrueSpeaker = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct utterance utter = EvaluateUtterance(oTrueSpeaker, oTarget, METAUTTERANCE_EXTEND, LEXICON_PERFECTED_MAP);

    if(utter.bCanUtter)
    {
        utter.fDur       = RoundsToSeconds(1);
        if(utter.bExtend) utter.fDur *= 2;
        utter.nSaveType  = SAVING_THROW_TYPE_NONE;
	utter.nSaveThrow = SAVING_THROW_FORT;
	utter.nSaveDC    = GetTrueSpeakerDC(oTrueSpeaker); 
        int nDamage;
        effect eExplode = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
        effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
        effect eDam;
        
    	//Declare major variables
    	int nRandom = 0;
    	int nSpectacularDeath = TRUE;
    	int nDisplayFeedback = TRUE;
    	float fDelay;
    	float nSize =  FeetToMeters(20.0);
    	effect eExplode2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
    	effect eExplode3 = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    	effect eShake = EffectVisualEffect(356);
    	effect eKnockdown = EffectKnockdown();
    	//Get the spell target location as opposed to the spell target.
    	location lTarget = PRCGetSpellTargetLocation();
    	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(6),TRUE,-1,utter.nTruespeakerLevel);
	
    	//Apply epicenter explosion on caster
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(OBJECT_SELF));
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode2, GetLocation(OBJECT_SELF));
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode3, GetLocation(OBJECT_SELF));
	
	
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while (GetIsObjectValid(oTarget))
    	{
    	    nRandom = d4();   // if they roll a 3 on this, they must make DC 20 or die.
	
    	    //knockdown effect applies to ALL creatures; DC 15 or knockdown.
    	    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    	    {
    	       SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, utter.nSpellId));
    	       if(oTarget != oTrueSpeaker)
    	       {
    	            if(ReflexSave(oTarget, 15, SAVING_THROW_REFLEX, OBJECT_SELF) == 0)
    	            {
    	             SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, utter.fDur,TRUE,-1,utter.nTruespeakerLevel);
    	            }
    	       }
    	    }
	
    	    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && nRandom == 3)
    	    {
    	        //Fire cast spell at event for the specified target
    	        //Get the distance between the explosion and the target to calculate delay
    	            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
    	            //Reflex DC 20 or die.
    	            if (oTarget != oTrueSpeaker)
    	            {
    	              	if(ReflexSave(oTarget, 20, SAVING_THROW_REFLEX, OBJECT_SELF) == 0)
    	              	{
    	                 	DeathlessFrenzyCheck(oTarget);
    	                 	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(nSpectacularDeath, nDisplayFeedback), oTarget);
    	              	}
    	            }
    	    }
    	   //Select the next target within the spell shape.
    	   oTarget = MyNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}
    	
    	DoLawOfSequence(oTrueSpeaker, utter.nSpellId, utter.fDur);
    }// end if - Successful utterance
}