#include "prc_alterations"
#include "prc_inc_sneak"

void SpiritsFavour(object oPC, int nClass)
{
       	if (nClass >= 5)
       	{
       		int nSave = GetAbilityModifier(ABILITY_CHARISMA, oPC);
            object oSkin = GetPCSkin(oPC);
            SetCompositeBonus(oSkin,"SpiritsFavourRef",nSave,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_REFLEX);
            SetCompositeBonus(oSkin,"SpiritsFavourFort",nSave,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_FORTITUDE);
            SetCompositeBonus(oSkin,"SpiritsFavourWill",nSave,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_WILL);
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
