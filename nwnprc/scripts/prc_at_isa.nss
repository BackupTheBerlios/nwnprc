//::///////////////////////////////////////////////
//:: Arcane Trickster
//:://////////////////////////////////////////////
/*
    Script to Simulate the Impromptu Sneak Attack
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 11, 2004
//:://////////////////////////////////////////////

#include "inc_addragebonus" // for determining weapon damage type
#include "inc_combat"       // for DoMeleeAttack
#include "x2_inc_itemprop"  // for IPGetIsMeleeWeapon

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

int GetTotalSneakAttackDice(object oPC)
{
   object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   int iSneakAttackDice = 0;
   int iBowEquipped = FALSE;
   int iClassLevel;

   iClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
   if (iClassLevel) iSneakAttackDice += (iClassLevel + 1) / 2;

   iClassLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
   if (iClassLevel) iSneakAttackDice += iClassLevel / 2;

   iClassLevel = GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC);
   if (iClassLevel) iSneakAttackDice += (iClassLevel + 1) / 3;

   iClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
   if (iClassLevel) iSneakAttackDice += (iClassLevel + 1) / 2;

   iClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC);
   if (iClassLevel >= 6) iSneakAttackDice++;

   iClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
   if (iClassLevel) iSneakAttackDice += (iClassLevel - 1) / 3;
   if ((iClassLevel) && (GetLevelByClass(CLASS_TYPE_PALADIN) >= 5)) iSneakAttackDice++;  // bonus for pal/bg

   iClassLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 5)) iSneakAttackDice++;
   if ((iClassLevel >= 5) && (iClassLevel < 8)) iSneakAttackDice += 2;
   if (iClassLevel >= 8) iSneakAttackDice += 3;

   if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW ||
       GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
          iBowEquipped = TRUE;

   if (iBowEquipped)
   {
      iClassLevel = GetLevelByClass(CLASS_TYPE_PEERLESS, oPC);
      if (iClassLevel) iSneakAttackDice += (iClassLevel + 2) / 3

      //iClassLevel = GetLevelByClass(CLASS_TYPE_BLARCHER, oPC);
      //if ((iClassLevel >= 5) && (iClassLevel < 8)) iSneakAttackDice++;
      //if ((iClassLevel >= 8) && (iClassLevel < 10)) iSneakAttackDice += 2;
      //if (iClassLevel >= 10) iSneakAttackDice += 3;
   }

   //iClassLevel = GetLevelByClass(CLASS_TYPE_INFILTRATOR, oPC);
   //if ((iClassLevel >= 1) && (iClassLevel < 5)) iSneakAttackDice++;
   //if (iClassLevel >= 5) iSneakAttackDice += 2;

   //iClassLevel = GetLevelByClass(CLASS_TYPE_FANG_OF_LOLTH, oPC);
   //if ((iClassLevel >= 2) && (iClassLevel < 5)) iSneakAttackDice++;
   //if ((iClassLevel >= 5) && (iClassLevel < 8)) iSneakAttackDice += 2;
   //if ((iClassLevel >= 8) && (iClassLevel < 12)) iSneakAttackDice += 3;
   //if ((iClassLevel >= 12) && (iClassLevel < 16)) iSneakAttackDice += 4;
   //if ((iClassLevel >= 16) && (iClassLevel < 20)) iSneakAttackDice += 5;
   //if (iClassLevel >= 20) iSneakAttackDice += 6;

     // checks for epic feats that add sneak damage
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_2) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_3) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_4) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_5) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_6) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_7) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_8) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_9) )
     {
         iSneakAttackDice++;
     }
     if(GetHasFeat(FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10) )
     {
         iSneakAttackDice++;
     }
     
     return iSneakAttackDice;
}

int GetSneakAttackDamage(int iSneakAttackDice)
{
     int iSneakAttackDamage = d6(iSneakAttackDice);     
     return iSneakAttackDamage;
}

int IsImmuneImpSneakAttack(object oTarget)
{
     int bReturnVal = FALSE;
     
     if( GetIsImmune(oTarget, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_INVALID) )
     {
          bReturnVal = TRUE;
     }
     
     return bReturnVal;
}

void main()
{
     object oTarget = GetSpellTargetObject();
     int iEnemydexBonus = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
     
     object oPC = OBJECT_SELF;
     int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, oPC);
     int iSneakAttackDice = GetTotalSneakAttackDice(oPC);
     
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
     
     string nMes = "";
     int iWeapDamage = 0;
     int iSneakDamage = 0;
     int iAttack = 0;
     
     int isMeleeWeapon = IPGetIsMeleeWeapon(oWeap);
     
     // adds the enemies dex bonus to attack to simulate enemy not having 
     // their dex bonus to AC
     if(isMeleeWeapon)
     {
     	  iAttack = DoMeleeAttack(oPC, oWeap, oTarget, iEnemydexBonus, TRUE, 0.0);
     }
     else
     {
          iAttack = DoRangedAttack(oPC, oWeap, oTarget, iEnemydexBonus, TRUE, 0.0);
     }
     
     if(iAttack > 0)
     {
          if(isMeleeWeapon)
          {
              if(iAttack == 2)  // Critical
              {
                   iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, TRUE, 0);
              }
              else
              {
                   iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, FALSE, 0);
              }
          }
          else
          {
              if(iAttack == 2)  // Critical
              {
                   iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, TRUE, 0);
              }
              else
              {
                   iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, FALSE, 0);
              }          
          }
               
          iSneakDamage = GetSneakAttackDamage(iSneakAttackDice);
          
          int itotDam = 0;
          if(IsImmuneImpSneakAttack(oTarget) )
          {
               itotDam = iWeapDamage;
               nMes = "*Enemy Immune to Impromtu Sneak Attack*";
          }
          else
          {
               itotDam = iWeapDamage + iSneakDamage;
               nMes = "*Impromptu Sneak Attack Hit*";
          }
          
          effect eTotalDamage = EffectDamage(itotDam, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eTotalDamage, oTarget);
          
          string damage = "Impromtu Sneak Attack Damage: " + IntToString(iSneakDamage);
          SendMessageToPC(oPC, damage);
     }
     else
     {
          nMes = "*Impromptu Sneak Attack Missed*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
     
     
     // Other main hand attacks for the round
     int iBaB = GetBaseAttackBonus(oPC);
     int iNumAttacks = FloatToInt( (iBaB + 0.5)/5 );
     int attPenalty = -5;
     
     int i;
     
     for(i = 1; i < iNumAttacks; i++)
     {
          if(isMeleeWeapon)
          {
               iAttack = DoMeleeAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);               
               if(iAttack == 2)
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeap, FALSE, 0);
               }
          }
          else
          {
               iAttack = DoRangedAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);
               if(iAttack == 2)
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeap, FALSE, 0);
               }
          }

          effect eDam = EffectDamage(iWeapDamage, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
          
          attPenalty += -5;
     }
     
     // Off-hand Attacks
     if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 2;
     }
     else if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 1;
     }
     else if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING) && oWeapL != OBJECT_INVALID)
     {
          iNumAttacks = 3;    
     }
     
     attPenalty = 0;
     
     // Perform the off-hand attacks
     for(i = 0; i < iNumAttacks; i++)
     {
          if(isMeleeWeapon)
          {
               iAttack = DoMeleeAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);               
               if(iAttack == 2)
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetMeleeWeaponDamage(oPC, oWeapL, FALSE, 0);
               }
          }
          else
          {
               iAttack = DoRangedAttack(oPC, oWeap, oTarget, attPenalty, TRUE, 0.0);
               if(iAttack == 2)
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, TRUE, 0);
               }
               else
               {
                    iWeapDamage = GetRangedWeaponDamage(oPC, oWeapL, FALSE, 0);
               }
          }

          effect eDam = EffectDamage(iWeapDamage, nDamageBonusType, DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
          
          attPenalty += -5;
     }     
}