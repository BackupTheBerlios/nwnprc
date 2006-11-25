/*
    prc_virtuoso

    Handles Virtuoso feats

    WARNING: Many of these don't care about
    faction, will affect both allies and enemies!

    Designed along the lines of Bard Song

    By: Flaming_Sword
    Created: Jul 8, 2006
    Modified: Nov 23, 2006
*/

#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "nwn2_inc_spells"

//has time limit
void RunPersistentSong(object oCaster, int nSpellId, effect eEffect, int nCounter, object oTarget)
{
    if(GetCanBardSing(oCaster) == FALSE)
    {
        return; // Awww :(
    }
    if(!nCounter)
        return;
    // Verify that we are still singing the same song...
    int nSingingSpellId = FindEffectSpellId(EFFECT_TYPE_BARDSONG_SINGING);
    int bHostile = FALSE;
    float fRadius;
    if(nSingingSpellId == nSpellId)
    {
        float fDuration = 4.0; //RoundsToSeconds(5);

        if(nSpellId == SPELL_VIRTUOSO_JARRING_SONG)
            ApplyHostileSongEffectsToArea(oCaster, nSpellId, 4.0, RADIUS_SIZE_COLOSSAL, eEffect, SAVING_THROW_WILL, 99);
        else
            ApplyFriendlySongEffectsToArea(oCaster, nSpellId, fDuration, RADIUS_SIZE_COLOSSAL, eEffect);

        // Schedule the next ping
        DelayCommand(2.5f, RunPersistentSong(oCaster, nSpellId, eEffect, (nCounter == -1) ? -1 : --nCounter, oTarget));
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    /*
    if(!VirtuosoPerformanceDecrement(oPC, nSpellID))
    {
        SendMessageToPC(oPC, "You do not have enough daily uses of Virtuoso Performance to use this ability.");
        return;
    }
    */
    object oTarget = GetSpellTargetObject();
    int nSpellID = GetSpellId();
    VirtuosoPerformanceDecrement(oPC, nSpellID);
    if(GetCanBardSing(OBJECT_SELF) == FALSE)
    {
        return; // Awww :(
    }
    int nPerform = GetSkillRank(SKILL_PERFORM);
    int nMin, nCap;
    effect eLink;
    switch(nSpellID)
    {
        case SPELL_VIRTUOSO_SUSTAINING_SONG:
        {
            nMin = 13;
            nCap = 50;
            eLink = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
            eLink = EffectLinkEffects(eLink, EffectRegenerate(1, 6.0));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

            break;
        }
        case SPELL_VIRTUOSO_JARRING_SONG:
        {
            nMin = 15;
            nCap = 10;
            eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
            //    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE)), oAffected, fDuration,TRUE,-1,nCasterLevel);
            //    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)), oAffected, fDuration,TRUE,-1,nCasterLevel);

            break;
        }
        case SPELL_VIRTUOSO_SONG_OF_FURY:
        {
            nMin = 17;
            nCap = -1;
            eLink = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
            eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
            eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_WILL, 2));
            eLink = EffectLinkEffects(eLink, EffectACDecrease(2, AC_DODGE_BONUS));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

            break;
        }
        case SPELL_VIRTUOSO_MINDBENDING_MELODY:
        {
            effect eCheck = GetFirstEffect(oTarget);
            int bCheck = FALSE;
            while(GetIsEffectValid(eCheck))
            {
                if((GetEffectSpellId(eCheck) == SPELLABILITY_SONG_FASCINATE) &&
                    (GetEffectCreator(eCheck) == oPC)
                    )
                {
                    bCheck = TRUE;
                    break;
                }
                eCheck = GetNextEffect(oTarget);
            }
            if(!bCheck)
            {
                SendMessageToPC(oPC, "You need to fascinate the target first.");
                return;
            }
            nMin = 19;
            nCap = -1;
            eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
            eLink = EffectLinkEffects(eLink, GetScaledEffect(EffectDominated(), oTarget));
            eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

            int nRacial = MyPRCGetRacialType(oTarget);
            int nLevel = GetLevelByClass(CLASS_TYPE_VIRTUOSO, oPC);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
            bCheck = FALSE;
            //Make sure the target is a humanoid
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                if  ((nRacial == RACIAL_TYPE_DWARF) ||
                    (nRacial == RACIAL_TYPE_ELF) ||
                    (nRacial == RACIAL_TYPE_GNOME) ||
                    (nRacial == RACIAL_TYPE_HALFLING) ||
                    (nRacial == RACIAL_TYPE_HUMAN) ||
                    (nRacial == RACIAL_TYPE_HALFELF) ||
                    (nRacial == RACIAL_TYPE_HALFORC))
                {
                   //Make SR Check
                   if(!MyPRCResistSpell(oPC, oTarget, nLevel + SPGetPenetr()))
                   {
                        //Make Will Save
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, 10 + nLevel + GetAbilityModifier(ABILITY_CHARISMA, oPC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                        {
                            bCheck = TRUE;
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2 + (nLevel / 3)),TRUE,-1,nLevel);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oTarget);
                        }
                    }
                }
            }
            return;

            break;
        }
        case SPELL_VIRTUOSO_REVEALING_MELODY:
        {
            nMin = 20;
            nCap = -1;
            effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
            effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
            effect eSight = EffectTrueSeeing();
            if(GetPRCSwitch(PRC_PNP_TRUESEEING))
            {
                eSight = EffectSeeInvisible();
                int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
                if(nSpot == 0)
                    nSpot = 15;
                effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
                effect eUltra = EffectUltravision();
                eSight = EffectLinkEffects(eSight, eSpot);
                eSight = EffectLinkEffects(eSight, eUltra);
            }
            eLink = EffectLinkEffects(eVis, eSight);
            eLink = EffectLinkEffects(eLink, eDur);

            break;
        }
    }
    ApplySongDurationFeatMods(nCap, oPC);

    if(nPerform < nMin) //Checks your perform skill so nubs can't use this song
    {
        FloatingTextStrRefOnCreature (182800, OBJECT_SELF );
        return;
    }
    if(AttemptNewSong(OBJECT_SELF, TRUE))
    {
        effect eFNF = ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_BARD_SONG));
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

        DelayCommand(0.1f, RunPersistentSong(OBJECT_SELF, nSpellID, eLink, nCap, oTarget));
    }
}
