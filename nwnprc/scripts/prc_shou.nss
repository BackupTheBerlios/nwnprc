//::///////////////////////////////////////////////
//:: Shou Disciple
//:: prc_shou.nss
//:://////////////////////////////////////////////
//:: Check to see which Shou Disciple feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 28, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "nw_i0_spells"


/*
it_crewpb006 - 1d6
it_crewpb011 - 1d8
it_crewpb015 - 1d10
it_crewpb016 - 2d6
*/

void UnarmedBonus(object oPC, int iEquip)
{
   int iDmg;
   int Enh;
   string sUnarmed;
   object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);

SendMessageToPC(OBJECT_SELF, "Unarmed Bonus is called");



   if ( oWeapL==OBJECT_INVALID )
   {
      object oSlamL=CreateItemOnObject("NW_IT_CREWPB010",oPC);

      SetIdentified(oSlamL,TRUE);
      AssignCommand(oPC,ActionEquipItem(oSlamL,INVENTORY_SLOT_CWEAPON_L));
      oWeapL = oSlamL;
   }


    if (GetTag(oWeapL)!="NW_IT_CREWPB010") return;

    iDmg = FindUnarmedDmg(oPC);

      int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);

      int iKi = GetHasFeat(FEAT_KI_STRIKE,oPC) ? 1 : 0 ;
          iKi = (iMonk>12)                     ? 2 : iKi;
          iKi = (iMonk>15)                     ? 3 : iKi;

      int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oPC) ? 1 : 0 ;
          iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oPC) ? 2 : iEpicKi ;

      iKi+= iEpicKi;
      Enh+= iKi;
      
    object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
    int iIntuAtk = GetLocalInt(oItem,"IntuiAtk");

    if (iEquip != 1 &&  GetIsObjectValid(oItem))
    {

      int iType = GetBaseItemType(oItem);
      if (iType == BASE_ITEM_GLOVES)
      {

         itemproperty ip = GetFirstItemProperty(oWeapL);
         while (GetIsItemPropertyValid(ip))
         {
             RemoveItemProperty(oWeapL, ip);
            ip = GetNextItemProperty(oWeapL);
         }

         ip = GetFirstItemProperty(oItem);
         while(GetIsItemPropertyValid(ip))
         {
            iType = GetItemPropertyType(ip);

            switch (iType)
            {
              case ITEM_PROPERTY_DAMAGE_BONUS:
              case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
              case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
              case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
              case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
              case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
              case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
              case ITEM_PROPERTY_ON_HIT_PROPERTIES:
              case ITEM_PROPERTY_ONHITCASTSPELL:
                  AddItemProperty(DURATION_TYPE_PERMANENT,ip,oWeapL);
                  break;

              case ITEM_PROPERTY_ATTACK_BONUS:
                  int iCost = GetItemPropertyCostTableValue(ip)-iIntuAtk;
                  Enh = (iCost>Enh) ? iCost:Enh;
                  break;




            }

           ip = GetNextItemProperty(oItem);

         }

      }
    }
    else if (iEquip == 1)
    {
        oItem=GetPCItemLastUnequipped();

        int iType = GetBaseItemType(oItem);
        if (iType == BASE_ITEM_GLOVES)
        {

          itemproperty ip = GetFirstItemProperty(oWeapL);
          while (GetIsItemPropertyValid(ip))
          {
             RemoveItemProperty(oWeapL, ip);
            ip = GetNextItemProperty(oWeapL);
          }
        }

    }

      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iDmg),oWeapL);

      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_ATTACK_BONUS,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oWeapL);

      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING),oWeapL);



}



void DodgeBonus(object oPC, object oSkin)
{

//SendMessageToPC(OBJECT_SELF, "DodgeBonus is called");

     int ACBonus = 0;
     int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oPC);

//SendMessageToPC(OBJECT_SELF, "Shou Class Level: " + IntToString(iShou));

     if(iShou > 0 && iShou < 2)
     {
          ACBonus = 1;
     }
     else if(iShou >= 2 && iShou < 4)
     {
          ACBonus = 2;
     }
     else if(iShou >= 4)
     {
          ACBonus = 3;
     }

//SendMessageToPC(OBJECT_SELF, "Dodge Bonus to AC: " + IntToString(ACBonus));

     SetCompositeBonus(oSkin, "ShouDodge", ACBonus, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 2);
}


void RemoveDodge(object oPC, object oSkin)
{
     SetCompositeBonus(oSkin, "ShouDodge", 0, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    int iBase = GetBaseItemType(oWeapL);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    string nMes = "";

SendMessageToPC(OBJECT_SELF, "prc_shou is called");

    if( GetBaseAC(oArmor)>3 )
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         SendMessageToPC(OBJECT_SELF, "*Shou Disciple Abilities Disabled Due To Equipped Armor*");
    }
    else if(iBase == BASE_ITEM_SMALLSHIELD || iBase == BASE_ITEM_LARGESHIELD || iBase == BASE_ITEM_TOWERSHIELD)
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         SendMessageToPC(OBJECT_SELF, "*Shou Disciple Abilities Disabled Due To Equipped Shield*");
    }
    else
    {
          if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 1 )
          {
               RemoveDodge(oPC, oSkin);
               DodgeBonus(oPC, oSkin);
          }
     }

    UnarmedBonus(oPC, iEquip);

}
