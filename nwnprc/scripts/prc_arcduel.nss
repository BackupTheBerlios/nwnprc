#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"


// * Applies the Arcane Duelist's AC bonus as a CompositeBonus on object's skin.
void ApparentDefense(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "ADDef") == TRUE) return;

    SetCompositeBonus(oSkin, "ADDef", GetAbilityModifier(ABILITY_CHARISMA, oPC), ITEM_PROPERTY_AC_BONUS);
    SetLocalInt(oSkin, "ADDef", TRUE);
}


void main()
{
  object oPC = OBJECT_SELF;
  object oSkin = GetPCSkin(oPC);

  int iClassLVLArcDuelist = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC);
  int iHasFeat1 = GetHasFeat(FEAT_AD_ENCHANT_CHOSEN_WEAPON, oPC);

  object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");

  if (GetHasFeat(FEAT_AD_APPARENT_DEFENSE, oPC)) ApparentDefense(oPC, oSkin);

}
