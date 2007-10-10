/*
    prc_coc

    Applies some of the passive bonuses

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 11, 2007

*/

//compiler would completely crap itself unless this include was here
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nLevel = (GetLevelByClass(CLASS_TYPE_COC, oPC));
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int nBase = GetBaseItemType(oWeapon);

    if(nLevel >= 2)
    {
        if(GetIsObjectValid(oWeapon) &&
            ((nBase == BASE_ITEM_LONGSWORD) ||
            (nBase == BASE_ITEM_RAPIER) ||
            (nBase == BASE_ITEM_GREATSWORD) ||  //no elven thinblade, courtblade approximated by greatsword
            (nBase == BASE_ITEM_SCIMITAR)
            ))
            ActionCastSpellOnSelf(SPELL_COC_DAMAGE);
        else
            RemoveEffectsFromSpell(oPC, SPELL_COC_DAMAGE);
    }
}

