//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals all friendly targets within 10ft to full
//:: unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, and 15, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "prc_inc_switch"

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
  effect eKill;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHeal;
  effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
  effect eStrike = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
  int nTouch, nModify, nDamage, nHeal;
  int nMetaMagic = PRCGetMetaMagicFeat();
  float fDelay;
  location lLoc =  GetSpellTargetLocation();

  int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
  int nCasterLvl = CasterLvl;
  CasterLvl +=SPGetPenetr();

  //Apply VFX area impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lLoc);
  //Get first target in spell area
  object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
  while(GetIsObjectValid(oTarget))
  {
      fDelay = GetRandomDelay();
      //Check to see if the target is an undead
      if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && !GetIsReactionTypeFriendly(oTarget))
      {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL));
            //Make a touch attack
            nTouch = GetAttackRoll(oTarget, OBJECT_SELF, OBJECT_INVALID, 0, 0,0,TRUE, 0.0, TOUCH_ATTACK_RANGED_SPELL);
            if (nTouch > 0)
            {
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                    //Make an SR check
                    if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
                    {
                        //Roll damage
                        nModify = d4();
                        //make metamagic check
                        int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, FALSE);
                        if (nMetaMagic & METAMAGIC_MAXIMIZE || iBlastFaith)
                        {
                            nModify = 1;
                        }
                        //Detemine the damage to inflict to the undead
                        nDamage =  10 * nCasterLvl;

            if (nDamage > 250 && !GetPRCSwitch(PRC_BIOWARE_MASS_HEAL))
                nDamage = 250;

                        // Will save for half damage
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF))))
                        nDamage /= 2;

                        // Cannot drop you below nModify hp
            if (nDamage > GetCurrentHitPoints(oTarget) - nModify)
                nDamage = GetCurrentHitPoints(oTarget) - nModify;

                        //Set the damage effect
                        eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);

                        //Apply the VFX impact and damage effect
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
            }
      }
      else
      {
            //Make a faction check
            if(GetIsFriend(oTarget) && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL, FALSE));
                //Determine amount to heal
                nHeal = 10 * CasterLvl;
            if(nHeal > 250 && !GetPRCSwitch(PRC_BIOWARE_MASS_HEAL))
            nHeal = 250;
                //Set the damage effect
                eHeal = EffectHeal(nHeal);
                //Apply the VFX impact and heal effect
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
      }
      //Get next target in the spell area
      oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
   }
   


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
