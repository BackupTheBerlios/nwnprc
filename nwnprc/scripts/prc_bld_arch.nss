//::///////////////////////////////////////////////
//:: [Blood Archer Feats]
//:: [prc_bld_arch.nss]
//:://////////////////////////////////////////////
//:: Check to see which Blood Archer lvls a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Zedium
//:: Created On: April 28, 2005
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "x2_inc_itemprop"

#include "prc_feat_const"
#include "prc_class_const"

/*
void AddAcid(object oPC,int iEquip)
    {
    object oItem ;

    if (iEquip==2)
    {
        oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
        if ( GetLocalInt(oItem,"Acidblood"))
        return;

     if (GetBaseItemType(oItem)==BASE_ITEM_ARMOR)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,999.0);

            SetLocalInt(oItem,"Acidblood",1);
        }
    }
    else if (iEquip==1)
    {
        oItem=GetPCItemLastUnequipped();
        if (GetBaseItemType(oItem)!=BASE_ITEM_ARMOR) return;
            RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0);
        DeleteLocalInt(oItem,"Acidbloodk");
    }
    else
    {
        oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
        if ( !GetLocalInt(oItem,"Acidblood")&& GetBaseItemType(oItem)==BASE_ITEM_ARMOR)
        {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,999.0);
        SetLocalInt(oItem,"Acidblood",1);
    }
    }
    }
*/

void ApplyAcidBlood(object oPC, object oArmor)
{    
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
     SetLocalInt(oPC, "HasAcidBlood", 2);
}

void RemoveAcidBlood(object oPC, object oArmor)
{
     RemoveSpecificProperty(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0);
     SetLocalInt(oPC, "HasAcidBlood", 1);
}

void main()
{

    // *get the blood archer's level and stuff
    int nBldarch = GetLevelByClass(CLASS_TYPE_BLARCHER,OBJECT_SELF);
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    object oItem;
    int iEquip = GetLocalInt(oPC, "ONEQUIP");
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    // on load, error since local ints are wiped and = 0
    if (GetLocalInt(oPC, "HasAcidBlood") == 0)
    {
        RemoveAcidBlood(oPC, oArmor);
        ApplyAcidBlood(oPC, oArmor);   
    }
    else if(nBldarch >= 2 && GetLocalInt(oPC, "HasAcidBlood") != 0)
    {              
        if(iEquip == 2)       // On Equip
        {
             // add bonus to armor
             oItem = GetPCItemLastEquipped();
             
             if(oItem == oArmor)
             {
                  ApplyAcidBlood(oPC, oArmor); 
             }
        }
        else if(iEquip == 1)  // Unequip
        {
             oItem = GetPCItemLastUnequipped();
             
             if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
             {
                  RemoveAcidBlood(oPC, oItem);
             }
        }
        else                  // On level, rest, or other events
        {
             RemoveAcidBlood(oPC, oArmor);
             ApplyAcidBlood(oPC, oArmor);
        }
    }
    
    /*
    // *level 2
    if (nBldarch >= 2)
    {
    // *Acid Blood
    AddAcid( oPC,GetLocalInt(oPC,"ONEQUIP"));
    }
    */

    // *Level 4
    if (6 >= nBldarch >= 4)
    {
    // Regen
        SetCompositeBonus(oSkin, "Regen1", 1, ITEM_PROPERTY_REGENERATION);
    }

    // *Level 7
    else if (nBldarch >= 7)
    {
    // Regen
        SetCompositeBonus(oSkin, "Regen2", 2, ITEM_PROPERTY_REGENERATION);
    }


}