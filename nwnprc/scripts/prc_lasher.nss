//::///////////////////////////////////////////////
//:: Lasher
//:://////////////////////////////////////////////
/*
    Script to add lasher bonuses

    Improved Knockdown (Whip)
    Crack of Fate
    Lashing Whip
    Improved Disarm (Whip)
    Crack of Doom

    code "borrowed" from tempest, stormlord,
        soulknife
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: Sept 29, 2005
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "inc_2dacache"
#include "spinc_common"

void ApplyExtraAttacks(object oPC) //ripped off the tempest
{
    if(!GetHasSpellEffect(SPELL_LASHER_CRACK, oPC))
    {
        ActionCastSpellOnSelf(SPELL_LASHER_CRACK);
    }
}


void main()
{
    object oPC = OBJECT_SELF;
    object oWeapon;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip
    //SendMessageToPC(oPC, IntToString(iEquip));    //debug
    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));
    //SendMessageToPC(oPC, IntToString(iClassLevel));    //debug
    string sMessage = "";

    if (iEquip == 2) //OnEquip
    {
        oWeapon = GetPCItemLastEquipped();
        //SendMessageToPC(oPC, GetName(oWeapon));    //debug
        if (GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
            return;
        if (GetLocalInt(oWeapon, "Lasher_Whip_Bonus")) return;

        if (iClassLevel > 1 && !GetHasFeat(FEAT_IMPROVED_KNOCKDOWN))    //improved knockdown (whip)
        {
            IPSafeAddItemProperty(oSkin,
                ItemPropertyBonusFeat(IP_CONST_FEAT_KNOCKDOWN)  //for radial inclusion
                );
            IPSafeAddItemProperty(oSkin,
                ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_KNOCKDOWN)
                );
        }

        if (iClassLevel > 3)    //lashing whip
            AddItemProperty(DURATION_TYPE_PERMANENT,
                ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PHYSICAL, IP_CONST_DAMAGEBONUS_2),
                oWeapon
                );
        /*
            IPSafeAddItemProperty(oWeapon,
                ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PHYSICAL, DAMAGE_BONUS_2),
                9999.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING
                );
        */

        if (iClassLevel > 5 && !GetHasFeat(FEAT_IMPROVED_DISARM))    //improved disarm (whip)
        {
            IPSafeAddItemProperty(oSkin,
                    ItemPropertyBonusFeat(IP_CONST_FEAT_DISARM) //in case the whip doesn't have it
                    );
            IPSafeAddItemProperty(oSkin,
                    ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_DISARM)
                    );
        }

        if(iClassLevel > 2)
            sMessage = "*Crack of Fate Activated*";
        if(iClassLevel > 7)
            sMessage = "*Crack of Doom Activated*";

        if (iClassLevel > 2)    //crack of fate/doom
            DelayCommand(0.1, ApplyExtraAttacks(oPC));

        SetLocalInt(oWeapon, "Lasher_Whip_Bonus", 1);
    }
    else if (iEquip == 1) //OnUnEquip
    {
        oWeapon = GetPCItemLastUnequipped();
        //SendMessageToPC(oPC, GetName(oWeapon));    //debug
        if (GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
            return;

        if (GetLocalInt(oWeapon, "Lasher_Whip_Bonus"))
        {
            if (iClassLevel > 1)    //improved knockdown (whip)
            {
                RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                    IP_CONST_FEAT_IMPROVED_KNOCKDOWN
                    );
                RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                    IP_CONST_FEAT_KNOCKDOWN
                    );
            }

            if (iClassLevel > 3)    //lashing whip
                RemoveSpecificProperty(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS,
                    IP_CONST_DAMAGETYPE_PHYSICAL,
                    IP_CONST_DAMAGEBONUS_2
                    );

            if (iClassLevel > 5)    //improved disarm (whip)
            {
                RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                    IP_CONST_FEAT_IMPROVED_DISARM
                    );
                RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                    IP_CONST_FEAT_DISARM
                    );
            }

            if(GetHasSpellEffect(SPELL_LASHER_CRACK, oPC) )/*&&
                GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND)) != BASE_ITEM_WHIP)*/
            {
                RemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK);
                if(iClassLevel > 2)
                    sMessage = "*Crack of Fate Deactivated*";
                if(iClassLevel > 7)
                    sMessage = "*Crack of Doom Deactivated*";
            }

            DeleteLocalInt(oWeapon, "Lasher_Whip_Bonus");
        }
    }
    FloatingTextStringOnCreature(sMessage, oPC, FALSE);
}
