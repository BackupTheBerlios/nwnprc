#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"
#include "prc_inc_unarmed"
#include "inc_item_props"

void BrawlerDodge(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    int iLevel = 0;
    
    if(GetHasFeat(FEAT_BRAWLER_DODGE_1, oCreature))
       iLevel = 1;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_2, oCreature))
       iLevel = 2;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_3, oCreature))
       iLevel = 3;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_4, oCreature))
       iLevel = 4;
    if(GetHasFeat(FEAT_BRAWLER_DODGE_5, oCreature))
       iLevel = 5;

    if(GetLocalInt(oSkin, "BrawlerDodge") == iLevel) return;
    else SetCompositeBonus(oSkin, "BrawlerDodge", iLevel, ITEM_PROPERTY_AC_BONUS);
}

void BrawlerBonuses(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    
    if(GetHasFeat(FEAT_BRAWLER_STRENGTH, oCreature) && !GetLocalInt(oSkin,"BrawlerStrength"))
       SetCompositeBonus(oSkin, "BrawlerStrength", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_STR);
    if(GetHasFeat(FEAT_BRAWLER_CONSTITUTION, oCreature) && !GetLocalInt(oSkin,"BrawlerConstitution"))
       SetCompositeBonus(oSkin, "BrawlerConstitution", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
    if(GetHasFeat(FEAT_BRAWLER_DEXTERITY, oCreature) && !GetLocalInt(oSkin,"BrawlerDexterity"))
       SetCompositeBonus(oSkin, "BrawlerDexterity", 2, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_DEX);
}

void BrawlerWeaponFinesse(object oCreature)
{
    object oSkin = GetPCSkin(oCreature);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);
    
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_WEAPFINESSE, -1, 1, "BrawlerFinesse");
    
    if (GetHasFeat(FEAT_WEAPON_FINESSE_UNARMED, oCreature) &&
        GetBaseAC(oArmor) <= 3 &&
        !GetIsObjectValid(oRighthand) &&
        !GetIsObjectValid(oLefthand) &&
        !GetLocalInt(oSkin, "BrawlerFinesse"))
    {
        DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_WEAPFINESSE), oSkin));
        SetLocalInt(oSkin, "BrawlerFinesse", TRUE);
    }
}

void BrawlerFeats(object oCreature)  //Stolen from SoulTaker :)
{
    object oSkin = GetPCSkin(oCreature);

    if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oSkin);

    if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oSkin);

    if (GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE, oCreature) && !GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oSkin);

    if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED, oCreature) && !GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE, oCreature))
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oSkin);
}

void RemoveOldAttacks(object oCreature)
{
    int iOldAttacks = GetLocalInt(oCreature, "BrawlerAttacks");

    if (iOldAttacks)
    {
        effect eRemoval = GetFirstEffect(oCreature);
        effect eCompare = SupernaturalEffect(EffectModifyAttacks(iOldAttacks));
        while (GetIsEffectValid(eRemoval))
        {
            if (GetEffectType(eRemoval) == GetEffectType(eCompare) &&
                GetEffectSubType(eRemoval) == GetEffectSubType(eCompare))
            {
                RemoveEffect(oCreature, eRemoval);
                break;
            }
            eRemoval = GetNextEffect(oCreature);
        }
    DeleteLocalInt(oCreature, "BrawlerAttacks");
    }
}

void BrawlerExtraAtt(object oCreature)
{
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);   
    int iExtraAttacks = 0;
    
    RemoveOldAttacks(oCreature);
    
    if (GetHasFeat(FEAT_AMBIDEXTERITY, oCreature) &&
        GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oCreature) &&
        !GetIsObjectValid(oRighthand) &&
        !GetIsObjectValid(oLefthand))
    {
        if (GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oCreature))
        {
            iExtraAttacks = 2;
        }
        else
        {
            iExtraAttacks = 1;
        }
    }
    
    if (iExtraAttacks)
    {
        effect eExtraAttacks = SupernaturalEffect(EffectModifyAttacks(iExtraAttacks));
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraAttacks, oCreature);
	SetLocalInt(oCreature, "BrawlerAttacks", iExtraAttacks);
    }
}

void main ()
{
   object oPC = OBJECT_SELF;

   //Evaluate The Unarmed Strike Feats
   BrawlerFeats(oPC);

   //Evaluate Weapon Finesse (Unarmed)
   BrawlerWeaponFinesse(oPC);

   //Evaluate Fists
   UnarmedFists(oPC);

   //Evaluate Dodge
   BrawlerDodge(oPC);

   //Evaluate Bonuses
   BrawlerBonuses(oPC);
   
   //Ambidex + TWF, nice little bonus :)
   BrawlerExtraAtt(oPC);
}
