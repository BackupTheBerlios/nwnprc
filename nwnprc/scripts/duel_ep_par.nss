
//:////////////////////////////////////
//:  Duelist - Elaborate Parry - Parry mode
//:  
//:  Gains bonus to parry skill equal to duelist level
//:  
//:////////////////////////////////////
//:  By: Oni5115
//:////////////////////////////////////

#include "prc_class_const"
#include "prc_spell_const"
#include "inc_item_props"
#include "nw_i0_spells"

void KeepProperActionMode(object oPC, int ActionMode);

void main()
{
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     
     if( GetLocalInt(oPC, "HasElaborateParry") != 1 )
     {
          int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
          
          SetCompositeBonus(oSkin, "ElaborateParrySkillBonus", iDuelistLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_PARRY, TRUE);
          DelayCommand(6.0, KeepProperActionMode(oPC, ACTION_MODE_PARRY));
          
          FloatingTextStringOnCreature("*Elaborate Parry On*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 1);
     }
     else
     {         
          // Removes effects from any version of the spell
          SetCompositeBonus(oSkin, "ElaborateParryACBonus", 0, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_SHIELD);
          SetCompositeBonusT(oWeap, "ElaborateParryAttackPenalty", 0, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
          SetCompositeBonus(oSkin, "ElaborateParrySkillBonus", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);
          SetActionMode(oPC, ACTION_MODE_PARRY, FALSE);
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
          
          FloatingTextStringOnCreature("*Elaborate Parry Off*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 0);
     }
}

// Keeps the player in Parry Mode if they are in combat.
void KeepProperActionMode(object oPC, int ActionMode)
{
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 && GetIsFighting(oPC) )
     {
          if(!GetActionMode(oPC, ActionMode) )
          {
               SetActionMode(oPC, ActionMode, TRUE);
          }
     }
     
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 )
     {
          DelayCommand(3.0, KeepProperActionMode(oPC, ActionMode) );
     }
}