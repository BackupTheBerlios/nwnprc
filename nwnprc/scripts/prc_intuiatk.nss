#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_ipfeat_const"
#include "nw_i0_spells"

const int SPELL_INTUITIVE_ATK = 2090;

int isSimple(object oItem)
{
      int iType= GetBaseItemType(oItem);

      switch (iType)
      {            
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_HEAVYCROSSBOW:
          return 1;
          break;
        case BASE_ITEM_CLUB:  
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTCROSSBOW:
          return 2;
          break;

      }
      return 0;
}

void main()
{
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(oPC);

   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
   {
      object oItem ;
      int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
      int iStr =  GetAbilityModifier(ABILITY_STRENGTH,oPC);
      int iWis =  GetAbilityModifier(ABILITY_WISDOM,oPC);
      int iMod = iWis > iStr  ? iWis-iStr :0;

      if (GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD )
      {
      	 if (GetHasSpellEffect(SPELL_INTUITIVE_ATK,oPC))
             RemoveEffectsFromSpell(OBJECT_SELF,SPELL_INTUITIVE_ATK);  
      }
      else if ( !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC)) &&  !GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC)))
      {
          int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);
          if (iMonk||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC))||GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC)))
          {
               SetLocalInt(oPC,"IAtk",iMod);
                 SendMessageToPC(OBJECT_SELF,"monk iMod "+IntToString(iMod));
               RemoveEffectsFromSpell(OBJECT_SELF,SPELL_INTUITIVE_ATK);
               ActionCastSpellAtObject(SPELL_INTUITIVE_ATK,oPC,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
          }
      }
      else
      {

        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
        int iSimple = isSimple(oItem);
        if (iSimple)
        {
          if (iSimple == 2 && GetHasFeat(FEAT_WEAPON_FINESSE,oPC))
          {
             int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
             if (iDex>iStr)
             {
               if (iWis > iDex)
                 iMod = iWis-iDex ;
               else
                 iMod = 0;
             }

                //Zen Archery -- they already add their wisdom, shouldn't do it again.
                if ((GetBaseItemType(oItem) == BASE_ITEM_LIGHTCROSSBOW ||
                     GetBaseItemType(oItem) == BASE_ITEM_HEAVYCROSSBOW) &&
                     GetHasFeat(FEAT_ZEN_ARCHERY, oPC))
                {
                   iMod = 0;
                }

             SetLocalInt(oPC,"IAtk",iMod);
              SendMessageToPC(OBJECT_SELF,"iMod "+IntToString(iMod));
             RemoveEffectsFromSpell(OBJECT_SELF,SPELL_INTUITIVE_ATK); 
             ActionCastSpellAtObject(SPELL_INTUITIVE_ATK,oPC,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
          }

        }
        else if (GetHasSpellEffect(SPELL_INTUITIVE_ATK,oPC))
           RemoveEffectsFromSpell(OBJECT_SELF,SPELL_INTUITIVE_ATK);  
               
      }

   }

   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {

       int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
       object oItem;
       
       if (iEquip == 1)
            oItem = GetPCItemLastUnequipped();
       else
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
      
       
       if (iEquip == 1||GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
       {
          if (GetBaseItemType(oItem)==BASE_ITEM_GLOVES)
             RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
       }
       else
       {
         oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
         AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oItem);
       }

        object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
        object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
        object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
        RemoveSpecificProperty(oCweapB,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapL,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapR,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);

        if (GetAlignmentGoodEvil(oPC)== ALIGNMENT_GOOD)
        {
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR);
        }


   }

}
