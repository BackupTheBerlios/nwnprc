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

	// Item possessor needs to be the caster
	if(GetItemPossessor(oTarget) != oCaster)
	{
		WriteTimestampedLogEntry("Error while processing spellscript psi_dissolv_wepn: Possessor of targeted weapon is other than the caster");
	}

	// Check if the manifester can
	if(!GetCanManifest(oCaster, 1, oTarget)) //, METAPSIONIC_CHAIN | METAPSIONIC_EMPOWER | METAPSIONIC_MAXIMIZE))
		return;



	if(GetIsObjectValid(oTarget))
	{
		// Signal spell being cast. Unnecessary, since the target is always the caster.
		//SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, POWER_DISSOLVINGWEAPON, FALSE));

		// Roll the damage here and store it on the weapon
		int nDamage = MetaPsionic(6, 4 + nAugment, oCaster);
		SetLocalInt(oTarget, "DissolvingWeaponDamage", nDamage);


		/* Add the onhit spell to the weapon */
		itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1);
		
		// First, check if something else adds the unique onhit.
		// If nothing does, then we should remove it once the effect has been used up
		if(!IPGetItemHasProperty(oTarget, ip, -1))
			SetLocalInt(oTarget, "DissolvingWeapon_DoDelete", TRUE);
		
		
		AddItemProperty(DURATION_TYPE_TEMPORARY, ip , oTarget, 9999.0);
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF); // Item must be weapon or creature holding a weapon
		return;
	}

//SPSetSchool();
}


