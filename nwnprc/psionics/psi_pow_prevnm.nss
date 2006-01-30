/*
   ----------------
   Prevenom
   
   psi_pow_prevnm
   ----------------

   29/10/05 by Ornedan

   Class: Psychic Warrior
   Power Level: 1
   Range: Personal
   Target: One Natural Attack
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 1
   
   If you have a claw attack, or a bite attack, you can use this power to coat your claws in a mild venom.
   On your next successful melee attack, the venom deals 2 points of Constitution damage. A target struck by the poison
   can make a save vs 10 + 1/2 Manifester Level + Manifesting Ability Modifier to negate the damage.
   
   Augment: For every 6 additional power points, the Constitution damage increases by 2.
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
	    	FloatingTextStringOnCreature("You do not have a valid target for Prevenom", oCaster, FALSE);
	    	return;
    	}
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
	int nCasterLvl = GetManifesterLevel(oCaster);
	int nAugment = GetLocalInt(oCaster, "Augment");
	int nAugCost = 6;
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
			// Roll the damage here and store it on the weapon
			int nDamage = 2 + (2 * nAugment);
			SetLocalInt(oTarget, "Prevenom", nDamage);
	
	
			/* Add the onhit spell to the weapon */
			IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
			
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


