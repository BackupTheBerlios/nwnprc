 //::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 points of acid damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"
#include "prc_inc_sp_tch"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

   //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    nCasterLevel +=SPGetPenetr();

    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 424));
        
        int iAttackRoll = TouchAttackRanged(oTarget);
        if(iAttackRoll > 0)
        {
             //Make SR Check
             if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
             {
                 //Apply the VFX impact and damage effect
                 SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            
                 // perform attack roll for ray and deal proper damage
                 int nDamage =  MyMaximizeOrEmpower(3, 1, GetMetaMagicFeat());
                 ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_ACID));
                 PRCBonusDamage(oTarget);
             }
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}




