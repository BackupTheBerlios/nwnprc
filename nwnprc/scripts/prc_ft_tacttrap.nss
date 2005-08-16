//::///////////////////////////////////////////////
//:: Tactile Trapsmith
//:: prc_ft_tacttrap.nss
//:://////////////////////////////////////////////
/*
    Replaces Int mod with Dex mod on Search and Disable Trap checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 16 August 2005
//:://////////////////////////////////////////////

void main()
{
	object oPC = OBJECT_SELF;
	int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
	int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
	int nMod;
	
	// If Int is larger, we need to reduce the bonus
	if (nInt > nDex)
	{
		// Amount to reduce by
		nMod = nInt - nDex;
		effect eSearch = EffectSkillDecrease(SKILL_SEARCH, nMod);
		effect eTrap = EffectSkillDecrease(SKILL_DISABLE_TRAP, nMod);
		effect eDecrease = EffectLinkEffects(eSearch, eTrap);
		eDecrease = ExtraordinaryEffect(eDecrease);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecrease, oPC);
	}
	// Does not check if Dex is equal to Int, since in that case you do nothing
	// Apply a bonus if Dex is higher than Int
	if (nDex > nInt)
	{
		// Amount to increase by
		nMod = nDex - nInt;
		effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nMod);
		effect eTrap = EffectSkillIncrease(SKILL_DISABLE_TRAP, nMod);
		effect eIncrease = EffectLinkEffects(eSearch, eTrap);
		eIncrease = ExtraordinaryEffect(eIncrease);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncrease, oPC);
	}	
}