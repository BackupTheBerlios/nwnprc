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
#include "prc_inc_sneak"    // for GetTotalSneakAttackDice

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

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