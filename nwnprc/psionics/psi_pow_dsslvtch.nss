/*
   ----------------
   Dissolving Touch
   
   prc_all_dsslvtch
   ----------------

   27/10/04 by Stratovarius

   Class: Psychic Warrior
   Power Level: 2
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your touch is corrosive, dealing 4d6 points of acid damage on a successful melee touch attack.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6. 
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "X0_I0_SPELLS"

void main()
{
DeleteLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS");
SetLocalInt(OBJECT_SELF, "PSI_MANIFESTER_CLASS", 3);

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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);

    
    if (GetCanManifest(oCaster, nAugCost)) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	object oTarget = GetSpellTargetObject();
	int nDamage = d6(4);
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
			
	//Augmentation effects to Damage
	if (nAugment > 0) nDamage += d6(nAugment);
	
	effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
	
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