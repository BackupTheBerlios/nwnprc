/*
   ----------------
   Mindwipe
   
   prc_pow_mindwipe
   ----------------

   19/2/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 4
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   You partially wipe your victim's mind of past experiences, bestowing two negative levels.
   
   Augment: For every 3 additional power points spend, this power bestows an extra negative level.
   For every 2 additional power points spent in this way, the DC increases by 1.
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
    int nAugCost = 3;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDrain = 2;
	
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDrain += nAugment;
		nDC += (nAugment * 3)/2;
	}
	
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    	effect eDrain = EffectNegativeLevel(nDrain);
    	effect eLink = EffectLinkEffects(eDrain, eDur);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
                {
                        //Apply VFX Impact and daze effect
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(2),TRUE,-1,nCaster);
                }
	}
    }
}