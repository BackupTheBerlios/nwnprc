/*
    prc_coc

    Applies some of the passive bonuses

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 27, 2007

*/

//compiler would completely crap itself unless this include was here
#include "prc_alterations"

//adds onhit: unique power, copied from swashbuckler code
void CritSTR(object oPC, int iEquip)
{
    object oItem;
    if(iEquip == 1)
    {
        oItem=GetItemLastUnequipped();
        RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
        DeleteLocalInt(oItem,"CritHarm");
    }
    else
    {
        oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        if(!GetLocalInt(oItem,"CritHarm"))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
            SetLocalInt(oItem,"CritHarm",1);
        }
        oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
        if(!GetLocalInt(oItem,"CritHarm"))
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
            SetLocalInt(oItem,"CritHarm",1);
        }
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = (GetLevelByClass(CLASS_TYPE_COC, oPC));
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int nBase = GetBaseItemType(oWeapon);
    int iEquip= GetLocalInt(oPC,"ONEQUIP");

    if(nLevel >= 2)
    {
        if(GetIsObjectValid(oWeapon) &&
            ((nBase == BASE_ITEM_LONGSWORD) ||
            (nBase == BASE_ITEM_RAPIER) ||
            (nBase == BASE_ITEM_ELF_LIGHTBLADE) ||
            (nBase == BASE_ITEM_ELF_THINBLADE) ||
            (nBase == BASE_ITEM_ELF_COURTBLADE) ||
            (nBase == BASE_ITEM_SCIMITAR)
            ))
            ActionCastSpellOnSelf(SPELL_COC_DAMAGE);
        else
            PRCRemoveEffectsFromSpell(oPC, SPELL_COC_DAMAGE);
        CritSTR(oPC, iEquip);
    }
}

