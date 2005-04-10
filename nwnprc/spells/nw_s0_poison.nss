//::///////////////////////////////////////////////
//:: Poison
//:: NW_S0_Poison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Must make a touch attack. If successful the target
    is struck down with wyvern poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
//:: modified by Ornedan Dec 20, 2004 to PnP rules

#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"


void DoPoison(object oTarget, object oCaster, int nDC, int CasterLvl, int nMetaMagic){
   //Declare major variables
   int nDam = SPGetMetaMagicDamage(-1, 1, 10, 0, 0, nMetaMagic);
   //effect eDamage = EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam);
   //effect eLink = EffectLinkEffects(EffectVisualEffect(VFX_IMP_POISON_L), eDamage);
   
   // First check for poison immunity, if not, make a fort save versus spells.
   if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) &&
      !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster))
   {
       //Apply the poison effect and VFX impact
       //SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,TRUE,-1,CasterLvl);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POISON_L), oTarget);
       ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nDam, DURATION_TYPE_PERMANENT, 0.0f, TRUE, -1, CasterLvl);
   }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
   object oCaster = OBJECT_SELF;
   object oTarget = GetSpellTargetObject();
   int CasterLvl = PRCGetCasterLevel(oCaster);
   int nDC = 10 + (CasterLvl / 2) + GetAbilityModifier(ABILITY_WISDOM);
   int nMetaMagic = SPGetMetaMagic();
   
    
   int nTouch = TouchAttackMelee(oTarget);// Was a constant 1. No idea why - Ornedan
    
   if(!GetIsReactionTypeFriendly(oTarget))
   {
       //Fire cast spell at event for the specified target
       SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_POISON));
       //Make touch attack
       if (nTouch > 0)
       {
           //Make SR Check
           if (!MyPRCResistSpell(oCaster, oTarget))
           {
               // Primary damage
               DoPoison(oTarget, oCaster, nDC, CasterLvl, nMetaMagic);
               
               // Secondary damage
               DelayCommand(MinutesToSeconds(1), DoPoison(oTarget, oCaster, nDC, CasterLvl, nMetaMagic));
           }
       }
   }
    
   // Getting rid of the integer used to hold the spells spell school
   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

