#include "prc_alterations"
#include "prc_inc_sneak"

void SpiritsFavour(object oPC, int nClass)
{
       	if (nClass >= 5)
       	{
       		int nSave = GetAbilityModifier(ABILITY_CHARISMA, oPC);
        	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, nSave);
        	       eSave = EffectLinkEffects(eSave, EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave));
        	       eSave = EffectLinkEffects(eSave, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nSave));
        	ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eSave), oPC);
        }
}

void SpiritSight(object oPC, int nClass)
{
    if (nClass >= 2) ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectSeeInvisible()), oPC);
}

void main()
{
	object oPC = OBJECT_SELF;
    	int nClass = GetLevelByClass(CLASS_TYPE_SHAMAN, oPC);

        SpiritsFavour(oPC, nClass);
        SpiritSight(oPC, nClass);
}
