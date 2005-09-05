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

#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

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

     if (!bHasBow)
     {
         FloatingTextStringOnCreature("*No Bow Equipped*", OBJECT_SELF, FALSE);
         RemoveSpellEffects(SPELL_PA_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
     RemoveSpellEffects(SPELL_PA_IMP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
     RemoveSpellEffects(SPELL_PA_SUP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
         return;
     }

     if(!GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT) && !GetHasFeatEffect(FEAT_PA_POWERSHOT) && !GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT))
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
          RemoveSpellEffects(SPELL_PA_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
          RemoveSpellEffects(SPELL_PA_IMP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);
          RemoveSpellEffects(SPELL_PA_SUP_POWERSHOT, OBJECT_SELF, OBJECT_SELF);

          string nMes = "*Power Shot Mode Deactivated*";
          FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
     }
}
