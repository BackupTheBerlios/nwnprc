/*
    ----------------
    Crystal Swarm
    
    psi_all_crysswrm
    ----------------

    9/11/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Short
    Shape: 15' Cone
    Duration: Instantaneous
    Saving Throw: None
    Power Resistance: No
    Power Point Cost: 3
 
    Thousands of tiny crystal shards spray forth in an arc from your hand. These razorlike crystals
    slice anything in their path. Anything caught in the cone takes 3d4 points of slashing damage. 

    Augment: For every additional power point spend, this power's damage increases by 1d4. 
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
	int nDice = 3;
	int nDiceSize = 4;
	float fDelay;
	location lTargetLocation = GetSpellTargetLocation();
    	object oTarget;
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0)	nDice += nAugment;
	
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 15.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	//Cycle through the targets within the spell shape until an invalid object is captured.
    	while(GetIsObjectValid(oTarget))
    	{
	    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	    
	    int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
	    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
	    effect eVis = EffectVisualEffect(VFX_IMP_WALLSPIKE);	    
	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 15.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}
    
    }
}