#include "inc_item_props"

const int ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE      = 86;
const int ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS        = 87;
const int ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL        = 88;
const int ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL = 89;
const int ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL = 90;
const int ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK       = 91;

int CheckPRCLimitations(object oItem, object oPC)
{

    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bPass = TRUE;
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE)
        {
            int nValue = GetItemPropertyCostTableValue(ipTest);
            int nAbility = GetItemPropertySubType(ipTest);
            object oHide = GetPCSkin(oPC);
            int nTrueValue;
            switch(nAbility)
            {
                case ABILITY_STRENGTH:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueSTR");
                    break;
                case ABILITY_DEXTERITY:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueDEX");
                    break;
                case ABILITY_CONSTITUTION:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueCON");
                    break;
                case ABILITY_INTELLIGENCE:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueINT");
                    break;
                case ABILITY_WISDOM:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueWIS");
                    break;
                case ABILITY_CHARISMA:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueCHA");
                    break;
            }
            if(nTrueValue < nValue)
			bPass = FALSE;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS)
        {
            int nValue = GetItemPropertyCostTableValue(ipTest);
            int nSkill = GetItemPropertySubType(ipTest);
            int nTrueValue = GetSkillRank(nSkill, oPC);
            if(nTrueValue < nValue)
			bPass = FALSE;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_AllSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_ArcSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_DivSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_SneakLevel"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
        }
        ipTest = GetNextItemProperty(oItem);
    }
    return bPass;
}