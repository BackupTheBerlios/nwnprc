#include "inc_item_props"
#include "inc_utility"

const int ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE      = 86;
const int ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS        = 87;
const int ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL        = 88;
const int ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL = 89;
const int ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL = 90;
const int ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK       = 91;
const int ITEM_PROPERTY_USE_LIMITATION_GENDER             =150;
const int ITEM_PROPERTY_SPEED_INCREASE = 134;
const int ITEM_PROPERTY_SPEED_DECREASE = 135;


const string PLAYER_SPEED_INCREASE = "player_speed_increase";
const string PLAYER_SPEED_DECREASE = "player_speed_decrease";


//credit to silvercloud for this :)
void ApplySpeedIncrease(object oPC)
{
    int nSpeedMod = GetLocalInt(oPC, PLAYER_SPEED_INCREASE);
    //clean existing modification
    effect eTest = GetFirstEffect(oPC);

    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == OBJECT_SELF 
           && GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE 
           && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
           )
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }
    //add new modification
    if (nSpeedMod > 0)
    {
        // when applying start above 100%, since 100% equals base speed
        nSpeedMod += 100;

        effect eSpeedMod = SupernaturalEffect(EffectMovementSpeedIncrease(nSpeedMod));
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedMod, oPC));
    }
}

//credit to silvercloud for this :)
void ApplySpeedDecrease(object oPC)
{
    int nSpeedMod = GetLocalInt(oPC, PLAYER_SPEED_DECREASE);
    //clean existing modification
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == OBJECT_SELF
           && GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
           && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
           )
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }
    //add new modification
    if (nSpeedMod > 0)
    {
        //setting a decrease over 99 doesnt work
        if (nSpeedMod > 99) nSpeedMod = 99;

        effect eSpeedMod = SupernaturalEffect(EffectMovementSpeedDecrease(nSpeedMod));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedMod, oPC));
    }
}

//this is a scripted version of the bioware UMD check for using restricted items
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

//tests for use restrictions
//also appies effects for those IPs tat need them
int CheckPRCLimitations(object oItem, object oPC)
{

    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bPass = TRUE;
    int nUMDDC;
    int nSpeedIncrease = GetLocalInt(oPC, PLAYER_SPEED_INCREASE);
    int nSpeedDecrease = GetLocalInt(oPC, PLAYER_SPEED_DECREASE);
    object oSkin = GetPCSkin(oPC);
    
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
            nUMDDC += nValue-15;
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
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_GENDER)
        {
            int nIPGender = GetItemPropertySubType(ipTest);
            int nRealGender = GetGender(oPC);
            if(nRealGender != nIPGender)
                bPass = FALSE;
            nUMDDC += 5;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_SPEED_INCREASE)
        {
            int iItemAdjust = 0;
            int nCost = GetItemPropertyCostTableValue(ipTest);
            switch(nCost)
            {
                case 0: iItemAdjust = 10; break;
                case 1: iItemAdjust = 20; break;
                case 2: iItemAdjust = 30; break;
                case 3: iItemAdjust = 40; break;
                case 4: iItemAdjust = 50; break;
                case 5: iItemAdjust = 60; break;
                case 6: iItemAdjust = 70; break;
                case 7: iItemAdjust = 80; break;
                case 8: iItemAdjust = 90; break;
                case 9: iItemAdjust = 100; break;
            }
            if(GetItemLastUnequipped() == oItem) //unequip event
                nSpeedDecrease -= iItemAdjust;
            else
                nSpeedIncrease += iItemAdjust;
            SetLocalInt(oPC, PLAYER_SPEED_INCREASE, nSpeedIncrease);
            AssignCommand(oSkin, ApplySpeedIncrease(oPC));
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_SPEED_DECREASE)
        {
            int iItemAdjust = 0;
            int nCost = GetItemPropertyCostTableValue(ipTest);
            switch(nCost)
            {
                case 0: iItemAdjust = 10; break;
                case 1: iItemAdjust = 20; break;
                case 2: iItemAdjust = 30; break;
                case 3: iItemAdjust = 40; break;
                case 4: iItemAdjust = 50; break;
                case 5: iItemAdjust = 60; break;
                case 6: iItemAdjust = 70; break;
                case 7: iItemAdjust = 80; break;
                case 8: iItemAdjust = 90; break;
                case 9: iItemAdjust = 99; break;
            }   
            if(GetItemLastUnequipped() == oItem) //unequip event
                nSpeedDecrease -= iItemAdjust;
            else
                nSpeedDecrease += iItemAdjust;
            SetLocalInt(oPC, PLAYER_SPEED_DECREASE, nSpeedDecrease);
            AssignCommand(oSkin, ApplySpeedDecrease(oPC));
        }        
        ipTest = GetNextItemProperty(oItem);
    }
    if(!bPass)
        bPass = DoUMDCheck(oItem, oPC, nUMDDC);
    return bPass;
}