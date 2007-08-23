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

int CountSpells(object oTarget);

void main()
{
       if(!X2PreSpellCastCode()) return;
       
       SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
       
       object oPC = OBJECT_SELF;
       object oTarget = PRCGetSpellTargetObject();
       int nSpells = CountSpells(oTarget);
       int nCasterLvl = PRCGetCasterLevel(oPC);
       
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
        
}