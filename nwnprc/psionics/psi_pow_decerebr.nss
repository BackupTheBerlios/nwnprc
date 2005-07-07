/*
    ----------------
    Decerebrate
    
    psi_pow_decerebr
    ----------------

    25/2/05 by Stratovarius

    Class: Psion/Wilder
    Power Level: 7
    Range: Close
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Fortitude negates
    Power Resistance: Yes
    Power Point Cost: 13
 
    With decerebrate, you selectively remove a portion of the creatures brain stem. The creature loses all cerebral functions,
    vision, hearing, and the ability to move. If greater restoration is cast on the target within 1 hour, the target lives. 
    Otherwise, the target will die from the brain damage.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "x2_i0_spells"

void DieMaggot(int nSpellID, object oCaster, object oTarget)
{
	if (GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster) && GetLocalInt(oTarget, "WasRestored"))
	{
		effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
    		effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    		effect eDeath = EffectDeath();
    		effect eLink2 = EffectLinkEffects(eVis, eVis2);
    		eLink2 = EffectLinkEffects(eLink2, eDeath);
    		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
    	}		
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 1);

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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);

	// spam those effect chains, weee
    	effect eParal = EffectParalyze();
    	if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS)) 	eParal = EffectCutsceneParalyze();
    	effect eBlind =  EffectBlindness();
	effect eDeaf = EffectDeaf();
	effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eVis2 = EffectVisualEffect(82);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
	effect eLink = EffectLinkEffects(eParal, eBlind);
	eLink = EffectLinkEffects(eLink, eDeaf);
	eLink = EffectLinkEffects(eLink, eVis);
	eLink = EffectLinkEffects(eLink, eVis2);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = EffectLinkEffects(eLink, eDur2);
	eLink = EffectLinkEffects(eLink, eDur3);

	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
	
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS)
		{
	               	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	       	{
               			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(1),TRUE,-1,nCaster);
               			DelayCommand((HoursToSeconds(1) + 1.0), DieMaggot(GetSpellId(), oCaster, oTarget));
	               	}
		}
	}
    }
}