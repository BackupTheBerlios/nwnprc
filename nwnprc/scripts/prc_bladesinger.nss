#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "nw_i0_spells"

void RemoveSpellEffectSong(object oPC)
{

  effect eff = GetFirstEffect(oPC);

  while (GetIsEffectValid(eff) )
  {
     if(GetEffectSpellId(eff) == SPELL_SONG_OF_FURY)
         RemoveEffect(oPC, eff);

     eff = GetNextEffect(oPC);

  }
}

void IPAddSpellFailure50(object oArmor)
{
  if ( GetBaseItemType(oArmor)!=BASE_ITEM_ARMOR) return;

  if  (GetBaseAC(oArmor)>3 ||GetLocalInt(oArmor,"BladeASF") ) return ;

  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT),oArmor);
  SetLocalInt(oArmor,"BladeASF",1);
}

void IPRemoveSpellFailure50(object oItem)
{

  if  (!GetLocalInt(oItem,"BladeASF")) return ;

  RemoveSpecificProperty(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT, 1);
  DeleteLocalInt(oItem,"BladeASF");
}


void OnEquip(object oPC,object oSkin,object oItem)
{

  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  if  (GetBaseAC(oArmor)>3)
  {
     if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
     {
       RemoveSpellEffectSong(oPC);
     }
     SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
     SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
     return;
  }
  if ( GetHasFeat(FEAT_GREATER_SPELLSONG,oPC)) IPAddSpellFailure50(oItem);


  // only 1 weapon
  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
     {
        if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }

   // only rapier or longsword
  if (  !(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD ||
          GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }


   int BladeLv=GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
   int Intb=GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

   // Bonus Lvl BladeSinger Max Bonus Int
   if ( BladeLv>Intb) BladeLv=Intb;

   SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

   if ( GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
     SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

}

void  OnUnEquip(object oPC,object oSkin)
{
  object oItem=GetPCItemLastUnequipped();

  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  IPRemoveSpellFailure50(oItem);

  if  (GetBaseAC(oArmor)>3)
  {
        if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

     SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
     SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
     return;
  }


  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }


  if (  !(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD ||
          GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

        return;
     }



   int BladeLv=GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
   int Intb=GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

   if ( BladeLv>Intb)
        BladeLv=Intb;

   SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

   if ( GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
     SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

}


void main()
{

  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iEquip = GetLocalInt(oPC,"ONEQUIP");


       if (iEquip !=1) OnEquip(oPC,oSkin,GetPCItemLastEquipped());
       if (iEquip ==1) OnUnEquip(oPC,oSkin);

}

