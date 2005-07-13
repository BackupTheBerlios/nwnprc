//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"
#include "prc_inc_sp_tch"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

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


    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    
    nCasterLevel +=SPGetPenetr();
    
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SLAY_LIVING));
        //Make SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
        {  
            int iAttackRoll = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_MELEE_SPELL);
            //Make melee touch attack
            if(iAttackRoll)
            {
                //Make Fort save
                if  (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_DEATH))
                {
                    DeathlessFrenzyCheck(oTarget);
                    
                    //Apply the death effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                else
                {
                    //Roll damage
                    nDamage = d6(3)+ nCasterLevel;
                    //Make metamagic checks
                    if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 18 + nCasterLevel;
                    }
                    if ((nMetaMagic & METAMAGIC_EMPOWER))
                    {
                        nDamage = nDamage + (nDamage/2);
                    }
                    nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
                    //Apply damage effect and VFX impact               
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, nDamage, DAMAGE_TYPE_NEGATIVE);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
