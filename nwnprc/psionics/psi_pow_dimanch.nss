/*
   ----------------
   Dimensional Anchor
   
   prc_pow_dimanch
   ----------------

   8/4/05 by Stratovarius

   Class: Psion (Nomad)
   Power Level: 4
   Range: Medium
   Target: One Creature
   Duration: 1 Min/level
   Saving Throw: None
   Power Resistance: Yes
   Power Point Cost: 7
   
   A ray springs from your outstretched hand. You must make a ranged touch attack to hit the target. Any creature hit by the ray
   is covered by a shimmering field that completely blocks extradimensional movement. Forms of movement barred by dimensional anchor
   include dimension door, ethereal jaunt, astral travel, gate, shadow walk, teleport, and similar spells. 
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
    int nSurge = GetLocalInt(oCaster, "WildSurge");
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, METAPSIONIC_TWIN, 0);
    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
	effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
	effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
	float fDur = 60.0 * nCaster;
	if (nMetaPsi == 2)	fDur *= 2;
	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackRanged(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);
			SetLocalInt(oTarget, "DimAnchor", TRUE);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur,TRUE,-1,nCaster);
			DelayCommand(fDur, DeleteLocalInt(oTarget, "DimAnchor"));
		}
	}
	

    }
}