//::///////////////////////////////////////////////
//:: Passive Feats
//:: prc_ft_passive.nss
//:://////////////////////////////////////////////
/*
    Because Saving throw bonuses as itemprops gets
    screwed by divine grace
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: 20 November 2005
//:: Modified By: Flaming_Sword
//:: Modified On: 20 November 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_FORCE_PERSONALITY);
        ActionCastSpellOnSelf(SPELL_FORCE_PERSONALITY);
    }
    if(GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_INSIGHTFUL_REFLEXES);
        ActionCastSpellOnSelf(SPELL_INSIGHTFUL_REFLEXES);
    }
    if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
    {
        PRCRemoveEffectsFromSpell(oPC, SPELL_INTUITIVE_ATK);
        //ActionCastSpellOnSelf(SPELL_INTUITIVE_ATK);
        ExecuteScript("prc_intuiatk", oPC); // Done this way to fix a TMI error.
    }
    if(GetHasFeat(FEAT_OBSCURE_LORE, oPC))
    {
        SetCompositeBonus(oSkin, "ObscureLore", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
    }    
    if(GetHasFeat(FEAT_HEAVY_LITHODERMS, oPC))
    {
        SetCompositeBonus(oSkin, "HeavyLithoderms", 1, AC_NATURAL_BONUS, ITEM_PROPERTY_AC_BONUS);
    }      
    if(GetHasFeat(FEAT_MORADINS_SMILE, oPC))
    {
            SetCompositeBonus(oSkin, "MoradinsSmileA",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
	    SetCompositeBonus(oSkin, "MoradinsSmileP",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
	    SetCompositeBonus(oSkin, "MoradinsSmilePe",  2, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
	    SetCompositeBonus(oSkin, "MoradinsSmileT",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_TAUNT);
	    SetCompositeBonus(oSkin, "MoradinsSmileUMD", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
	    SetCompositeBonus(oSkin, "MoradinsSmileB",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
    	    SetCompositeBonus(oSkin, "MoradinsSmileI",   2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    	    SetCompositeBonus(oSkin, "MoradinsSmileIj",  2, ITEM_PROPERTY_SKILL_BONUS,SKILL_IAIJUTSU_FOCUS);
    }   
    if(GetHasFeat(FEAT_MENACING_DEMEANOUR, oPC))
    {
        SetCompositeBonus(oSkin, "MenacingDemeanour", 4, ITEM_PROPERTY_SKILL_BONUS, SKILL_INTIMIDATE);
    } 
    if(GetHasFeat(FEAT_RELIC_HUNTER, oPC))
    {
        SetCompositeBonus(oSkin, "RelicHunterL", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        SetCompositeBonus(oSkin, "RelicHunterA", 5, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
    }     
}