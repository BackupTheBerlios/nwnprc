/*
   ----------------
   Disintegrate
   
   prc_all_disin
   ----------------

   27/10/04 by Stratovarius

   Class: Psion/Wilder
   Power Level: 6
   Range: Long
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude partial
   Power Resistance: Yes
   Power Point Cost: 11
   
   A thin ray springs from your fingers at the target. You must succeed on a ranged touch attack
   to deal damage to the target. The ray deals 22d6 points of damage.
   
   Augment: For every additional power point spend, the target takes an additional
   2d6 points of damage if it fails its save.
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
	int nDice = 22;
	int nDiceSize = 6;
	
	effect eRay = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
		
	if (nSurge > 0) nAugment += nSurge;
	
	//Augmentation effects to Damage
	if (nAugment > 0) nDice += (2 * nAugment);
	
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nCaster))
		{
			if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
			{
				nDice = 5;
			}
			int nDamage = MetaPsionics(nDiceSize, nDice, oCaster);
			effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
		}
	}
	

    }
}