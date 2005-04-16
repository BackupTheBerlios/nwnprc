/*
   ----------------
   Astral Seed
   
   prc_pow_astseed
   ----------------

   9/4/05 by Stratovarius

   Class: Psion (Shaper)
   Power Level: 8
   Range: Close
   Target: Ground
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 15
   
   This power weaves strands of ectoplasm into a crystal containing the seed of your living mind. You may have only one seed in 
   existence at any one time. Until such time as you perish, the astral seed is totally inert. Upon dying, you are transported
   to the location of your astral seed, where you will spend a day regrowing a body. Respawning in this manner will cost a level. 
   If your astral seed is destroyed, the power will fail. 
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
	int nAugCost = 0;
	int nAugment = GetAugmentLevel(oCaster);
	object oFirstTarget = GetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, 0, 0, 0, 0, 0);

	if (nMetaPsi > 0)
	{
		if (!GetLocalInt(oCaster, "AstralSeed"))
		{
			object oSeed = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_plc_phylact", GetSpellTargetLocation());
			effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
			DelayCommand(0.5, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSeed));
			SetLocalInt(oCaster, "AstralSeed", TRUE);
			SetLocalObject(oCaster, "ASTRAL_SEED", oSeed);
		}
	}
}