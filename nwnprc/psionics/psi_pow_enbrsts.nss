/*
   ----------------
   Energy Burst Cold
   
   prc_all_enbrstc
   ----------------

   11/12/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 3
   Range: 40
   Area: 40 ft burst centered on caster
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 5
   
   You create an explosion of unstable ectoplasmic energy of the chosen type that deals 5d6 to every creature
   or object in the area.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6. 
   For every two additional dice of damage, the DC increases by 1. 
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
	location lTarget = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	int nDice = 5;
	int nDiceSize = 6;
	
    	float fDelay;
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDC += nAugment/2;
	}
	
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
		       	if (nAugment > 0) nDice += nAugment;
		      	int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
                   	nDamage -= nDice;
                   	
		        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
		        {
			        nDamage /= 2;
	               	}		
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);	               	
	               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
		//Select the next target within the spell shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
	}
    }
}