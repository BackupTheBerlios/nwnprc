/*
   ----------------
   Destiny Dissonance
   
   prc_pow_destdiss
   ----------------

   15/7/05 by Stratovarius

   Class: Psion (Seer)
   Power Level: 1
   Range: Touch
   Target: Creature Touched
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 1
   
   Your mere touch grants your foe an imperfect, unfocused glimpse of the many possible futures in store. Unaccustomed to and 
   unable process this information, the subject becomes sickened.
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
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);
   
    
    if (nMetaPsi > 0)
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	int nDur = nCaster;
	if (nMetaPsi == 2)	nDur *= 2;

	effect eLink = CreateDoomEffectsLink();
	effect eImpact = EffectVisualEffect(VFX_IMP_DOOM);

	//Check for Power Resistance
	if (PRCMyResistPower(oCaster, oTarget, nPen))
	{
	    //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
			            
            //Apply VFX Impact and daze effect
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
	}
    }
}