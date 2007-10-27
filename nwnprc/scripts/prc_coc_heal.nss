/*
    prc_coc_heal

    Heals damage bonus if sneak/critical immune, copied from swashbuckler.

    By: Flaming_Sword
    Created: Oct 10, 2007
    Modified: Oct 27, 2007

*/

#include "prc_alterations"

void main()
{
    object oWeap=GetSpellCastItem();
    int HealInt = GetIsImmune(PRCGetSpellTargetObject(),IMMUNITY_TYPE_CRITICAL_HIT) ? 1 : 0;
        HealInt = GetIsImmune(PRCGetSpellTargetObject(),IMMUNITY_TYPE_SNEAK_ATTACK) ? 1 : HealInt;
    int nBase = GetBaseItemType(oWeap);       //baseitem type checking
    int bBase = ((nBase == BASE_ITEM_LONGSWORD) ||
                (nBase == BASE_ITEM_RAPIER) ||
                (nBase == BASE_ITEM_GREATSWORD) ||  //no elven thinblade, courtblade approximated by greatsword
                (nBase == BASE_ITEM_SCIMITAR)
                );

    //heal if immune to sneak and critical - dex bonus
    if (HealInt || !bBase)
        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetAbilityModifier(ABILITY_DEXTERITY, OBJECT_SELF)),PRCGetSpellTargetObject());
}
