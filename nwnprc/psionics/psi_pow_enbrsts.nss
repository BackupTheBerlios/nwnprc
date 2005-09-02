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
	location lTarget = PRCGetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	int nDice = 5;
	int nDiceSize = 6;
	float fWidth = DoWiden(RADIUS_SIZE_COLOSSAL, nMetaPsi);
	
    	float fDelay;
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDC += nAugment/2;
		nDice += nAugment;
	}
	
    	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
		       	if (oTarget != OBJECT_SELF)
			{		
			      	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
	                   	nDamage -= nDice;
	                   	
			        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SONIC))
			        {
				        nDamage /= 2;
		               	}		
				effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);	               	
		               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
		               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		        }
		}
		//Select the next target within the spell shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, GetLocation(OBJECT_SELF));
	}
    }
}