/*
   ----------------
   Empathic Transfer
   
   psi_pow_emptrn
   ----------------

   11/5/05 by Stratovarius

   Class: Psion (Egoist), PsyWar
   Power Level: 2
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You transfer another creature's wounds to yourself. When you manifest this, you can heal as much as 2d10 damage. The target gains
   hitpoints equal to the amount, and you lose hitpoints equal to half that amount. 
   
   Augment: For every additional power point spent, you can transfer an additional 2d10 points of damage (maximum of 10d10)
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
    object oTarget = GetSpellTargetObject();
    int nAugCost = 1;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, 0, 0);
   
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDice = 2;
	int nDiceSize = 10;
	
	//Augmentation effects to HD
	if (nAugment > 0) nDice += (nAugment * 2);
	if (nDice > 10) nDice = 10;
	
	int nDamage = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster, TRUE);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	effect eHeal = EffectHeal(nDamage);
	effect eDam = EffectDamage((nDamage/2), DAMAGE_TYPE_POSITIVE);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oCaster);
    }
}