/*
   ----------------
   Dissolving Weapon
   
   prc_all_disswpn
   ----------------

   19/1/05 by Ornedan

   Class: Psychic Warrior
   Power Level: 2
   Range: Personal
   Target: One held Weapon
   Duration: Instantaneous
   Saving Throw: None
   Power Resistance: No
   Power Point Cost: 3
   
   Your weapon is corrosive, dealing 4d6 points of acid damage on a successful strike.
   
   Augment: For every 2 additional power points spent, this power's damage increases by 1d6. 
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
	object oTarget = IPGetTargetedOrEquippedMeleeWeapon();
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
	int nCasterLvl = GetManifesterLevel(oCaster);
	int nAugment = GetLocalInt(oCaster, "Augment");
	int nAugCost = 2;
	int nMetaPsi = GetCanManifest(oCaster, nAugCost, oTarget, 0, METAPSIONIC_EMPOWER, 0, METAPSIONIC_MAXIMIZE, 0, METAPSIONIC_TWIN, 0);

	// Item possessor needs to be the caster
	if(GetItemPossessor(oTarget) != oCaster)
	{
		WriteTimestampedLogEntry("Error while processing spellscript psi_dissolv_wepn: Possessor of targeted weapon is other than the caster");
	}

	if (nMetaPsi > 0)
	{
	
		if(GetIsObjectValid(oTarget))
		{
			// Signal spell being cast. Unnecessary, since the target is always the caster.
			//SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, POWER_DISSOLVINGWEAPON, FALSE));
	
			// Roll the damage here and store it on the weapon
			int nDamage = MetaPsionic(6, 4 + nAugment, nMetaPsi, oCaster);
			SetLocalInt(oTarget, "DissolvingWeaponDamage", nDamage);
	
	
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


