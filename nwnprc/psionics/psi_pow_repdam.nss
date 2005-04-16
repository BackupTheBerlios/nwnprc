/*
   ----------------
   Psionic Repair Damage
   
   prc_pow_repdam
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 2
   Range: Touch
   Target: One Construct
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   When laying your hands upon a construct, you reknit its structure to repair damage it has taken. The power repairs
   3d8 + 1 point per manifester level. 
   
   Augment: For every 2 additional power points spent, this power heals an extra 1d8.
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
    int nAugCost = 2;
    int nAugment = GetAugmentLevel(oCaster);
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
	int nDice = 3;
	int nDiceSize = 12;    	
    
    	// Augmentation effects to point transfer
	if (nAugment > 0)	nDice += nAugment;
	
	//Apply effects
	
	int nHP = MetaPsionics(nDiceSize, nDice, nMetaPsi, oCaster);
	nHP += nCaster;
	
	effect eHeal = EffectHeal(nHP);
	effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_L);
	
	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT)
	{
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
	}
	
    }
}
