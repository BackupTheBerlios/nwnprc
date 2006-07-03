/*
    nw_s0_cureinflict

    Handles all the cure/inflict spells

    By: Flaming_Sword
    Created: Jun 13, 2006
    Modified: Jun 30, 2006

    Consolidation of multiple scripts
    modified healing vfx for inflict spells
    changed cure minor wounds to heal 1 hp
        in line with SRD
    added will save 1/2 damage for cure spells
    added mass cure spells
    added mass heal-like random delay for mass
        cure spells (to look cool, delay can be
        set to zero if desired)
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, int bIsCure)
{
    int nSpellID = PRCGetSpellId();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int bMass = IsMassCure(nSpellID) || IsMassInflict(nSpellID);
    int nHealVFX;
    int nEnergyType = bIsCure ? DAMAGE_TYPE_POSITIVE : DAMAGE_TYPE_NEGATIVE;
    int nSpellLevel = StringToInt(lookup_spell_cleric_level(PRCGetSpellId()));
    int nDice = nSpellLevel;
    int iHeal;

    if(bMass)
        nDice -= 4;
    switch(nDice)       //nDice == 0 for cure/inflict minor wounds
    {
        case 0: nHealVFX = VFX_IMP_HEAD_HEAL; break;
        case 1: nHealVFX = VFX_IMP_HEALING_S; break;
        case 2: nHealVFX = VFX_IMP_HEALING_M; break;
        case 3: nHealVFX = VFX_IMP_HEALING_L; break;
        case 4: nHealVFX = VFX_IMP_HEALING_G; break;
    }

    int nExtraDamage = nSpellLevel * 5;
    if(nCasterLevel < nExtraDamage) nExtraDamage = nCasterLevel;
    //Healing is more effective for players on low or normal difficulty
    int nDifficultyCondition = (GetIsPC(oTarget) && (GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)) && bIsCure;

    location lLoc;
    if(bMass)
    {
        lLoc = PRCGetSpellTargetLocation();
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsCure ? VFX_FNF_LOS_HOLY_20 : VFX_FNF_LOS_EVIL_20), lLoc);

    }
    float fDelay = 0.0;
    int nHealed = 0;
    int nMaxHealed = bMass ? nCasterLevel : 1;
    int iAttackRoll = 1;
    while (GetIsObjectValid(oTarget))
    {   //random delay like mass heal so it looks cool :P (can be set to zero if behavior is not desired)
        if(bMass) fDelay = GetRandomDelay();
        //nHealed++;
        int iBlastFaith = BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE);
        //Metamagic and feats
        int nHeal = 0;
        if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith || nDifficultyCondition)
        {
            nHeal = nDice * 8 + nExtraDamage;
            if(nDifficultyCondition && ((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith))
                nHeal += nExtraDamage;      //extra damage on lower difficulties
        }
        else
            nHeal = d8(nDice) + nExtraDamage;
        if ((nMetaMagic & METAMAGIC_EMPOWER)) nHeal += (nHeal/2);
        if (GetHasFeat(FEAT_AUGMENT_HEALING, oCaster) && bIsCure)
            nHeal += (nSpellLevel * 2);
        if(nDice == 0) nHeal = 1;
        iHeal = GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
                ((!bIsCure && MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD) ||
                (bIsCure && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD));
        if(iHeal && spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, oCaster))
        {   //heals friendly creatures
            effect eHeal = EffectHeal(nHeal);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));
            SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, FALSE));
            nHealed++;
        }
        else if((GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && !bIsCure) ||
                (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !iHeal))
        {   //negative spells damage non-creatures
            if (!GetIsReactionTypeFriendly(oTarget) && oTarget != oCaster)
            {
                iAttackRoll = PRCDoMeleeTouchAttack(oTarget);;
                if(iAttackRoll > 0)
                {
                    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID));
                    if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLevel + SPGetPenetr()))
                    {
                        if(PRCGetSaveDC(oTarget, oCaster))
                        {
                            nHeal /= 2;
                            if(GetHasMettle(oTarget, SAVING_THROW_WILL))
                                nHeal = 0;
                        }
                        effect eDam = EffectDamage(nHeal, nEnergyType);
                        DelayCommand(fDelay + 1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsCure ? VFX_IMP_SUNSTRIKE : 246), oTarget));
                        nHealed++;
                    }
                }
            }
        }
        if(nHealed >= nMaxHealed) break;
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lLoc, TRUE);
    }

    return bMass ? TRUE : iAttackRoll;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nSpellID = PRCGetSpellId();
    int bIsCure = IsMassCure(nSpellID) || IsCure(nSpellID);  //whether it is a cure or inflict spell
    SPSetSchool(GetSpellSchool(nSpellID));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {   //can't hold the charge with mass cure/inflict spells
        if(!(IsMassCure(nSpellID) || IsMassInflict(nSpellID)) && GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent, bIsCure);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent, bIsCure))
                DecrementSpellCharges(oCaster);
        }
    }
    SPSetSchool();
}