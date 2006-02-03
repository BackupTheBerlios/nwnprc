//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "inc_utility"
#include "spinc_remeffct"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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
  object oTarget = PRCGetSpellTargetObject();
  effect eKill, eHeal;
  int nDamage, nHeal, nModify, nMetaMagic, nTouch;
  int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    //Check to see if the target is an undead
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
            //Make a touch attack
            if (PRCDoMeleeTouchAttack(oTarget))
            {
                //Make SR check
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
                {
                    //Roll damage
                    nModify = d4();
                    nMetaMagic = PRCGetMetaMagicFeat();
                    //Make metamagic check
                    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
                    if (nMetaMagic & METAMAGIC_MAXIMIZE || iBlastFaith)
                    {
                        nModify = 1;
                    }
                    //Figure out the amount of damage to inflict
                    nDamage = 10;
                    nDamage = nDamage * nCasterLvl;

                    if (nDamage > 150 && !GetPRCSwitch(PRC_BIOWARE_HEAL))
                        nDamage = 150;

                    // Will save for half damage
                    if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF)))
                        nDamage /= 2;

                    // Cannot drop you below nModify hp
                    if (nDamage > GetCurrentHitPoints(oTarget) - nModify)
                        nDamage = GetCurrentHitPoints(oTarget) - nModify;

                    //Set damage
                    eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);

                    //Apply damage effect and VFX impact
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
                                    }
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        //Figure out how much to heal
        nHeal = 10;
        nHeal = nHeal * nCasterLvl;
      if(nHeal > 150 && !GetPRCSwitch(PRC_BIOWARE_HEAL))
        nHeal = 150;
        //Set the heal effect
        eHeal = EffectHeal(nHeal);
        //Apply the heal effect and the VFX impact
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        
        // Code for FB to remove damage that would be caused at end of Frenzy
        SetLocalInt(oTarget, "PC_Damage", 0);
    }

//Spell Removal Check
SpellRemovalCheck(OBJECT_SELF, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
