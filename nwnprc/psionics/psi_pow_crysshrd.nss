/*
   ----------------
   Crystal Shard
   
   prc_all_crysshrd
   ----------------

   21/10/04 by Stratovarius

   Class: Psion / Wilder
   Power Level: 1
   Range: Short
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   You propel a razor-sharp crystal shard at your target. You must succeed on a ranged touch attack
   to deal damage to the target. The shard deals 1d6 of piercing damage.
   
   Augment: For every additional power point spend, this power's damage increases by 1d6. 
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
	object oTarget = GetSpellTargetObject();
	int nDice = 1;
	int nDiceSize = 6; 
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDice += nAugment;
	
	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	

    }
}