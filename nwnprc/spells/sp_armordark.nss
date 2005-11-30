// Armor of Darkness
// lvl 4
// +3 bonus to ac plus additional +1 per every 4 lvl of caster to max of +8 .
// Gives Darkvision , +2 save against holy , light , or good spells.


#include "spinc_common"

#include "x2_inc_spellhook"
#include "prc_alterations"

void main()
{

    SPSetSchool(SPELL_SCHOOL_ABJURATION);
    int nCasterLvl = PRCGetCasterLevel();
    int nMetaMagic = PRCGetMetaMagicFeat();
    float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(nCasterLvl));

    int iAC = 3 + nCasterLvl/4;
    if (iAC >8)  iAC = 8;

    effect eAC=EffectACIncrease(iAC,AC_DEFLECTION_BONUS);
    effect eUltravision = EffectUltravision();
    effect eSaveG=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_GOOD);
    effect eSaveD=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_DIVINE);

    effect eLinks=EffectLinkEffects(eAC,eUltravision);
           eLinks=EffectLinkEffects(eLinks,eSaveG);
           eLinks=EffectLinkEffects(eLinks,eSaveD);

    object oTarget=PRCGetSpellTargetObject();

    //Fire cast spell at event for the specified target
    SPRaiseSpellCastAt(oTarget, FALSE);

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
       effect eTurn=EffectTurnResistanceIncrease(4);
       eLinks=EffectLinkEffects(eLinks,eTurn);
    }

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinks, oTarget,fDuration);
    SPSetSchool();
}