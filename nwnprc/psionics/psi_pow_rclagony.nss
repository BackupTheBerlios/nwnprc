/*
    ----------------
    Recall Agony
    
    psi_all_rclagony
    ----------------

    28/10/04 by Stratovarius

    Class: Psion/Wilder
    Power Level: 2
    Range: Medium
    Target: One Creature
    Duration: Instantaneous
    Saving Throw: Will half
    Power Resistance: Yes
    Power Point Cost: 3
 
    The fabric of time parts to your will, revealing wounds the foe has recieved in the past.
    That foe takes 2d6 damage as the past impinges on the present.

    Augment: For every additional power point spent, this power's damage increases by 1d6.
    For each extra 2d6 of damage, the DC increases by 1.
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
	effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
	int nDice = 2;
	int nDiceSize = 6;
	
	//Augmentation effects to Damage
	if (nAugment > 0) 
	{
		nDice += nAugment;
		nDC += nAugment/2;
	}
	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
		
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		
	        //Make a saving throw check
		if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	        {
		        nDamage /= 2;
	        }
	        effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
	        //Apply the VFX impact and effects
	        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}

    
    }
}