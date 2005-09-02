/*
   ----------------
   Ethereal Jaunt
   
   prc_pow_ethjaunt
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 7
   Range: Personal
   Target: Self
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 13
   
   You go to the Ethereal Plane. Taking any hostile action will end the power.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"

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
	object oFirstTarget = PRCGetSpellTargetObject();
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oFirstTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

	if (nMetaPsi > 0)
	{
		int nDC = GetManifesterDC(oCaster);
		int nCaster = GetManifesterLevel(oCaster);
		int nPen = GetPsiPenetration(oCaster);
		effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    		effect eSanc = EffectEthereal();
    		effect eLink = EffectLinkEffects(eDur, eSanc);
		int nDur = nCaster;
		if (nMetaPsi == 2)	nDur *= 2;

		SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oFirstTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oFirstTarget);		
	}
}