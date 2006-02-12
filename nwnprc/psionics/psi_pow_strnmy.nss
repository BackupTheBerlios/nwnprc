/*
   ----------------
   Strength of my Enemy
   
   psi_pow_strnmy
   ----------------

   14/12/05 by Stratovarius
*/ /** @file

    Strength of My Enemy

Psychometabolism
Level: Psychic warrior 2
Manifesting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 round/level
Power Points: 3
Metapsionics: Extend

You gain the ability to siphon away your enemy’s strength for your own use. One of your natural or manufactured weapons becomes the instrument of your desire, and deals 1 point of Strength damage on each successful hit. You gain that point of Strength as an enhancement bonus to your Strength score. Strength you siphon from different foes is tracked separately - the total siphoned from each individual foe is considered a separate enhancement bonus to your Strength (maximum +8), and you gain only the highest total.

Augment: For every 3 additional power points you spend, the maximum enhancement bonus you can add to your Strength increases by 2.


   Class: Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: You
   Duration: 1 Round/level
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   You gain the ability to siphon away your enemy's strength for your own use. One of your weapons gains the ability to drain strength
   and deals 1 strength damage on each successful hit. You gain that point of strength as a bonus. Strength you drain from different
   enemies is tracked seperately, and you only gain the highest drain as a bonus to your strength, with a maximum of +8 to strength.
   
   Augment: For every 3 additional power points spent, the maximum strength bonus possible increases by 2. 
*/


#include "spinc_common"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

// This is used to apply the Strength Bonus for the proper length of time
void RoundTimer(object oCaster)
{
	int nRound = GetLocalInt(oCaster, "StrengthEnemyRound");
	// If time has run out, delete the int.
	if (0 >= nRound)
	{
		DeleteLocalInt(oCaster, "StrengthEnemyRound");
	}
	else 
	{
		// otherwise, keep going, subtracting a round
		SetLocalInt(oCaster, "StrengthEnemyRound", (nRound - 1));
		DelayCommand(6.0f, RoundTimer(oCaster));
	}
}

void main()
{
if (!PsiPrePowerCastCode()){ return; }
// End of Spell Cast Hook



	object oCaster = OBJECT_SELF;
	// Can be either a claw or a weapon, so we check weapon first then see if he has a claw.
	// If there is neither, then tell him so and flunk the power
	object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
	if (!GetIsObjectValid(oTarget))
	{
		oTarget = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster);
		if (!GetIsObjectValid(oTarget))
		{
		    	FloatingTextStringOnCreature("You do not have a valid target for Strength of my Enemy", oCaster, FALSE);
		    	return;
	    	}
    	}
	int nCasterLvl = GetManifesterLevel(oCaster);
	int nAugCost = 3;
	int nAugment = GetAugmentLevel(oCaster);
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, METAPSIONIC_EXTEND, 0, 0, 0, 0);

	if (nMetaPsi > 0)
	{
		int nCaster = GetManifesterLevel(oCaster);
		int nDur = nCaster;
		if (nMetaPsi == 2) nDur *= 2;	
		effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
		effect eVis2 = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
		int nMax = 8;
		if (nAugment > 0) nMax += (nAugment * 2);
		
		if(GetIsObjectValid(oTarget))
		{
			/* Add the onhit spell to the weapon */
			IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), RoundsToSeconds(nDur), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			SetLocalInt(oCaster, "StrengthEnemyActive", TRUE);
			SetLocalInt(oCaster, "StrengthEnemyMax", nMax);
			// For dispelling the Str boost, make sure the manifester level is correct
			SetLocalInt(oCaster, "StrengthEnemyCaster", nCaster);			
			// This keeps track of the strength boost. It starts at 0
			SetLocalInt(oCaster, "StrengthEnemyBonus", 0);
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "StrengthEnemyActive"));
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "StrengthEnemyMax"));
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "StrengthEnemyBonus"));
			DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oCaster, "StrengthEnemyCaster"));
			
			/* Apply the VFX to whatever is wielding the target */
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, GetItemPossessor(oTarget));
			
			// Keeps track of how many rounds are left to the power
			SetLocalInt(oCaster, "StrengthEnemyRound", nDur);
			DelayCommand(6.0f, RoundTimer(oCaster));
		}
		else
		{
			FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // Item must be weapon or creature holding a weapon
			return;
		}

	}
}