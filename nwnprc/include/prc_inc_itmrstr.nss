#include "inc_item_props"
#include "inc_utility"

const int ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE      = 86;
const int ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS        = 87;
const int ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL        = 88;
const int ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL = 89;
const int ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL = 90;
const int ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK       = 91;

int DoUMDCheck(object oItem, object oPC, int nDCMod)
{
    string s2DAEntry;
    int nValue = GetGoldPieceValue(oItem);
    int n2DAValue = StringToInt(s2DAEntry);
    int nSkill = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);

    //doesnt have UMD
    if(!GetHasSkill(SKILL_USE_MAGIC_DEVICE, oPC))
        return FALSE;

    int i;
    while(n2DAValue < nValue)
    {
        s2DAEntry = Get2DACache("skillvsitemcost", "DeviceCostMax", i);
        n2DAValue = StringToInt(s2DAEntry);
        i++;
    }
    i--;
    string s2DAReqSkill = Get2DACache("skillvsitemcost", "SkillReq_Class", i);
//PrintString("UMD check with value "+IntToString(nValue)+" of "+IntToString(n2DAValue)+" and UMD "+IntToString(nSkill)+" of "+s2DAReqSkill);
    //item is off the scale of expense
    if(s2DAReqSkill == "")
        return FALSE;

    int nReqSkill = StringToInt(s2DAReqSkill);
    //class is a dc20 test
    nReqSkill = nReqSkill - 20 + nDCMod;
    if(nReqSkill > nSkill)
        return FALSE;
    else
        return TRUE;
}

int CheckPRCLimitations(object oItem, object oPC)
{

    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bPass = TRUE;
    int nUMDDC;
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
            nUMDDC += nValue-15;
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
            nUMDDC += nValue-10;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_AllSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_ArcSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_DivSpell"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_SneakLevel"+IntToString(nLevel));
            if(nValid)
			bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        ipTest = GetNextItemProperty(oItem);
    }
    if(!bPass)
        bPass = DoUMDCheck(oItem, oPC, nUMDDC);
    return bPass;
}