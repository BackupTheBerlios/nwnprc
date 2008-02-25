/*
    prc_chilltouch

    Chill Touch
    Does 1d6 negative energy damage plus 1 point strength damage to touched creatures.
    Undead take no damage but instead are "turned" for 1d4 + 1 rounds.

    By: ???
    Created: ???
    Modified: Jun 28, 2006
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int iEleDmg = DAMAGE_TYPE_NEGATIVE;
    int iNegDam = d6();
    int iTurnDur = nCasterLevel + d4();
    int iPenetr = nCasterLevel + SPGetPenetr();
    int iSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int iMeta = PRCGetMetaMagicFeat();

    if ((iMeta & METAMAGIC_EXTEND))
        iTurnDur *= 2;
    else if ((iMeta & METAMAGIC_EMPOWER))
        iNegDam += iNegDam / 2;
    else if ((iMeta & METAMAGIC_MAXIMIZE))
        iNegDam = 6;

    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    if (iAttackRoll > 0)
    {
        if (!GetIsReactionTypeFriendly(oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));

            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                if (!PRCMyResistSpell(OBJECT_SELF, oTarget, iPenetr) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
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
                if (!PRCMyResistSpell(OBJECT_SELF, oTarget, iPenetr))
                {
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FROST_S), oTarget);
                    ApplyTouchAttackDamage(OBJECT_SELF, oTarget, iAttackRoll, iNegDam, iEleDmg);
                    PRCBonusDamage(oTarget);
                    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
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
    SPSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, nCasterLevel);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}