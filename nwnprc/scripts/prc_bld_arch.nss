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
#include "prc_feat_const"
#include "prc_class_const"


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
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);

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
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem);
        SetLocalInt(oItem,"Acidblood",1);
    }
    }
    }


void main()
{

    // *get the vassal's class level and his armors
    int nBldarch = GetLevelByClass(CLASS_TYPE_BLARCHER,OBJECT_SELF);
    object oBldBow1 = GetItemPossessedBy(OBJECT_SELF, "BloodBow1");
    object oBldBow2 = GetItemPossessedBy(OBJECT_SELF, "BloodBow2");
    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    // *level 2
    if (nBldarch == 2)
    {
    // *Acid Blood
    AddAcid( oPC,GetLocalInt(oPC,"ONEQUIP"));
    }

    // *Level 3
    if (nBldarch == 2)
    {
    if ( GetLocalInt(OBJECT_SELF, "Level3") == 1) return ;

    CreateItemOnObject("BloodBow1", OBJECT_SELF, 1);
    SetLocalInt(OBJECT_SELF, "Level3", 1);
    }

    // *Level 4
    if (6 >= nBldarch >= 4)
    {
    // Regen
        SetCompositeBonus(oSkin, "Regen1", 1, ITEM_PROPERTY_REGENERATION);
    }

    // *Level 6
    if (nBldarch == 6)
    {
    if ( GetLocalInt(OBJECT_SELF, "Level6") == 1) return ;

    DestroyObject(oBldBow1, 0.0f);
    CreateItemOnObject("BloodBow2", OBJECT_SELF, 1);
    SetLocalInt( OBJECT_SELF, "Level6", 1);
    }

    // *Level 7
    if (nBldarch >= 7)
    {
    // Regen
        SetCompositeBonus(oSkin, "Regen2", 2, ITEM_PROPERTY_REGENERATION);
    }

    // *Level 9
    if (nBldarch == 9)
    {
    if ( GetLocalInt(OBJECT_SELF, "Level9") == 1) return ;

    DestroyObject(oBldBow2, 0.0f);
    CreateItemOnObject("BloodBow3", OBJECT_SELF, 1);
    SetLocalInt( OBJECT_SELF, "Level9", 1);
    }

}