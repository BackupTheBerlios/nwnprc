//  Clangeddin's Strike Feat
//  Created 10/30/04
//  By Vaeliorin

#include "prc_inc_combat"
#include "prc_inc_function"
#include "prc_feat_const"

void main()
{
     object oPC   = OBJECT_SELF;
     object oTarget  = GetSpellTargetObject();

     if(oPC == oTarget)
     {
          SendMessageToPC(oPC,"You cannot attack yourself...");
          return;
     }
        

     object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

     if (GetBaseItemType(oItem) != BASE_ITEM_BATTLEAXE)
     {
         SendMessageToPC(oPC, "You must have a battleaxe equipped to use this feat");
         IncrementRemainingFeatUses(oPC, FEAT_CLANGEDDINS_STRIKE);
         return;
     }

     AssignCommand(oPC, ActionMoveToLocation(GetLocation(oTarget), TRUE) );
    
      effect eDamage;
      
      int iAttackResult;

      struct BonusDamage sWeaponBonus;
      struct BonusDamage sSpellBonus;

      int iStrMod = GetAbilityModifier(ABILITY_STRENGTH, oPC);

      sWeaponBonus = GetWeaponBonusDamage(oItem, oTarget);

      sSpellBonus = GetMagicalBonusDamage(oPC);

      iAttackResult = GetAttackRoll(oTarget, oPC, oItem, 0, 0, (iStrMod + 1));

      if (iAttackResult == 2)
      {
         SendMessageToPC(oPC, "Clangeddin's Strike **Critical Hit!**");
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, TRUE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
      }
      else if (iAttackResult == 1)
      {
         SendMessageToPC(oPC, "Clangeddin's Strike Hit!");
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
         eDamage = GetAttackDamage(oTarget, oPC, oItem, sWeaponBonus, sSpellBonus,  0, 0, FALSE, 0, 0, 0);
         DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
      }
     else
     {
         SendMessageToPC(oPC, "Clangeddin's Strike Miss!");
     }
     AssignCommand(oPC, ActionAttack(oTarget));
}     
      



