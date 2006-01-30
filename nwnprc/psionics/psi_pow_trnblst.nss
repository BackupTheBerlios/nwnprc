/*
   ----------------
   Tornado Blast
   
   psi_pow_trnblst
   ----------------

   6/10/05 by Stratovarius

   Class: Psion (Kineticist)
   Power Level: 9
   Range: Long
   Area: 40 ft burst
   Duration: Instantaneous
   Saving Throw: Reflex half.
   Power Resistance: No
   Power Point Cost: 17
   
   You induce the formation of a slender vertex of fiercely swirling air. When you manifest it, a vortex of air snakes out from
   your pointing hand. If you aim the vortex at a specific creature, you can make a ranged touch attach to strike the creature. If 
   you succeed, it takes 8d6 (no save). Regardless of whether your touch attack hits (or you use it at all), all creatures in the area
   are picked up and dashed about, taking 17d6 points of damage (Reflex half). Every creature affected by the spell is knocked to the
   ground by the force of the winds.
   
   Augment: For every additional power point spent, this power's area damage increases by 1d6. 
   For every 2d6 of additional damage the DC increases by 1. 
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
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, METAPSIONIC_WIDEN);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	float fWidth = DoWiden(FeetToMeters(40.0), nMetaPsi);
	
	location lTarget = GetSpellTargetLocation();
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	effect eExplode = EffectVisualEffect(VFX_FNF_STORM);
    	
    	float fDelay;
    	int nDiceRTA = 8;
    	int nDiceSizeRTA = 6;
    	
    	int nDice = 17;
    	int nDiceSize = 6;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDC += nAugment/2;
		nDice += nAugment;
	}
	
	if (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		// Perform the Touch Attach
		int nTouchAttack = PRCDoRangedTouchAttack(oTarget);
		if (nTouchAttack > 0)
		{
			int nDamageRTA = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
			ApplyTouchAttackDamage(oCaster, oTarget, nTouchAttack, nDamageRTA, DAMAGE_TYPE_MAGICAL, TRUE);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}	
	}
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
		
	      	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);
               	nDamage += nDice;
                   	
	        if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	        {
		        nDamage /= 2;
               	}		
		effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_COLD);	               	
               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
               	DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
               	DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 9.0));
               	
	//Select the next target within the spell shape.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, fWidth, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
    }
}