/*
   ----------------
   Microcosm
   
   prc_pow_microcos
   ----------------

   26/2/05 by Stratovarius

   Class: Psion/Wilder
   Power Level: 9
   Range: Close
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 17
   
   You warp the consciousness of the victim, sending it into a catatonic state. If that creature has less than 100 hitpoints,
   the target sprawls limply, drooling and mewling on the ground. This effect is permanent.
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
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);    
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect ePara = EffectCutsceneParalyze();
	effect eKD = EffectKnockdown();
	effect eBlind = EffectBlindness();
	effect eDeaf = EffectDeaf();
	effect eDur = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
	effect eLink = EffectLinkEffects(ePara, eKD);
	eLink = EffectLinkEffects(eLink, eBlind);
	eLink = EffectLinkEffects(eLink, eDeaf);
	eLink = EffectLinkEffects(eLink, eDur);
	eLink = SupernaturalEffect(eLink);
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
                if (GetCurrentHitPoints(oTarget) <= 100)
                {		
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		}	
	}
    }
}