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

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 0);

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

// End of Spell Cast Hook

    object oCaster = OBJECT_SELF;
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, METAPSIONIC_WIDEN);  

    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	effect eStun = EffectStunned();
	int nDur = 1;
	float fWidth = DoWiden(30.0, nMetaPsi);
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
	effect eLink = EffectLinkEffects(eStun, eMind);
	float fDist;
			
	//Augmentation effects to Duration
	if (nAugment > 0) nDur += nAugment;
	
	if (nMetaPsi == 2)	nDur *= 2;   
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fWidth, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);

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
    	                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster));
    	            }
    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, PRCGetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}

	

    }
}