/*

Iaijutsu Master Passive Feats
prc_iaijutsu_mst

*/

#include "inc_item_props"
#include "prc_aser_inc"


///Int Bonus to AC /////////
void KatanaAC(object oPC ,object oSkin ,int iLevel)
{
   if(GetLocalInt(oSkin, "KatAC") == iLevel) return;

    SetCompositeBonus(oSkin, "KatAC", iLevel,ITEM_PROPERTY_AC_BONUS);

}

///Katana Finesse /////////
void KatFin(object oPC, object oWeap, int iBonus)
{
    if(iBonus > 0){
        if(GetLocalInt(oWeap, "KatFinBonus") != iBonus){
            RemoveKatanaFinesse(oWeap);
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(iBonus), oWeap);
            SetLocalInt(oWeap, "KatFinBonus", iBonus);
        }
        if(GetLocalInt(oPC, "KatanaFinesse") != TRUE)
            FloatingTextStringOnCreature("Katana Finesse On", oPC);
        SetLocalInt(oPC, "KatanaFinesse", TRUE);
    }
    else {
        //The actual removal of the bonus is handled in the module's unequip script
        //This section simply alerts the player that the bonus has been turned off
        if(GetLocalInt(oPC, "KatanaFinesse") != FALSE)
            FloatingTextStringOnCreature("Katana Finesse Off", oPC);
        SetLocalInt(oPC, "KatanaFinesse", FALSE);
   }
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iInt = GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
    int iStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
    int iBonus = 0;

    //Determine which feats the character has
    int bKatAC = GetHasFeat(FEAT_KATANA_FINESSE, oPC) ? iInt : 0;
    int bKatFin;

    if(iDex > iStr)
    {
    iBonus = iDex - iStr;
    }

    bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC) ? iBonus : 0;

    //Apply bonuses accordingly
    if(bKatAC > 0 && GetBaseAC(oArmor) == 0) KatanaAC(oPC,oSkin,bKatAC);
    if(bKatFin > 0 && GetBaseItemType(oWeap) == BASE_ITEM_KATANA) KatFin(oPC,oWeap,bKatFin);
}
