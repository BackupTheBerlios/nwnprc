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

void ApplyLashing(object oPC) //ripped off the tempest
{
    if(!GetHasSpellEffect(SPELL_LASHER_LASHW, oPC))
    {
        //SendMessageToPC(oPC, "Lashing");    //debug
        ActionCastSpellOnSelf(SPELL_LASHER_LASHW);
    }
}

void ApplyBonuses(object oPC, object oWeapon)
{
    //SendMessageToPC(oPC, GetName(oWeapon));    //debug
    object oSkin = GetPCSkin(oPC);
    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));
    string sMessage = "";
    if(GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
        return;
    if(GetLocalInt(oWeapon, "Lasher_Whip_Bonus")) return;

    if(iClassLevel > 1 && !GetHasFeat(FEAT_IMPROVED_KNOCKDOWN))    //improved knockdown (whip)
    {
        IPSafeAddItemProperty(oSkin,
            ItemPropertyBonusFeat(IP_CONST_FEAT_KNOCKDOWN)  //for radial inclusion
            );
        IPSafeAddItemProperty(oSkin,
            ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_KNOCKDOWN)
            );
    }

    if(iClassLevel > 3)    //lashing whip
        DelayCommand(0.1, ApplyLashing(oPC));

    if(iClassLevel > 5 && !GetHasFeat(FEAT_IMPROVED_DISARM))    //improved disarm (whip)
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

    if(iClassLevel > 2)    //crack of fate/doom
        DelayCommand(0.1, ApplyExtraAttacks(oPC));

    SetLocalInt(oWeapon, "Lasher_Whip_Bonus", 1);
    if(iClassLevel > 2)
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
}

void RemoveBonuses(object oPC, object oWeapon)
{
    //SendMessageToPC(oPC, GetName(oWeapon));    //debug
    object oSkin = GetPCSkin(oPC);
    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));
    string sMessage = "";
    if (GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
        return;

    if(GetLocalInt(oWeapon, "Lasher_Whip_Bonus"))
    {
        if(iClassLevel > 1)    //improved knockdown (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_KNOCKDOWN
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_KNOCKDOWN
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_LASHW, oPC)) //lashing whip
            RemoveEffectsFromSpell(oPC, SPELL_LASHER_LASHW);

        if(iClassLevel > 5)    //improved disarm (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_DISARM
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_DISARM
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_CRACK, oPC))  //crack of fate/doom
        {
            RemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK);
            if(iClassLevel > 2)
                sMessage = "*Crack of Fate Deactivated*";
            if(iClassLevel > 7)
                sMessage = "*Crack of Doom Deactivated*";
            FloatingTextStringOnCreature(sMessage, oPC, FALSE);
        }

        DeleteLocalInt(oWeapon, "Lasher_Whip_Bonus");
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oWeapon;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip
    //SendMessageToPC(oPC, IntToString(iEquip));    //debug
    int iRest = GetLocalInt(oPC,"ONREST");  //1 = rest finished
    //SendMessageToPC(oPC, IntToString(iRest));    //debug
    int iEnter = GetLocalInt(oPC,"ONENTER");  //1 = rest finished

    if(iEquip == 2) //OnEquip
    {
        oWeapon = GetPCItemLastEquipped();
        ApplyBonuses(oPC, oWeapon);
    }
    else if (iEquip == 1) //OnUnEquip
    {
        oWeapon = GetPCItemLastUnequipped();
        RemoveBonuses(oPC, oWeapon);
    }
    if(iRest == 1)    //crack of fate/doom
        DelayCommand(0.1, ApplyExtraAttacks(oPC));
    if(iEnter == 1)    //crack of fate/doom
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        ApplyBonuses(oPC, oWeapon);
    }

}
