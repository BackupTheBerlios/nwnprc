#include "inc_item_props"
#include "prc_feat_const"
#include "prc_ipfeat_const"
#include "prc_class_const"

void BLKGlaive(object oPC,int iEquip)
{
  object oItem ;

  if (iEquip==2)        // On Equip
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

     if ( GetLocalInt(oItem,"BKGlaive")) return ;


     if (GetBaseItemType(oItem)==BASE_ITEM_HALBERD)
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
       SetLocalInt(oItem,"BKGlaive",1);
     }

  }
  else if (iEquip==1)     // Unequip
  {
     oItem=GetItemLastUnequipped();
     if (GetBaseItemType(oItem)!=BASE_ITEM_HALBERD) return;
     if ( GetLocalInt(oItem,"BKGlaive"))
       RemoveSpecificProperty(oItem,ITEM_PROPERTY_DAMAGE_BONUS,IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6,1,"",-1,DURATION_TYPE_TEMPORARY);
     DeleteLocalInt(oItem,"BKGlaive");

  }
  else
  {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if ( GetLocalInt(oItem,"BKGlaive")) return ;

     if (GetBaseItemType(oItem)==BASE_ITEM_HALBERD)
     {
       AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oItem,9999.0);
       SetLocalInt(oItem,"BKGlaive",1);
     }
  }

}

void Corrupt(object oPC, int iEquip)
{
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

	if(iEquip == 2)
	{
    		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		if(GetLocalInt(oItem,"CorruptGlaive")) return ;

		if(GetBaseItemType(oItem) == BASE_ITEM_HALBERD)
		{
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20),oItem,9999.0);
			SetLocalInt(oItem,"CorruptGlaive",1);
		}
	}

	else if(iEquip == 1)
	{
		oItem = GetItemLastUnequipped();
		if(GetBaseItemType(oItem) != BASE_ITEM_HALBERD) return;

		if(GetLocalInt(oItem,"CorruptGlaive"))
			RemoveSpecificProperty(oItem,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20,1,"",-1,DURATION_TYPE_TEMPORARY);
		DeleteLocalInt(oItem, "CorruptGlaive");
	}
	
	else
	{
    		oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
		if(GetLocalInt(oItem,"CorruptGlaive")) return ;

		if(GetBaseItemType(oItem) == BASE_ITEM_HALBERD)
		{
			AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING,IP_CONST_ONHIT_SAVEDC_20),oItem,9999.0);
			SetLocalInt(oItem,"CorruptGlaive",1);
		}
	}
}

//Immunity to Disease - Blightblood
void BltBlood(object oPC, object oSkin)
{
	if(GetLocalInt(oSkin, "BlightBlood") == 1)
		return;

	AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oSkin);

	SetLocalInt(oSkin, "BlightBlood", 1);
	SendMessageToPC(oPC, "Blightblood is firing");
}

//Plant Type Gained - Winterheart
void Winterheart(object oPC ,object oSkin )
{
	if(GetLocalInt(oSkin, "WntrHeart") == 1)
   		return;

	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM),oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oSkin);
   	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oSkin);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oSkin);

	SetLocalInt(oSkin, "WntrHeart",1);
	SendMessageToPC(oPC, "Winterheart is Firing");
}

void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);


	SendMessageToPC(oPC, "Blightlord Main is Firing");
	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 1)
      		BltBlood(oPC, oSkin);

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 6)
        	BLKGlaive(oPC, GetLocalInt(oPC,"ONEQUIP"));

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 8)
        	Corrupt(oPC, GetLocalInt(oPC,"ONEQUIP"));

	if(GetLevelByClass(CLASS_TYPE_BLIGHTLORD) >= 10)
        	Winterheart(oPC, oSkin);
}




