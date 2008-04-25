/*
    sp_glibness

    Transmutation
    Level: Brd 3
    Components: S
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: 10 min./level (D)
    Your speech becomes fluent and more believable. You gain a +30 bonus on Bluff checks made to convince another of the truth of your words. (This bonus doesn’t apply to other uses of the Bluff skill, such as feinting in combat, creating a diversion to hide, or communicating a hidden message via innuendo.)
    If a magical effect is used against you that would detect your lies or force you to speak the truth the user of the effect must succeed on a caster level check (1d20 + caster level) against a DC of 15 + your caster level to succeed. Failure means the effect does not detect your lies or force you to speak only the truth.

    By: Flaming_Sword
    Created: Oct 4, 2006
    Modified: Oct 4, 2006
*/

#include "prc_sp_func"

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    PRCSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();
    float fDuration = 60.0 * nCasterLevel; //modify if necessary
    if(nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2;

    PRCSignalSpellEvent(oTarget, FALSE);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_BLUFF, 30), oTarget, fDuration, TRUE, -1, nCasterLevel);

    PRCSetSchool();
}