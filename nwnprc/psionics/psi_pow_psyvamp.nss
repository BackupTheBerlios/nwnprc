/*
   ----------------
   Psychic Vampire
   
   prc_pow_psyvamp
   ----------------

   17/5/05 by Stratovarius

   Class: Psion (Egoist), Psychic Warrior
   Power Level: 4
   Range: Touch
   Target: One Creature
   Duration: Instantaneous
   Saving Throw: Fortitude negates
   Power Resistance: Yes
   Power Point Cost: 7
   
   This power shrouds your hand in with a darkness you can use to drain an opponent's power. If you make a successful melee touch
   attack and the victim fails its save, you drain 2 power points for every manifester level you have. These points are simply lost.
   Against a creature with no power points or one that is not psionic, you deal 2 damage to Int, Wis, and Cha. 
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
    int nAugCost = 0;
    int nAugment = GetAugmentLevel(oCaster);
    object oTarget = GetSpellTargetObject();
    int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, METAPSIONIC_TWIN, 0);

    
    if (nMetaPsi > 0) 
    {
	int nDC = GetManifesterDC(oCaster);
	int nCaster = GetManifesterLevel(oCaster);
	int nPen = GetPsiPenetration(oCaster);
			
	effect eVis = EffectVisualEffect(246);
	int nTargetPP = GetLocalInt(oTarget, "PowerPoints");
	
	// Perform the Touch Attach
	int nTouchAttack = TouchAttackMelee(oTarget);
	if (nTouchAttack > 0)
	{
		//Check for Power Resistance
		if (PRCMyResistPower(oCaster, oTarget, nPen))
		{
		        //Fire cast spell at event for the specified target
		        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
	               	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NONE))
	               	{
	               		if (nTargetPP != 0)
	               		{
	               			nTargetPP -= (2 * nCaster);
	               			if (nTargetPP < 0) nTargetPP = 0;
	               			SetLocalInt(oTarget, "PowerPoints", nTargetPP);
	               		}
	               		else
	               		{
	               			ApplyAbilityDamage(oTarget, ABILITY_CHARISMA, 2, DURATION_TYPE_PERMANENT);
                    			ApplyAbilityDamage(oTarget, ABILITY_WISDOM, 2, DURATION_TYPE_PERMANENT);
                    			ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, 2, DURATION_TYPE_PERMANENT);
                    		}
	               		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	              	}
		}
	}
    }
}