/*
   ----------------
   Hammer
   
   prc_all_hammer
   ----------------

   31/10/04 by Stratovarius

   Class: Psion/Wilder, Psychic Warrior
   Power Level: 1
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   This power charges your touch with the force of a sledgehammer. A successful melee
   touch attack deals 1d8 bludgeoning damage.
   
   Augment: For every additional power point spent, this power's damage increases by 1d8. 
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
	effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
	int nDice = 1;
	int nDiceSize = 8;
			
	//Augmentation effects to Damage
	if (nAugment > 0) nDice += nAugment;
	
	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackMelee(oTarget);
	if (nTouchAttack > 0)
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	

    }
}