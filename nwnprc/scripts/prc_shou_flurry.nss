//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

int isNotShield(object oItem)
{
     int isNotAShield = 1;
     
     if(GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD)       isNotAShield == 0;
     else if (GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) isNotAShield == 0;
     else if (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) isNotAShield == 0;
     
     return isNotAShield;
}

void main()
{
     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_MARTIAL_FLURRY) )
     {    
          object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
          
          int armorType = GetArmorType(oArmor);
          int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacks = 0;
          int attackPenalty = 0;
          
          if(iShou >= 3 )
          {
              numAddAttacks = 1;
              attackPenalty = 2;
              nMes = "*Martial Flurry Activated*";
          }

          if(monkLevel > 0 && GetBaseItemType(oWeapR) == BASE_ITEM_KAMA)
          {
              numAddAttacks = 0;
              attackPenalty = 0;
              nMes = "*No Extra Attacks Gained by Kama Monks!*";              
          }
          



          //check armor type
          if(armorType < ARMOR_TYPE_MEDIUM)
          {
               if(oWeapR != OBJECT_INVALID  && oWeapL != OBJECT_INVALID && isNotShield(oWeapL) )
              {
                   effect addAtt = SupernaturalEffect( EffectModifyAttacks(numAddAttacks) );
                   effect attPen = SupernaturalEffect( EffectAttackDecrease(attackPenalty) );
                   effect eLink = EffectLinkEffects(addAtt, attPen);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
                   SetLocalInt(oPC, "HasMFlurry", 2);            
              }
              else
              {
                   nMes = "*Invalid Weapon.  Ability Not Activated!*";
              }
          }
        

          FloatingTextStringOnCreature(nMes, oPC, FALSE);    
     }
     else
     {   
          // Removes effects
          RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);

          // Display message to player
          nMes = "*Martial Flurry Deactivated*";
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
     }  
}