//::///////////////////////////////////////////////
//:: Peerless Archer - Power Shot
//:: Copyright (c) 2004 
//:://////////////////////////////////////////////
/*
    Decreases attack by 5 and increases damage by 5
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: April 09, 2004
//:://////////////////////////////////////////////

#include "x2_i0_spells"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "inc_combat2"

void main()
{
     effect eDamage;
     effect eToHit;
     int bHasBow = FALSE;
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
     
     if(GetBaseItemType(oWeap) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeap) == BASE_ITEM_SHORTBOW) 
     {
          bHasBow = TRUE;
     }
     
     if(!GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT) && !GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT) && bHasBow)
     {
          if(!GetHasFeatEffect(FEAT_PA_POWERSHOT))
          {
               int nDamageBonusType = GetWeaponDamageType(oWeap);
               
               eDamage = EffectDamageIncrease(DAMAGE_BONUS_5, nDamageBonusType);               
               eToHit = EffectAttackDecrease(5);

               effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
               
               string nMes = "*Power Shot Mode Activated*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }
          else
          {          
               RemoveSpecificEffect(EFFECT_TYPE_DAMAGE_INCREASE, OBJECT_SELF);
               RemoveSpecificEffect(EFFECT_TYPE_ATTACK_DECREASE, OBJECT_SELF);

               string nMes = "*Power Shot Mode Deactivated*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }          
     }
}