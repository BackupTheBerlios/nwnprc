#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "inc_combat"

///Int Bonus to AC /////////
// * Applies the Iaijutusu Masters AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus (2x int bonus if epic)
// * iOnOff = TRUE/FALSE
// * iEpic = TRUE/FALSE
// * Code By Aaon Greywolf
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff, int iEpic = FALSE)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = iEpic ? iIntBonus * 2 : iIntBonus;

    if(iOnOff){
        SetCompositeBonus(oSkin, "CannyDefenseBonus", iIntBonus, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != TRUE)
            FloatingTextStringOnCreature("Canny Defense On", oPC);
        SetLocalInt(oPC, "CannyDefense", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "CannyDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != FALSE)
            FloatingTextStringOnCreature("Canny Defense Off", oPC);
        SetLocalInt(oPC, "CannyDefense", FALSE);
   }
}

///Katana Finesse /////////
void KatFin(object oPC, object oWeap, int iBonus)
{
 if(iBonus > 0)
  {
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
    int iStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
    int iBonus = 0;
    //int iEnhance = GetWeaponEnhancement(oWeap);
    //int iAB = GetWeaponAtkBonusIP(oWeap,oPC);

    iBonus = iDex - iStr ; //+ iEnhance;


    if(iBonus > 0){
        if(GetLocalInt(oWeap, "KatFinBonus") != iBonus){
            SetCompositeBonusT(oWeap, "KatFinBonus", iBonus, ITEM_PROPERTY_ATTACK_BONUS);
            FloatingTextStringOnCreature("Katana Finesse On", oPC);
        }
    }
    else {
        //The actual removal of the bonus is handled in the module's unequip script
        //This section simply alerts the player that the bonus has been turned off
            FloatingTextStringOnCreature("Katana Finesse Off", oPC);

   }
 }
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    //Determine which feats the character has
    int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    int bEpicCD = GetHasFeat(FEAT_EPIC_IAIJUTSU, oPC);
    int bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC);

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0)
        DuelistCannyDefense(oPC, oSkin, TRUE, bEpicCD);
    else
        DuelistCannyDefense(oPC, oSkin, FALSE);

    if(bKatFin > 0 && GetBaseItemType(oWeap) == BASE_ITEM_KATANA)
        KatFin(oPC,oWeap,bKatFin);

    if(GetBaseItemType(oWeap) != BASE_ITEM_KATANA)
        KatFin(oPC,oWeap,0);

    if(bKatFin > 0 && GetBaseItemType(oWeap2) == BASE_ITEM_KATANA)
        KatFin(oPC,oWeap2,bKatFin);

    if(GetBaseItemType(oWeap2) != BASE_ITEM_KATANA)
        KatFin(oPC,oWeap2,0);
}
