/*
   ----------------
   Energy Push Electricity
   
   prc_all_enstune
   ----------------

   6/11/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 2
   Range: Short
   Area: 5 ft burst
   Duration: Instantaneous
   Saving Throw: Reflex or Fortitude half.
   Power Resistance: Yes
   Power Point Cost: 3
   
   You release a power stroke of energy that encircles all creatures in the area, dealing
   1d6 points of damage to them. In addition, any creature that fails its save for half damage
   must succeed on a will save or be stunned for 1 round.
   
   Cold: Fort Save, +1 damage a die.
   Electricity: Reflex Save, DC +2, Caster level check to overcome Power Resistance +2.
   Fire: Reflex Save, +1 damage a die.
   Sonic: Reflex Save, -1 damage a die.
   
   Augment: For every additional power point spent, this power's damage increases by 1d6, 
   and the DC increases by 1. 
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
    int nAugCost = 2;
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    
    if (nSurge > 0)
    {
    	nAugCost = 0;
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = (GetManifesterDC(oCaster) + 2);
	int nCaster = GetManifesterLevel(oCaster);
	location lTarget = GetSpellTargetLocation();
	int nDamage = d6(1);
	effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
	effect eExplode = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
	
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectStunned();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);	
    	
    	float fDelay;
		
	if (nSurge > 0) nAugment = nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDamage += d6(nAugment);
		nDC += nAugment;
	}
	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
		if (PRCMyResistPower(oCaster, oTarget, (nCaster + 2)))
		{
		        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_ELECTRICITY))
		        {
			        nDamage /= 2;
	               	}		
			else if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1,nCaster));
			}
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);	               	
	               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
		}
		//Select the next target within the spell shape.
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
    }
}