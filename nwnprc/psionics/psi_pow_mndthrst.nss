/*
   ----------------
   Mind Thrust
   
   prc_all_mndthrst
   ----------------

   21/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Will negates
   Power Resistance: Yes
   Power Point Cost: 1
   
   You instantly deliver a massive assault on the thought pathways of any 
   one creature, dealing 1d10 points of damage to it.
   
   Augment: For every additional power point spend, this power's damage increases by 1d10. 
   For each extra 2d10 points of damage, this power's save DC increases by 1.
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
    
    //FloatingTextStringOnCreature("You have manifested Mind Thrust", oCaster, FALSE);
    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nDice = 1;
	int nDiceSize = 10;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDice += nAugment;
		nDC += nAugment/2;
	}
	
	int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
	
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	effect eLink = EffectLinkEffects(eMind, eDam);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nCaster))
	{
	
	//FloatingTextStringOnCreature("Target has failed its Power Resistance Check", oCaster, FALSE);
		
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_RAY));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
	}
    }
}