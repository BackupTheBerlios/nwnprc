
//:////////////////////////////////////
//:  Duelist - Elaborate Parry - Defensive Fighting Mode mode
//:  
//:  Gains 10 and trades away 4 attack.
//:  
//:////////////////////////////////////
//:  By: Oni5115
//:////////////////////////////////////

#include "prc_class_const"
#include "prc_spell_const"
#include "inc_item_props"
#include "nw_i0_spells"

void main()
{
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

     if( GetLocalInt(oPC, "HasElaborateParry") != 1 )
     {
          int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC) + 2;
          if (iDuelistLevel > 12) iDuelistLevel = 12;
          
          effect eAC = SupernaturalEffect(EffectACIncrease(iDuelistLevel, AC_SHIELD_ENCHANTMENT_BONUS));
          effect eAttackPenalty = SupernaturalEffect(EffectAttackDecrease(4, ATTACK_BONUS_MISC));
          effect eLink = EffectLinkEffects(eAC, eAttackPenalty);
          
          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);          
          
          FloatingTextStringOnCreature("*Elaborate Parry On*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 1);
     }
     else
     {
          // Removes effects from any version of the spell          
          SetCompositeBonus(oSkin, "ElaborateParrySkillBonus", 0, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);          
          RemoveSpellEffects(SPELL_ELABORATE_PARRY_FD, oPC, oPC);

          FloatingTextStringOnCreature("*Elaborate Parry Off*", oPC, FALSE);
          SetLocalInt(oPC, "HasElaborateParry", 0);
     }
}
