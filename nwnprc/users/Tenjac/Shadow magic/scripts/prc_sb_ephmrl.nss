//::///////////////////////////////////////////////
//:: Unseen Weapon: Ephemeral Weapon
//:: prc_sb_ephmrl.nss
//:://////////////////////////////////////////////
//:: Your next attack does an extra 2d6 damage.
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oWeapon2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
	
	void PerformAttackRound(object oDefender, object oAttacker, effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0, int iDamageModifier = 0, int iDamageType = 0, int bEffectAllAttacks = FALSE, string sMessageSuccess = "", string sMessageFailure = "", int bApplyTouchToAll = FALSE, int iTouchAttackType = FALSE, int bInstantAttack = FALSE);
	
	// Performs a single attack and can add in bonus damage damage/effects
	// If the first attack hits, a local int called "PRCCombat_StruckByAttack" will be TRUE
	// on the target for 1 second.
	//
	// eSpecialEffect -  any special Vfx or other effects the attack should use IF successful.
	// eDuration - Changes the duration of the applied effect(s)
	//           0.0 = DURATION_TYPE_INSTANT, effect lasts 0.0 seconds.
	//          >0.0 = DURATION_TYPE_TEMPORARY, effect lasts the amount of time put in here.
	//          <0.0 = DURATION_TYPE_PERMAMENT!!!!!  Effect lasts until dispelled.
	// iAttackBonusMod is the attack modifier - Will effect all attacks if bEffectAllAttacks is on
	// iDamageModifier - should be either a DAMAGE_BONUS_* constant or an int of damage.
	//                   Give an int if the attack effects ONLY the first attack!
	// iDamageType = DAMAGE_TYPE_*
	// sMessageSuccess - message to display on a successful hit. (i.e. "*Sneak Attack Hit*")
	// sMessageFailure - message to display on a failure to hit. (i.e. "*Sneak Attack Miss*")
// iTouchAttackType - TOUCH_ATTACK_* const - melee, ranged, spell melee, spell ranged