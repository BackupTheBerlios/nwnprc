//::///////////////////////////////////////////////
//:: Insightful Reflexes
//:: prc_ft_insghtref.nss
//:://////////////////////////////////////////////
/*
    Replaces Dexterity mod with Intelligence mod on Reflex saves.
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
	
	// If Dex is larger, we need to reduce the reflex bonus
	if (nDex > nInt)
	{
		// Amount to reduce by
		nMod = nDex - nInt;
		effect eDecrease = EffectSavingThrowDecrease(SAVING_THROW_REFLEX, nMod);
		eDecrease = ExtraordinaryEffect(eDecrease);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecrease, oPC);
	}
	// Does not check if Dex is equal to Int, since in that case you do nothing
	// Apply a bonus if Int is higher than Dex
	if (nInt > nDex)
	{
		// Amount to increase by
		nMod = nInt - nDex;
		effect eIncrease = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nMod);
		eIncrease = ExtraordinaryEffect(eIncrease);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncrease, oPC);
	}	
}