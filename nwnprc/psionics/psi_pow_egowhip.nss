/*
    ----------------
    Ego Whip
    
    psi_all_egowhip
    ----------------

    6/11/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 3
 
    Your rapid mental lashings assault the ego of the target, debilitating its confidence. 
    The target takes 1d4 points of Charisma damage, or half that amount on a save (minimum 1). 
    A target that fails its save is also dazed for one round.

    Augment: For every 4 additional power points spent, this power's Charisma damage increases by 1d4,
    and the save DC increases by 2.
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
    int nAugCost = 4;
    int nAugment = GetAugmentLevel(oCaster);
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);
    
    if (nSurge > 0)
    {
    	
    	PsychicEnervation(oCaster, nSurge);
    }
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	effect eRay = EffectBeam(VFX_BEAM_FIRE_LASH, OBJECT_SELF, BODY_NODE_HAND);
	int nDice = 1;
	int nDiceSize = 4;
	
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eDaze = EffectDazed();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eDaze);
    	eLink = EffectLinkEffects(eLink, eDur);
	
			
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 	
	{
		nDice += nAugment;
		nDC += (nAugment * 2);
	}

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
		int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
		
                //Make a saving throw check
                if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NONE))
                {
                    nDamage /= 2;
                    if (nDamage < 1)	nDamage = 1;
                }
                else 
                {	
                	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),TRUE,-1,nCaster);
                }
                effect eDam = EffectAbilityDecrease(ABILITY_CHARISMA, nDamage);
                //Apply the VFX impact and effects
                DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oTarget, HoursToSeconds(24),TRUE,-1,nCaster);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7 ,FALSE);
	}
    }
}