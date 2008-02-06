#include "prc_alterations"
#include "tob_inc_tobfunc"

void BattleClarity(object oPC)
{
        int nSave = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        // Can't be negative.
        if (0 > nSave) nSave = 0;
        // Charisma to Will saves
        effect eFort = ExtraordinaryEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nSave));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFort, oPC);
        if (DEBUG) DoDebug("Battle Clarity applied.");
}

void main()
{
	object oPC = OBJECT_SELF;
	BattleClarity(oPC);
}