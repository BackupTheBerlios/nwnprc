/*
    nw_s0_remeffect

    Takes the place of
        Remove Disease
        Neutralize Poison
        Remove Paralysis
        Remove Curse
        Remove Blindness / Deafness

        Lesser Restoration
        Restoration
        Greater Restoration

        Panacea

    By: Preston Watamaniuk
    Created: Jan 8, 2002
    Modified: Jun 16, 2006

    Flaming_Sword: Added Restoration spells, cleaned up
    added panacea, attack roll before SR check
*/

#include "prc_sp_func"

int GetIsSupernaturalCurse(effect eEff)
{
    return GetTag(GetEffectCreator(eEff)) == "q6e_ShaorisFellTemple";
}

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    int nSpellID = PRCGetSpellId();
    SpellRemovalCheck(oCaster, oTarget);
    int nVis;
    int iAttackRoll = TRUE;
    switch(nSpellID)
    {   //Setting visual effect
        case SPELL_GREATER_RESTORATION: nVis = VFX_IMP_RESTORATION_GREATER; break;
        case SPELL_RESTORATION: nVis = VFX_IMP_RESTORATION; break;
        case SPELL_LESSER_RESTORATION: nVis = VFX_IMP_RESTORATION_LESSER; break;
        default: nVis = VFX_IMP_REMOVE_CONDITION; break;
    }
    if(nSpellID == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
    {   //Remove Blindness and Deafness aoe hack largely untouched
        effect eLink;
        spellsGenericAreaOfEffect(OBJECT_SELF, GetSpellTargetLocation(), SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,
            SPELL_REMOVE_BLINDNESS_AND_DEAFNESS, EffectVisualEffect(VFX_FNF_LOS_HOLY_30), eLink, EffectVisualEffect(nVis),
            DURATION_TYPE_INSTANT, 0.0,
            SPELL_TARGET_ALLALLIES, FALSE, TRUE, EFFECT_TYPE_BLINDNESS, EFFECT_TYPE_DEAF);
        return TRUE;
    }
    effect eEffect = GetFirstEffect(oTarget);
    if(!((nSpellID == SPELL_PANACEA) && (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)))
    {
        while(GetIsEffectValid(eEffect))
        {   //Effect removal - see prc_sp_func for list of effects removed
            if(CheckRemoveEffects(nSpellID, GetEffectType(eEffect)) && !GetIsSupernaturalCurse(eEffect))
                RemoveEffect(oTarget, eEffect);
            eEffect = GetNextEffect(oTarget);
        }
    }
    if(nSpellID == SPELL_GREATER_RESTORATION && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {   //Greater Restoration healing
        int nHeal = 10 * nCasterLevel;
        if(nHeal > 250 && !GetPRCSwitch(PRC_BIOWARE_GRRESTORE))
            nHeal = 250;
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
        SetLocalInt(oTarget, "WasRestored", TRUE);
        DelayCommand(HoursToSeconds(1), DeleteLocalInt(oTarget, "WasRestored"));
    }
    if(nSpellID == SPELL_PANACEA)
    {
        int nAdd = (nCasterLevel > 20) ? 20 : nCasterLevel;
        if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD && (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)))
        {
            PRCSignalSpellEvent(oTarget);
            if (!PRCDoResistSpell(oCaster, oTarget, nCasterLevel + SPGetPenetr()))
            {
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
                if (iAttackRoll)
                {
                    // Roll the damage (allowing for a critical) and let the target make a will save to
                    // halve the damage.
                    int nDamage = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1 == iAttackRoll ? 1 : 2, 8, 0, nAdd);
                    if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
                    {
                        nDamage /= 2;
                        if (GetHasMettle(oTarget, SAVING_THROW_WILL)) nDamage = 0;
                    }
                    // Apply damage and VFX.
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, PRCEffectDamage(nDamage, DAMAGE_TYPE_POSITIVE), oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SUNSTRIKE), oTarget);
                }
            }
        }
        else
        {
            // Roll the healing 'damage'.
            int nHeal = PRCGetMetaMagicDamage(DAMAGE_TYPE_POSITIVE, 1, 8, 0, nAdd);
            // Apply the healing and VFX.
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
        }
    }
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oTarget);

    return iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
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
    PRCSetSchool();
}