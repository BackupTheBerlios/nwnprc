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

void FlurryAll(object oPC)
{
          string nMesA = "";
          object oArmorA = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapRA = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapLA = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

          int armorTypeA = GetArmorType(oArmorA);
          int iShouA = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevelA = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacksA = 0;
          int attackPenaltyA = 0;


           if(iShouA >= 3 )
          {
              numAddAttacksA = 1;
              attackPenaltyA = 2;
              nMesA = "*Martial Flurry Activated*";
          }

          if(monkLevelA > 0 && GetBaseItemType(oWeapRA) == BASE_ITEM_KAMA)
          {
              numAddAttacksA = 0;
              attackPenaltyA = 0;
              nMesA = "*No Extra Attacks Gained by Kama Monks!*";
          }




          //check armor type
          if(armorTypeA < ARMOR_TYPE_MEDIUM)
          {
               if(oWeapRA != OBJECT_INVALID  && oWeapLA != OBJECT_INVALID && isNotShield(oWeapLA) )
              {
                   effect addAttA = SupernaturalEffect( EffectModifyAttacks(numAddAttacksA) );
                   effect attPenA = SupernaturalEffect( EffectAttackDecrease(attackPenaltyA) );
                   effect eLinkA = EffectLinkEffects(addAttA, attPenA);
                   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkA, oPC);
                   SetLocalInt(oPC, "HasMFlurry", 2);
              }
              else
              {
                   nMesA = "*Invalid Weapon.  Ability Not Activated!*";
              }
          }


          FloatingTextStringOnCreature(nMesA, oPC, FALSE);
     
}


void main()
{
     object oPC = OBJECT_SELF;
     string nMes = "";
     
     if(!GetHasSpellEffect(SPELL_MARTIAL_FLURRY) )
     {
            if ( GetLevelByClass(CLASS_TYPE_SHOU, oPC) == 5)
            {
                FlurryAll(oPC);
            }
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