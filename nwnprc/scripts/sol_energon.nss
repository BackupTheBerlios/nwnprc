#include "prc_feat_const"
void main()
{

   int nLoop, nCount;
   object oHench;
   for (nLoop=1; nLoop<=GetMaxHenchmen(); nLoop++)
   {
   	oHench = GetHenchman(OBJECT_SELF, nLoop);
   	
      if (GetIsObjectValid(oHench))  nCount++;
      
     if (GetResRef(oHench)=="xagya01")
     {
     	RemoveHenchman(OBJECT_SELF,oHench);
     	AssignCommand(oHench, SetIsDestroyable(TRUE));
        DestroyObject(oHench);
        nCount--;
     }
   }
    
    if (nCount >= GetMaxHenchmen()) return;
   

    oHench = CreateObject(OBJECT_TYPE_CREATURE,"xagya01",GetSpellTargetLocation());
    AddHenchman(OBJECT_SELF,oHench);


   int i;
   for (i = 0; i < 4; i++)
      LevelUpHenchman( GetObjectByTag("xagya01"),CLASS_TYPE_OUTSIDER,TRUE,PACKAGE_INVALID);

   int  iFeat = GetHasFeat(FEAT_POSITIVE_ENERGY_BURST);

  
   if ( GetHitDice(OBJECT_SELF) >9)
   {
      int level = (GetHitDice(OBJECT_SELF)-9+iFeat*2)/2;

     for (i = 0; i < level ; i++)
      LevelUpHenchman( GetObjectByTag("xagya01"),CLASS_TYPE_CLERIC,TRUE,PACKAGE_CLERIC_DIVINE);

     if ( (GetHitDice(OBJECT_SELF)-9+iFeat*2)!= level*2) level++;

     for (i = 0; i < level ; i++)
      LevelUpHenchman( GetObjectByTag("xagya01"),CLASS_TYPE_OUTSIDER,TRUE,PACKAGE_INVALID);

   }

    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oHench);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oHench);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreL);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_POSITIVE,IP_CONST_DAMAGEBONUS_1d6),oCreR);

//    effect eConceal = SupernaturalEffect(EffectConcealment(50));
//    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eConceal, oHench));



}
