/*
    prc_chilltouch (Holding the Charge version)

    Does 1d6 negative energy damage plus 1 point
        strength damage to touched creatures.
        Undead take no damage but instead are
        "turned" for 1d4 + 1 rounds.

    By: Flaming_Sword
    Created: May 4, 2006
    Modified: May 24, 2006

    Test for template ease of use

*/

#include "prc_sp_func"


//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, string sScript)
{
    int iMeta = PRCGetMetaMagicFeat();
    int iSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int iPenetr = nCasterLevel + SPGetPenetr();

    int iEleDmg = DAMAGE_TYPE_NEGATIVE;
    int iNegDam = d6();
    int iTurnDur = PRCGetCasterLevel(OBJECT_SELF) + d4();

    if ((iMeta & METAMAGIC_EXTEND))
    {
        iTurnDur = iTurnDur * 2;
    }
    else if ((iMeta & METAMAGIC_EMPOWER))
    {
        iNegDam = iNegDam + iNegDam / 2;
    }
    else if ((iMeta & METAMAGIC_MAXIMIZE))
    {
        iNegDam = 6;
    }

    iNegDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        if (!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));

            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, iPenetr) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
                {
                    effect eVis1 = EffectVisualEffect(VFX_IMP_FROST_S);
                    effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
                    eDur = EffectLinkEffects(eDur, EffectTurned());

                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(iTurnDur));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
            else
            {
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, iPenetr))
                {
                    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
                    //effect eDam = EffectDamage(iNegDam, iEleDmg);

                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                    // apply damage + sneak damage
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, iNegDam, iEleDmg);
                    PRCBonusDamage(oTarget);

                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                        //eDur = EffectLinkEffects(eDur, EffectAbilityDecrease(ABILITY_STRENGTH, 1));

                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(iTurnDur));
                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, RoundsToSeconds(iTurnDur));
                    }
                }
            }
        }
    }

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);

    if(GetRunningEvent() == EVENT_VIRTUAL_ONDAMAGED)
    {
        ConcentrationLossCode(oCaster, GetLocalObject(oCaster, PRC_SPELL_CONC_TARGET), nCasterLevel);
        return;
    }

    SPSetSchool(SPELL_SCHOOL_EVOCATION);  //Put Spell School Here

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

    object oTarget = PRCGetSpellTargetObject();
    int nSpellID = GetSpellId();
    string sScript = Get2DACache("spells", "ImpactScript", nSpellID);

    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, nCasterLevel);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent, sScript))
                DecrementSpellCharges(oCaster);
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}




/* OLD CODE

// Chill Touch
// Does 1d6 negative energy damage plus 1 point strength damage to touched creatures.
// Undead take no damage but instead are "turned" for 1d4 + 1 rounds.

#include "spinc_common"
#include "prc_inc_sp_tch"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);


  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more



    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    // Declare major variables
    object oTarget = GetSpellTargetObject();
    int iEleDmg = DAMAGE_TYPE_NEGATIVE;
    int iNegDam = d6();
    int iTurnDur = PRCGetCasterLevel(OBJECT_SELF) + d4();
    int iPenetr = PRCGetCasterLevel(OBJECT_SELF) + SPGetPenetr();
    int iSaveDC = PRCGetSaveDC(oTarget, OBJECT_SELF);
    int iMeta = PRCGetMetaMagicFeat();

    if ((iMeta & METAMAGIC_EXTEND))
    {
        iTurnDur = iTurnDur * 2;
    }
    else if ((iMeta & METAMAGIC_EMPOWER))
    {
        iNegDam = iNegDam + iNegDam / 2;
    }
    else if ((iMeta & METAMAGIC_MAXIMIZE))
    {
        iNegDam = 6;
    }

    iNegDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);;
    if (iAttackRoll > 0)
    {
        if (!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));

            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, iPenetr) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
                {
                    effect eVis1 = EffectVisualEffect(VFX_IMP_FROST_S);
                    effect eVis2 = EffectVisualEffect(VFX_IMP_DOOM);
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
                    eDur = EffectLinkEffects(eDur, EffectTurned());

                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(iTurnDur));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
            }
            else
            {
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget, iPenetr))
                {
                    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
                    //effect eDam = EffectDamage(iNegDam, iEleDmg);

                    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                    // apply damage + sneak damage
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, iNegDam, iEleDmg);
                    PRCBonusDamage(oTarget);

                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                        //eDur = EffectLinkEffects(eDur, EffectAbilityDecrease(ABILITY_STRENGTH, 1));

                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(iTurnDur));
                        ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, RoundsToSeconds(iTurnDur));
                    }
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
*/