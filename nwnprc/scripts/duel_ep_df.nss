
//:////////////////////////////////////
//:  Duelist - Elaborate Parry - Defensive Fighting Mode mode
//:  
//:  Gains bonus to AC equal to duelist level
//:  
//:////////////////////////////////////
//:  By: Oni5115
//:////////////////////////////////////

#include "prc_class_const"
#include "prc_spell_const"
#include "inc_item_props"
#include "nw_i0_spells"

void PreventImproperActionMode(object oPC);

void main()
{
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

     if( GetLocalInt(oPC, "HasElaborateParry") != 1 )
     {
          // add 2 extra defense due to defensive fighting.
          int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC) + 2;
          if (iDuelistLevel > 12) iDuelistLevel = 12; // capped at 10
                    
          effect eAC = SupernaturalEffect(EffectACIncrease(iDuelistLevel, AC_SHIELD_ENCHANTMENT_BONUS));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, oPC);          
          effect iAttackPenalty = SupernaturalEffect(EffectAttackDecrease(4, ATTACK_BONUS_MISC));
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, iAttackPenalty, oPC);          
          
          SetActionMode(oPC, ACTION_MODE_PARRY, FALSE);
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
          DelayCommand(6.0, PreventImproperActionMode(oPC));
          
          FloatingTextStringOnCreature("*Elaborate Parry On*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 1);
     }
     else
     {
          // Removes effects from any version of the spell          
          SetCompositeBonus(oSkin, "ElaborateParrySkillBonus", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);          
          RemoveSpecificEffect(EFFECT_TYPE_AC_INCREASE, oPC);
          RemoveSpecificEffect(EFFECT_TYPE_ATTACK_DECREASE, oPC);
         
          SetActionMode(oPC, ACTION_MODE_PARRY, FALSE);
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
          
          FloatingTextStringOnCreature("*Elaborate Parry Off*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 0);
     }
}

// Keeps the player in Parry Mode if they are in combat.
void PreventImproperActionMode(object oPC)
{
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 && GetIsFighting(oPC) )
     {
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
     }
     
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 )
     {
          DelayCommand(3.0, PreventImproperActionMode(oPC) );
     }
}