/*
   ----------------
   Time Hop, Mass
   
   prc_pow_timehopm
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 8
   Range: Personal
   Target: 25' Burst
   Duration: 1 Hour/level
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 15
   
   The subjects of the power hop forward in time. In effect, the subjects disappear in a shimmer, then reappear when the power
   expires. No change has taken place to the objects. Friendly targets get no saving throw. 
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, METAPSIONIC_TWIN, 0);  
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;   
	
	// effect set
	effect ePara = EffectCutsceneParalyze();
	effect eGhost = EffectCutsceneGhost();
	effect eEth = EffectEthereal();
	
	//Massive effect linkage, go me
    	effect eSpell = EffectSpellImmunity(SPELL_ALL_SPELLS);
    	effect eDam1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 100);
    	effect eDam2 = EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100);
    	effect eDam3 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 100);
    	effect eDam4 = EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE, 100);
    	effect eDam5 = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100);
    	effect eDam6 = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    	effect eDam7 = EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL, 100);
    	effect eDam8 = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    	effect eDam9 = EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING, 100);
    	effect eDam10 = EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE, 100);
    	effect eDam11 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 100);
    	effect eDam12 = EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC, 100);
    	
    	effect eLink = EffectLinkEffects(eSpell, eDam1);
    	eLink = EffectLinkEffects(eLink, eDam2);
    	eLink = EffectLinkEffects(eLink, eDam3);
    	eLink = EffectLinkEffects(eLink, eDam4);
    	eLink = EffectLinkEffects(eLink, eDam5);
    	eLink = EffectLinkEffects(eLink, eDam6);
    	eLink = EffectLinkEffects(eLink, eDam7);
    	eLink = EffectLinkEffects(eLink, eDam8);
    	eLink = EffectLinkEffects(eLink, eDam9);
    	eLink = EffectLinkEffects(eLink, eDam10);
    	eLink = EffectLinkEffects(eLink, eDam11);
    	eLink = EffectLinkEffects(eLink, eDam12);
    	eLink = EffectLinkEffects(eLink, ePara);
    	eLink = EffectLinkEffects(eLink, eGhost);
    	eLink = EffectLinkEffects(eLink, eEth);
	
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	location lTarget = GetSpellTargetLocation();
	
	//Declare the spell shape, size and the location.  Capture the first target object in the shape.
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 25.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
	//Cycle through the targets within the spell shape until you run out of targets.
	while (GetIsObjectValid(oTarget))
	{
		if(!GetIsFriend(oTarget))
		{
			//Check for Power Resistance
			if (PRCMyResistPower(oCaster, oTarget, nPen))
			{
			       	if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
			      	{
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
        		       	}
			}
	    	}
	    	else 
	    	{
	    		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
	    	}
		//Select the next target within the spell shape.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, 25.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
    }
}