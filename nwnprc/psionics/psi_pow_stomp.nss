/*
   ----------------
   Stomp
   
   prc_all_stomp
   ----------------

   28/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 1
   Range: Short
   Target: 20' Cone
   Duration: Instantaneous
   Saving Throw: Reflex negates
   Power Resistance: No
   Power Point Cost: 1
   
   Your stomp precipitates a psychokinetic shockwave that travels along the ground, toppling creatures.
   Creatures that fail their save are knocked down and take 1d4 points of bludgeoning damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d4. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 3);

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

    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget;
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	effect eKnock = EffectKnockdown();
	float fDist;
	int nDice = 1;
	int nDiceSize = 4;
	
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);

    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while(GetIsObjectValid(oTarget))
    	{
    	        //Signal spell cast at event to fire.
    	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    	        //Calculate the delay time on the application of effects based on the distance
    	        //between the caster and the target
    	        fDist = GetDistanceBetween(OBJECT_SELF, oTarget)/20;

    	            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
    	            {
    	               	if (nAugment > 0) nDice += nAugment;
		      	int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
		      	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    	            
    	                // Apply effects to the currently selected target. 
    	                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    	                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	                DelayCommand(fDist, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0,TRUE,-1,nCaster));
    	            }
    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 20.0, GetSpellTargetLocation(), TRUE, OBJECT_TYPE_CREATURE);
    	}

	

    }
}