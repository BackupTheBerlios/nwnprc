/*

This is a function to evaluate and apply SetBaseAttackBonus
after taking all the PRC sources into account and choosing one appropriately

Run from prc_inc_function EvalPRCFeats()

*/

#include "prc_alterations"
#include "prc_inc_natweap"

void main()
{
    object oPC = OBJECT_SELF;
    int nAttackCount = -1;
    int nOverflowAttackCount;
    
    //delete this local so GetMainHandAttacks() does a full calculation
    DeleteLocalInt(oPC, "OverrideBaseAttackCount");
    //count the number of class-derived attacks
    int nBAB = GetMainHandAttacks(oPC);
    
        
    //permanent type ones
    //conditions in which this applies
    if(GetIsUsingPrimaryNaturalWeapons(oPC))
    {
        //creature weapon test
        //get the value
        int nNaturalPrimary = GetLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT);
        nAttackCount = nNaturalPrimary;
    }
    else
    {    
        //monk correction
        if(GetLevelByClass(CLASS_TYPE_MONK, oPC))
            nAttackCount = nBAB;
        
        //temporary type ones
        if(GetHasSpellEffect(SPELL_DIVINE_POWER, oPC)
            && nBAB < 4)
        {
            int nDPAttackCount = GetLocalInt(oPC, "AttackCount_DivinePower");
            if(nDPAttackCount > nAttackCount)
                nAttackCount = nDPAttackCount;
        }
        if(GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION, oPC)
            && nBAB < 4)
        {
            int nTTAttackCount = GetLocalInt(oPC, "AttackCount_TensersTrans");
            if(nTTAttackCount > nAttackCount)
                nAttackCount = nTTAttackCount;
        }       
    }
    
    
    //offhand calculations
    int nOffhand = 0;
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
    {
        nOffhand = 1;
        if(GetHasFeat(FEAT_PERFECT_TWO_WEAPON_FIGHTING, oPC))
        {
            if(nAttackCount == -1)
                nOffhand = nBAB;
            else    
                nOffhand = nAttackCount;
        }    
        else if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC))
            nOffhand = 4;
        else if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC))
            nOffhand = 3;
        else if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC))
            nOffhand = 2;
        //tempests in medium/heavy armor, or using double weapons, only have 1 off-hand attack
        //this applies even if they take perfect 2-weapon fighting
        if(GetLevelByClass(CLASS_TYPE_TEMPEST, oPC))            
        {   
            object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
            object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
            object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                      
            int nArmorType = GetArmorType(oArmor);
            if (oArmor == OBJECT_INVALID) 
                nArmorType = ARMOR_TYPE_LIGHT;
            if(nArmorType != ARMOR_TYPE_LIGHT
                || oWeapL == OBJECT_INVALID 
                || GetBaseItemType(oWeapL) == BASE_ITEM_LARGESHIELD 
                || GetBaseItemType(oWeapL) == BASE_ITEM_TOWERSHIELD 
                || GetBaseItemType(oWeapL) == BASE_ITEM_SMALLSHIELD 
                || GetBaseItemType(oWeapL) == BASE_ITEM_TORCH)
                nOffhand = 1;
        }   
            
        if(nOffhand <= 2)
            DeleteLocalInt(oPC, "OffhandOverflowAttackCount");
        else 
            SetLocalInt(oPC, "OffhandOverflowAttackCount", nOffhand-2);
    }    
    
    //default
    if(nAttackCount == -1)
    {
        RestoreBaseAttackBonus(oPC);
        DeleteLocalInt(oPC, "OverrideBaseAttackCount");
        DeleteLocalInt(oPC, "OverflowBaseAttackCount");
        DeleteLocalInt(oPC, "OffhandOverflowAttackCount");
    }    
    if(nAttackCount != -1)
    {
        //apply the cap
        //max is 12 attacks, 3 flurries of 4, for both on and off hands
        //offhand can be 2 at most since th others are scripted anyway
        int nCap = 12 - max(nOffhand,2);
        if(nAttackCount > nCap)
        {       
            nOverflowAttackCount += nAttackCount-nCap;
            nAttackCount = nCap;
        }    
        if(nOverflowAttackCount)    
        {    
            SetLocalInt(oPC, "OverflowBaseAttackCount", nOverflowAttackCount);
        }
        DoDebug("SetBaseAttackBonus("+IntToString(nAttackCount)+", "+GetName(oPC)+"));");
        SetBaseAttackBonus(nAttackCount, oPC);
        SetLocalInt(oPC, "OverrideBaseAttackCount", nAttackCount);
    }
    
}