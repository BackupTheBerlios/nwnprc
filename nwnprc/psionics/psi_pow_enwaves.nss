/*
   ----------------
   Energy Wave Cold
   
   prc_pow_enwavec
   ----------------

   25/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 7
   Range: Long
   Area: 120 ft Cone
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 13
   
   You create a flood of energy that deals 13d6 to anything in a 120' cone.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
   For every two additional power points spent the DC increases by 1. 
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
    object oTarget = OBJECT_SELF;
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, METAPSIONIC_WIDEN);
        
    if (nSurge > 0)
    {
       	
       	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fDelay;
	location lTargetLocation = GetSpellTargetLocation();
    	int nDice = 13;
	int nDiceSize = 6;
	float fWidth = DoWiden(120.0, nMetaPsi);
	
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0)	
	{
		nDice += nAugment;
		nDC += nAugment/2;
	}
	
	
    	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
    	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fWidth, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
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
    	               	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
		        nDamage -= nDice;
    	            
			if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
			{
				nDamage /= 2;			
			}
	
	                // Apply effects to the currently selected target.
	    	        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
	            	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);    	            
    	                //Apply delayed effects
    	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
	                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
    	        }
    	    //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fWidth, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    	}
    
    }
}