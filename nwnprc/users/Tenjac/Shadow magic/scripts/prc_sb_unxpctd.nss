//::///////////////////////////////////////////////
//:: Unseen Weapon: Unexpected Strike
//:: prc_sb_unxpctd.nss
//:://////////////////////////////////////////////
//:: Your enemy is denied their Dexterity bonus to
//:: AC on your next attack.
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	