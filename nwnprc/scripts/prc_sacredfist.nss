#include "inc_item_props"
#include "prc_feat_const"
#include "nw_i0_spells"
#include "soul_inc"


void ClawDragon(object oPC,int iEquip)
{


   object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);

   if ( oWeapL==OBJECT_INVALID )
   {
      object oSlamL=CreateItemOnObject("NW_IT_CREWPB010",oPC);

      SetIdentified(oSlamL,TRUE);
      AssignCommand(oPC,ActionEquipItem(oSlamL,INVENTORY_SLOT_CWEAPON_L));
      oWeapL = oSlamL;
   }


    if (GetTag(oWeapL)!="NW_IT_CREWPB010") return;

      int iDmg = FindUnarmedDmg(oPC);

      int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);

      int iKi = GetHasFeat(FEAT_KI_STRIKE,oPC) ? 1 : 0 ;
          iKi = (iMonk>12)                     ? 2 : iKi;
          iKi = (iMonk>15)                     ? 3 : iKi;

      int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oPC) ? 1 : 0 ;
          iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oPC) ? 2 : iEpicKi ;

      iKi+= iEpicKi;
      int Enh = iKi;

    object oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);

    if (iEquip == 2 &&  GetIsObjectValid(oItem))
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
                  int iCost =GetItemPropertyCostTableValue(ip);
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

void SacredAC(object oPC,object oSkin,int bSFAC)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);

   if  (GetBaseAC(oArmor)>3 )
      SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);
   else
      SetCompositeBonus(oSkin, "SacFisAC", bSFAC, ITEM_PROPERTY_AC_BONUS);


}

void SacredSpeed(object oPC,object oSkin,int bSFSpeed)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);

   if  (GetBaseAC(oArmor)>3  && GetHasSpellEffect(SPELL_SACREDSPEED,oPC))
     RemoveSpellEffects(SPELL_SACREDSPEED,oPC,oPC);
   else if (!GetHasSpellEffect(SPELL_SACREDSPEED,oPC))
   {
     RemoveSpellEffects(SPELL_SACREDSPEED,oPC,oPC);
     ActionCastSpellAtObject(SPELL_SACREDSPEED,oPC,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
   }

}



void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iClass = GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC);


    int bSFSpeed=GetHasFeat(FEAT_SF_SPEED1, oPC) ? 1 : 0;
        bSFSpeed=GetHasFeat(FEAT_SF_SPEED2, oPC) ? 2 : bSFSpeed;
        bSFSpeed=GetHasFeat(FEAT_SF_SPEED3, oPC) ? 3 : bSFSpeed;

    object oItemR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    int bSFAC = iClass/5 +1;

    int iCode =  GetHasFeat(FEAT_SF_CODE);

    if (!iCode)
    {
       if ( oItemR ==   OBJECT_INVALID)
       {
         if ( oItemL ==   OBJECT_INVALID || GetBaseItemType(oItemL)==BASE_ITEM_TORCH)
         {}
         else
         {
           RemoveSpecificProperty(GetPCSkin(oPC),ITEM_PROPERTY_BONUS_FEAT,IP_CONST_FEAT_SF_CODE);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
           iCode = 1;
           FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);

         }
       }
       else
       {
          RemoveSpecificProperty(GetPCSkin(oPC),ITEM_PROPERTY_BONUS_FEAT,IP_CONST_FEAT_SF_CODE);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
          iCode = 1;
          FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);


       }
    }

    if (iCode)
    {
       bSFAC = 0;
       bSFSpeed=0;
       SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);
       if (GetHasSpellEffect(SPELL_SACREDSPEED,oPC))
          RemoveSpellEffects(SPELL_SACREDSPEED,oPC,oPC);
       if (GetHasSpellEffect(SPELL_SACREDFLAME,oPC))
          RemoveSpellEffects(SPELL_SACREDFLAME,oPC,oPC);
       if (GetHasSpellEffect(SPELL_INNERARMOR,oPC))
          RemoveSpellEffects(SPELL_INNERARMOR,oPC,oPC);
       while(GetHasFeat(FEAT_SF_SACREDFLAME1))
       DecrementRemainingFeatUses(oPC,FEAT_SF_SACREDFLAME1);

       while(GetHasFeat(FEAT_SF_INNERARMOR))
         DecrementRemainingFeatUses(oPC,FEAT_SF_INNERARMOR);

    }

    
    if (bSFAC>0 && !iCode)    SacredAC(oPC,oSkin,bSFAC);
    if (bSFSpeed>0 && !iCode) SacredSpeed(oPC,oSkin,bSFSpeed);

    ClawDragon(oPC,GetLocalInt(oPC,"ONEQUIP"));

}
