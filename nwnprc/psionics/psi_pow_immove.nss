/*
   ----------------
   Immovability
   
   psi_pow_immove
   ----------------

   13/12/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: Self
   Duration: Concentration
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 7
   
   You mentally attach yourself to the underlying fabric of the plane, making you impossible to move. You gain a +20 bonus to 
   Discipline, and damage resistance of 15/-. This power will also stop any attempt made to teleport the subject.
   The concentration check has a DC of 14 + damage taken during the round. To cancel the power at any time, simply recast the power.
*/

#include "psi_inc_psifunc"
#include "psi_inc_pwresist"
#include "psi_spellhook"
#include "prc_alterations"
#include "prc_inc_teleport"

void DoConcentrationCheck(object oCaster, int nSpell)
{
	// DC is 10 + power level (4) + damage taken during the round
	int nHP = GetLocalInt(oCaster, "ConcentrationHitpoints");
	// Check for HP lost over the previous round
	nHP = nHP - GetCurrentHitPoints(oCaster);
	// Base DC
	int nDC = 14;
	// If he lost HP, add the damage to the DC
	if (nHP > 0) nDC += nHP;

	int nCheck = GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, nDC);
	if (!nCheck)
	{
		// Fail the check, get rid of the spell
		RemoveSpellEffects(nSpell, oCaster, oCaster);
		// Clean up the int
		DeleteLocalInt(oCaster, "ConcentrationHitpoints");
		// Can teleport again
		AllowTeleport(oCaster);
	}
	else 
	{
		// Store their HP to see what happens over the next round.
		SetLocalInt(oCaster, "ConcentrationHitpoints", GetCurrentHitPoints(oCaster));
		DelayCommand(6.0f, DoConcentrationCheck(oCaster, nSpell));
	}
}

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

    // Code to cancel spell if still in effect
    if (GetHasSpellEffect(GetSpellId(), oCaster))
    {
    	RemoveSpellEffects(GetSpellId(), oCaster, oCaster);
    	// Clean up the int
	DeleteLocalInt(oCaster, "ConcentrationHitpoints");
	// Can teleport again
	AllowTeleport(oCaster);
    	return;
    }

    int nAugCost = 0;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);    
    
    if (nMetaPsi > 0) 
    {
    	int nCaster = GetManifesterLevel(oCaster);
    	int nDur = nCaster;
    	

        effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
    	effect eDur = EffectVisualEffect(VFX_DUR_STONEHOLD);
    	effect eImmob = EffectCutsceneImmobilize();
    	effect eDRB = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 15);
	effect eDRP = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 15);
        effect eDRS = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 15);
        effect eDisc = EffectSkillIncrease(SKILL_DISCIPLINE, 20);
    	effect eLink = EffectLinkEffects(eVis, eDur);    	
        eLink = EffectLinkEffects(eLink, eImmob);
        eLink = EffectLinkEffects(eLink, eDRB);
        eLink = EffectLinkEffects(eLink, eDRP);
        eLink = EffectLinkEffects(eLink, eDRS);
        eLink = EffectLinkEffects(eLink, eDisc);
    	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDur),TRUE,-1,nCaster);
	// Start concentrating.
	DoConcentrationCheck(oCaster, GetSpellId());
	// Stops teleporting
	DisallowTeleport(oTarget);
    }
}