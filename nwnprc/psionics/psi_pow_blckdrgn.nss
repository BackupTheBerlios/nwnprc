/*
    ----------------
    Breath of the Black Dragon
    
    psi_all_blckdrgn
    ----------------

    21/10/04 by Stratovarius

    Class: Psion/Wilder 6, Psychic Warrior 6
    Power Level: 6
    Range: Short
    Target: AoE
    Shape: Cone
    Duration: Instantaneous
    Saving Throw: Reflex half
    Power Resistance: Yes
    Power Point Cost: 11
 
    Your mouth spews forth vitriolic acid that deals 11d6 damage to any targets in the area

    Augment: For every additional power point spend, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

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
    int nSurge = GetLocalInt(oCaster, "WildSurge");
        
    if (nSurge > 0)
    {
       	
       	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fDelay;
	location lTargetLocation = GetSpellTargetLocation();
    	object oTarget;
    	int nDice = 11;
	int nDiceSize = 6;
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0)	nDice += nAugment;
	
	
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while(GetIsObjectValid(oTarget))
    	{

	        //Fire cast spell at event for the specified target
    	        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    	        //Get the distance between the target and caster to delay the application of effects
    	        fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
    	        //Make SR check, and appropriate saving throw(s).
    	        if(PRCMyResistPower(OBJECT_SELF, oTarget,nPen, fDelay) && (oTarget != OBJECT_SELF))
    	        {    	     
    	        
    	            int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
    	            
    	            //Adjust damage according to Reflex Save, Evasion or Improved Evasion
    	            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_ACID);
	
    	            if(nDamage > 0)
    	            {
	                // Apply effects to the currently selected target.
	    	        effect eAcid = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	            	effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);    	            
    	                //Apply delayed effects
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
    	            }
    	        }
    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}
    
    }
}