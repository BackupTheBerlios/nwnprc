/*
    sp_spellturning

    <DESCRIPTION>

    By: Flaming_Sword
    Created: Jul 20, 2006
    Modified: Jul 20, 2006
*/

#include "prc_sp_func"

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0)                                         ||
       PRCGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster) ||
       (!GetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS"))
       )
    {
        PRCRemoveEffectsFromSpell(oTarget, nSpellID);
        if(DEBUG) DoDebug("sp_spellturning: Spell expired, clearing");
        DeleteLocalInt(oTarget, "PRC_SPELL_TURNING");
        DeleteLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    float fDuration = 600.0 * nCasterLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nTurn = d4() + 6;
    PRCRemoveEffectsFromSpell(oTarget, nSpellID);
    if(nMetaMagic & METAMAGIC_MAXIMIZE) nTurn = 10;
    if(nMetaMagic & METAMAGIC_EMPOWER) nTurn += nTurn / 2;
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;
    SetLocalInt(oTarget, "PRC_SPELL_TURNING", TRUE);
    SetLocalInt(oTarget, "PRC_SPELL_TURNING_LEVELS", nTurn);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELLTURNING), oTarget, fDuration, TRUE, -1, nCasterLevel);
    DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, PRCGetSpellId(), FloatToInt(fDuration) / 6));
    PRCSetSchool();
}