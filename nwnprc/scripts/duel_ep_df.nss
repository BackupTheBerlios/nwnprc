
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
          
          SetCompositeBonusT(oWeap, "ElaborateParryACBonus", iDuelistLevel, ITEM_PROPERTY_AC_BONUS, IP_CONST_ACMODIFIERTYPE_SHIELD);
          SetCompositeBonus(oSkin, "ElaborateParryAttackPenalty", 4, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER);
          
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
void PreventImproperActionMode(object oPC)
{
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 && GetIsFighting(oPC) )
     {
          SetActionMode(oPC, ACTION_MODE_EXPERTISE, FALSE);
          SetActionMode(oPC, ACTION_MODE_IMPROVED_EXPERTISE, FALSE);
     }
     
     if(GetLocalInt(oPC, "HasElaborateParry") == 1 )
     {
          DelayCommand(6.0, PreventImproperActionMode(oPC) );
     }
}