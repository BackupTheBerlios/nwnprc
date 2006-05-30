//::///////////////////////////////////////////////
//:: Tempest - Greater and Supreme Two Weapon Fighting
//:: Copyright (c) 2004 
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     object oPC = PRCGetSpellTargetObject();
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
     {    
          object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
          
          int armorType = GetArmorType(oArmor);
          if (oArmor == OBJECT_INVALID) armorType = ARMOR_TYPE_LIGHT;
          int tempestLevel = GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);
          int monkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacks = 0;
          int attackPenalty = 0;
          
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) )
          {
              numAddAttacks = 1;
              attackPenalty = 2;
              nMes = "*Greater Two-Weapon Fighting Activated*";
          }
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC) )
          {
              numAddAttacks = 2;
              attackPenalty = 4;
              nMes = "*Supreme Two-Weapon Fighting Activated*";
          }
          if(GetHasFeat(FEAT_PERFECT_TWO_WEAPON_FIGHTING, oPC) )
          {
              numAddAttacks = 2;
              attackPenalty = 4;

              if(GetHasSpellEffect(SPELL_MASS_HASTE, oPC) == TRUE || // mass haste
                 GetHasSpellEffect(647, oPC) == TRUE  ||             // blinding speed
                 GetHasSpellEffect(SPELL_HASTE, oPC) == TRUE ||     // haste
                 GetHasSpellEffect(SPELL_FRENZY, oPC) == TRUE )     // frenzy 
              {
                   numAddAttacks += 1;
              }
              if(GetHasSpellEffect(SPELL_FURIOUS_ASSAULT, oPC)) numAddAttacks += 1;
              if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY_LIGHT, oPC) || GetHasSpellEffect(SPELL_MARTIAL_FLURRY_ALL, oPC))  numAddAttacks += 1;
              
              nMes = "*Perfect Two-Weapon Fighting Activated*";
          }
          
          if(monkLevel > 0 && GetBaseItemType(oWeapL) == BASE_ITEM_KAMA)
          {
              numAddAttacks = 0;
              attackPenalty = 0;
              nMes = "*No Extra Attacks Gained by Dual Kama Monks!*";              
          }
          
          // If feat is on a tempest, check armor type
          if(tempestLevel > 4 && armorType < ARMOR_TYPE_MEDIUM)
          {
               if(oWeapR != OBJECT_INVALID  && oWeapL != OBJECT_INVALID && isNotShield(oWeapL) )
              {
                   effect addAtt = SupernaturalEffect( EffectModifyAttacks(numAddAttacks) );
                   effect attPen = SupernaturalEffect( EffectAttackDecrease(attackPenalty) );
                   effect eLink = EffectLinkEffects(addAtt, attPen);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
                   SetLocalInt(oPC, "HasTwoWeapEffects", 2);            
              }
              else
              {
                   nMes = "*Invalid Weapon.  Ability Not Activated!*";
              }
          }
          // non-tempests
          else
          {
               if(oWeapR != OBJECT_INVALID  && oWeapL != OBJECT_INVALID && isNotShield(oWeapL) )
              {
                   effect addAtt = SupernaturalEffect( EffectModifyAttacks(numAddAttacks) );
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, addAtt, oPC);
                   SetLocalInt(oPC, "HasTwoWeapEffects", 2);        
              }  
              else
              {
                   nMes = "*Invalid Weapon.  Ability Not Activated!*";
              }          
          }          
          
          if(tempestLevel > 4 && armorType >= ARMOR_TYPE_MEDIUM)
          {
              nMes = "*Invalid Armor.  Two-Weapon Fighting Bonuses Not Activated!*";
          }

          FloatingTextStringOnCreature(nMes, oPC, FALSE);    
     }
     else
     {   
          // Removes effects
          RemoveEffectsFromSpell(oPC, SPELL_T_TWO_WEAPON_FIGHTING);

          // Display message to player
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) )
          {
              nMes = "*Greater Two-Weapon Fighting Deactivated*";
          }
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC) )
          {
              nMes = "*Supreme Two-Weapon Fighting Deactivated*";
          }
          if(GetHasFeat(FEAT_PERFECT_TWO_WEAPON_FIGHTING, oPC) )
          {
              nMes = "*Perfect Two-Weapon Fighting Deactivated*";          
          }
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
     }  
}