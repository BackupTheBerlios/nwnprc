/*
   ----------------
   Psionic Blast
   
   prc_all_psiblast
   ----------------

   28/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: Medium
   Target: 30' Cone
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 5
   
   The air ripples with the force of your mental attack, which blasts the minds of all creatures
   in range. Psionic Blast stuns all affect creatures for 1 round.
   
   Augment: For every 2 additional power points spent, the duration increases by 1 round.
*/

#include "prc_inc_psifunc"
#include "prc_inc_psionic"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    int nAugment = GetLocalInt(oCaster, "Augment");

    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget;
	effect eStun = EffectStunned();
	int nDuration = 1;
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
	effect eLink = EffectLinkEffects(eStun, eMind);
	float fDist;
			
	//Augmentation effects to Duration
	if (nAugment > 0) nDuration += nAugment;
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 30.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);

    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while(GetIsObjectValid(oTarget))
    	{
    	        //Signal spell cast at event to fire.
    	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    	        //Calculate the delay time on the application of effects based on the distance
    	        //between the caster and the target
    	        fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

    	            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    	            {
    	                // Apply effects to the currently selected target. 
    	                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,nCaster));
    	            }
    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 30.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}

	

    }
}