//::///////////////////////////////////////////////
//:: Name      Spellslayer Arrow
//:: FileName  sp_spslay_arrow.nss
//:://////////////////////////////////////////////
/**@file Spellslayer Arrow
Transmutation
Level: Assassin 2, ranger 2
Components: V, S, M
Casting Time: 1 swift action
Range: Long
Target: One creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

As you cast this spell, your fire a masterwork or 
magical arrow or bolt, and transform it into a glowing
missile that destabilizes other forms of magic.In 
addition to dealing normal damage, a spellslayer arrow
dealsan extra 1d4 points of damage for each ongoing
spell currently ineffect on the target. For example,
an arrow would deal an extra 3d4 points of damage to 
a creature under the effects of bull’s strength, haste,
and mage armor.

Material Component: Masterwork arrow or bolt.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "spinc_common"
#include "prc_craft_inc"

int CountSpells(object oTarget);

void main()
{
       if(!X2PreSpellCastCode()) return;
       
       SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
       
       object oPC = OBJECT_SELF;
       object oTarget = PRCGetSpellTargetObject();
       int nSpells = CountSpells(oTarget);
       int nCasterLvl = PRCGetCasterLevel(oPC);
       object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
       int nType = GetBaseItemType(oWeapon);
       
       //Has to be a bow of some sort
       if(nType != BASE_ITEM_LONGBOW &&
          nType != BASE_ITEM_SHORTBOW &&
          nType != BASE_ITEM_LIGHTCROSSBOW &&
          nType != BASE_ITEM_HEAVYCROSSBOW)
       {
               SPSetSchool();
               return;
       }
       
       //Check for Masterwork or magical
       string sMaterial = GetStringLeft(GetTag(oItem), 3);
       
       if((!(GetMaterialString(StringToInt(sMaterial)) == sMaterial && sMaterial != "000") && !GetIsMagicItem(oItem)))
       {
               SPSetSchool();
               return;
       }
       
       //The meat
       PerformAttack(oTarget, oPC, eVis);
       
       //if hit
       if(GetLocalInt(oTarget, "PRCCombat_StruckByAttack"))
       {
               if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
               {
                       nDam = d4(nSpells);
                       ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
               }
       }
       
       SPSetSchool();
}

int CountSpells(object oTarget)
{
        effect eTest = GetFirstEffect
        
}