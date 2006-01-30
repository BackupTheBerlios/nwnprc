/*
   ----------------
   Truevenom
   
   psi_pow_truvnm
   ----------------

   29/10/05 by Stratovarius

   Class: Psychic Warrior
   Power Level: 4
   Range: Personal
   Target: You
   Duration: 1 Min/level, or until discharged.
   Saving Throw: None, see Text.
   Power Resistance: No
   Power Point Cost: 7
   
   If you have a claw attack, or a bite attack, you can use this power to produce a horrible poison that coats your claw.
   On your next successful melee attack, the venom deals 1d8 points of Constitution damage, and 1d8 Con again 1 minute later.
   A target struck by the poison can make a save vs 14 + Manifesting Ability Modifier to negate the damage.
*/


#include "spinc_common"
#include "psi_inc_onhit"
#include "psi_inc_psifunc"
#include "psi_spellhook"

void main()
{
//SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
if (!PsiPrePowerCastCode()){ return; }
// End of Spell Cast Hook



	object oCaster = OBJECT_SELF;
	object oTarget = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster);
	if (!GetIsObjectValid(oTarget))
	{
	    	FloatingTextStringOnCreature("You do not have a valid target for Truevenom", oCaster, FALSE);
	    	return;
    	}
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
	int nCasterLvl = GetManifesterLevel(oCaster);
	int nAugCost = 0;
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, 0, 0, 0, 0, 0, 0);

	// Item possessor needs to be the caster
	if(GetItemPossessor(oTarget) != oCaster)
	{
		WriteTimestampedLogEntry("Error while processing spellscript psi_dissolv_wepn: Possessor of targeted weapon is other than the caster");
	}

	if (nMetaPsi > 0)
	{
		if(GetIsObjectValid(oTarget))
		{
			/* Add the onhit spell to the weapon */
			IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			SetLocalInt(oTarget, "Truevenom", TRUE);
			
			/* Apply the VFX to whatever is wielding the target */
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
		}
		else
		{
			FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // Item must be weapon or creature holding a weapon
			return;
		}

	}
}