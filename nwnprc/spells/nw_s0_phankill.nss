//::///////////////////////////////////////////////
//:: Phantasmal Killer
//:: NW_S0_PhantKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target of the spell must make 2 saves or die.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Update Pass By: Preston W, On: Aug 3, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

int PRCMySavingThrow2(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
    int nDamage = d6(3);
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SONIC);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PHANTASMAL_KILLER));
        //Make an SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
        {
            //Make a Will save
            // Feb 17, 2004
            // !MySavingThrow does not work here, because it does not take into account whether
            // the creature is immune to the effect. If immune, it still does the fort save, so
            // the target will still take damage or die. To avoid messing with things too much,
            // I've made a copy of the function in this script, with an edit to return the proper
            // value if the spell was resisted.
            //Make a Will save
            if (!PRCMySavingThrow2(SAVING_THROW_WILL,  oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                // Immunity to fear, makes you immune to Phantasmal Killer.
                if ( GetIsImmune( oTarget, IMMUNITY_TYPE_FEAR ) == FALSE )
                {
                    //Make a Fort save
                    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF),SAVING_THROW_TYPE_DEATH))
                    {
                         //Check for metamagic
                         if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                         {
                            nDamage = 18;
                         }
                         if ((nMetaMagic & METAMAGIC_EMPOWER))
                         {
                            nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                         }
                         nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
                         //Set the damage property
                         eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                         //Apply the damage effect and VFX impact
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                    }
                    else
                    {
                         DeathlessFrenzyCheck(oTarget);
                         effect eDeath = EffectDeath();
                         if(!GetPRCSwitch(PRC_165_DEATH_IMMUNITY))
                            eDeath = SupernaturalEffect(eDeath);
                         //Apply the death effect and VFX impact
                         SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
                         //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

int PRCMySavingThrow2(int nSavingThrow, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{

     object oCaster = GetLastSpellCaster();
     int iRW = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);
     int iTK = GetLevelByClass(CLASS_TYPE_THAYAN_KNIGHT, oTarget);
     int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oTarget);
     int nSpell = PRCGetSpellId();
     
     // Handle the target having Force of Will and being targeted by a psionic power
     if(nSavingThrow != SAVING_THROW_WILL        &&
        nSpell > 14000 && nSpell < 14360         &&
        GetHasFeat(FEAT_FORCE_OF_WILL, oTarget)  &&
        !GetLocalInt(oTarget, "ForceOfWillUsed") &&
        // Only use will save if it's better
        (nSavingThrow == SAVING_THROW_FORT ? GetFortitudeSavingThrow(oTarget) : GetReflexSavingThrow(oTarget)) > GetWillSavingThrow(oTarget)
       )
     {
        nSavingThrow = SAVING_THROW_WILL;
        SetLocalInt(oTarget, "ForceOfWillUsed", TRUE);
        DelayCommand(6.0f, DeleteLocalInt(oTarget, "ForceOfWillUsed"));
        SendMessageToPC(oTarget, "Force Of Will used");
     }
     
     if (iRW > 0 && iTK > 0 && nSaveType == SAVING_THROW_TYPE_MIND_SPELLS)
     {
          return 0;
     }
     
     if (iRedWizard > 0)
     {
          int iRWSpec;
          if (GetHasFeat(FEAT_RW_TF_ABJ, oTarget)) iRWSpec = SPELL_SCHOOL_ABJURATION;
          else if (GetHasFeat(FEAT_RW_TF_CON, oTarget)) iRWSpec = SPELL_SCHOOL_CONJURATION;
          else if (GetHasFeat(FEAT_RW_TF_DIV, oTarget)) iRWSpec = SPELL_SCHOOL_DIVINATION;
          else if (GetHasFeat(FEAT_RW_TF_ENC, oTarget)) iRWSpec = SPELL_SCHOOL_ENCHANTMENT;
          else if (GetHasFeat(FEAT_RW_TF_EVO, oTarget)) iRWSpec = SPELL_SCHOOL_EVOCATION;
          else if (GetHasFeat(FEAT_RW_TF_ILL, oTarget)) iRWSpec = SPELL_SCHOOL_ILLUSION;
          else if (GetHasFeat(FEAT_RW_TF_NEC, oTarget)) iRWSpec = SPELL_SCHOOL_NECROMANCY;
          else if (GetHasFeat(FEAT_RW_TF_TRS, oTarget)) iRWSpec = SPELL_SCHOOL_TRANSMUTATION;

          if (GetSpellSchool(nSpell) == iRWSpec)
          {
          
               if (iRedWizard > 28)          nDC = nDC - 14;
               else if (iRedWizard > 26)     nDC = nDC - 13;
               else if (iRedWizard > 24)     nDC = nDC - 12;
               else if (iRedWizard > 22)     nDC = nDC - 11;
               else if (iRedWizard > 20)     nDC = nDC - 10;
               else if (iRedWizard > 18)     nDC = nDC - 9;
               else if (iRedWizard > 16)     nDC = nDC - 8;
               else if (iRedWizard > 14)     nDC = nDC - 7;
               else if (iRedWizard > 12)     nDC = nDC - 6;
               else if (iRedWizard > 10)     nDC = nDC - 5;
               else if (iRedWizard > 8) nDC = nDC - 4;
               else if (iRedWizard > 6) nDC = nDC - 3;
               else if (iRedWizard > 2) nDC = nDC - 2;
               else if (iRedWizard > 0) nDC = nDC - 1;
          
          }


     }

        //racial pack code
        if(nSaveType == SAVING_THROW_TYPE_FIRE && GetHasFeat(FEAT_HARD_FIRE, oTarget) )
        { nDC -= 1+(GetHitDice(oTarget)/5); }
        else if(nSaveType == SAVING_THROW_TYPE_COLD && GetHasFeat(FEAT_HARD_WATER, oTarget) )
        {    nDC -= 1+(GetHitDice(oTarget)/5);  }
        else if(nSaveType == SAVING_THROW_TYPE_ELECTRICITY )
        {
            if(GetHasFeat(FEAT_HARD_AIR, oTarget))
                nDC -= 1+(GetHitDice(oTarget)/5);
            else if(GetHasFeat(FEAT_HARD_ELEC, oTarget))
                nDC -= 2;
        }
        else if(nSaveType == SAVING_THROW_TYPE_POISON && GetHasFeat(FEAT_POISON_3, oTarget) )
        {   nDC -= 3;  }
        else if(nSaveType == SAVING_THROW_TYPE_ACID && GetHasFeat(FEAT_HARD_EARTH, oTarget) )
        {   nDC -= 1+(GetHitDice(oTarget)/5);  }

     return BWSavingThrow(nSavingThrow, oTarget, nDC, nSaveType, oSaveVersus, fDelay);
}