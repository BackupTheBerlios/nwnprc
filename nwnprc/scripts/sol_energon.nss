#include "prc_feat_const"
void main()
{


    object oHench = CreateObject(OBJECT_TYPE_CREATURE,"xagya01",GetSpellTargetLocation());
    AddHenchman(OBJECT_SELF,oHench);


   int i;
   for (i = 0; i < 4; i++)
      LevelUpHenchman( GetObjectByTag("xagya01"),CLASS_TYPE_OUTSIDER,TRUE,PACKAGE_INVALID);

   int  iFeat = GetHasFeat(FEAT_POSITIVE_ENERGY_BURST);

   if ( GetHitDice(OBJECT_SELF) >12)
   {
     for (i = 0; i < (GetHitDice(OBJECT_SELF)-12+iFeat*2) ; i++)
      LevelUpHenchman( GetObjectByTag("xagya01"),CLASS_TYPE_CLERIC,TRUE,PACKAGE_CLERIC_DIVINE);
   }

    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oHench);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oHench);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreR);

    effect eConceal = SupernaturalEffect(EffectConcealment(50));
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eConceal, oHench));



}
