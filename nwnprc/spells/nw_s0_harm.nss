//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "prc_inc_switch"

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
    object oTarget = GetSpellTargetObject();
    int nDamage, nHeal;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nTouch = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_MELEE_SPELL);
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(246);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal, eDam;
    //Check that the target is undead
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        //Figure out the amount of damage to heal
        nHeal = 10 * nCasterLvl;
        if (nHeal > 150 && !GetPRCSwitch(PRC_BIOWARE_HARM))
        nHeal = 150;
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply heal effect and VFX impact
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
    }
    else if (nTouch) //== TRUE) 1 or 2 are valid return numbers from TouchAttackMelee
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM));

            if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
            {
             /*   nDamage = GetCurrentHitPoints(oTarget) - d4(1);
                //Check for metamagic
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                    nDamage = GetCurrentHitPoints(oTarget) - 1;
                } */
                nDamage = 10;
                nDamage = nDamage * nCasterLvl;

                if (nDamage > 150 && !GetPRCSwitch(PRC_BIOWARE_HARM))
                    nDamage = 150;

                // Will save for half damage
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
                    nDamage /= 2;

                // Cannot drop you below 1 hp
                if (nDamage > GetCurrentHitPoints(oTarget) - 1)
                    nDamage = GetCurrentHitPoints(oTarget) - 1;
        
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);

                //Apply the VFX impact and effects
                DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
