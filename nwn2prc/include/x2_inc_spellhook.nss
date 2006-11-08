//::///////////////////////////////////////////////
//:: Spell Hook Include File
//:: x2_inc_spellhook
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    This file acts as a hub for all code that
    is hooked into the nwn spellscripts'

    If you want to implement material components
    into spells or add restrictions to certain
    spells, this is the place to do it.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-06-04
//:: Updated On: 2003-10-25
//:://////////////////////////////////////////////


const int X2_EVENT_CONCENTRATION_BROKEN = 12400;



// This function checks for the Red Wizard's restricted
// spell school and prevents him from casting the spells
// that he is banned from casting.
int RedWizRestrictedSchool();

// This function checks whether the Combat Medic's Healing Kicker
// feats are active, and if so imbues the spell target with additional
// beneficial effects.
void CombatMedicHealingKicker();

// This prevents casting spells into or out of a Null Psionics Field
int NullPsionicsField();

// Utterance. Prevents the casting of hostile spells by the target
int WardOfPeace();

// Duskblade channeling. While channeling, stops non-touch spells
// from working
int DuskbladeArcaneChanneling();

// Bard / Sorc PrC handling
// returns FALSE if it is a bard or a sorcerer spell from a character
// with an arcane PrC via bioware spellcasting rather than via PrC spellcasting
int BardSorcPrCCheck();

// Use Magic Device Check.
// Returns TRUE if the Spell is allowed to be cast, either because the
// character is allowed to cast it or he has won the required UMD check
// Only active on spell scroll
int X2UseMagicDeviceCheck();


// This function holds all functions that are supposed to run before the actual
// spellscript gets run. If this functions returns FALSE, the spell is aborted
// and the spellscript will not run
int X2PreSpellCastCode();


// check if the spell is prohibited from being cast on items
// returns FALSE if the spell was cast on an item but is prevented
// from being cast there by its corresponding entry in des_crft_spells
// oItem - pass PRCGetSpellTargetObject in here
int X2CastOnItemWasAllowed(object oItem);

// Sequencer Item Property Handling
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
// oItem - pass PRCGetSpellTargetObject in here
int X2GetSpellCastOnSequencerItem(object oItem);

int X2RunUserDefinedSpellScript();

// Similar to SetModuleOverrideSpellscript but only applies to the user
// of this spell. Basically tells the class to run this script when the
// spell starts.
void PRCSetUserSpecificSpellScript(string sScript);

// Similar to SetModuleOverrideSpellscriptFinished but only applies to the
// user of this spell. This prevents the spell from continuing on if the
// ability dictates it.
void PRCSetUserSpecificSpellScriptFinished();

// By setting user-defined spellscripts to the player only, we
// avoid the nasty mess of spellhooking the entire module for one player's
// activities.  This function is mostly only useful inside this include.
int PRCRunUserSpecificSpellScript();

// Useful functions for PRCRunUserSpecificSpellScript but not useful in spell
// scripts.
string PRCGetUserSpecificSpellScript();
int PRCGetUserSpecificSpellScriptFinished();

//#include "x2_inc_itemprop" - Inherited from x2_inc_craft
#include "prc_alterations"
#include "x2_inc_craft"
#include "prc_inc_spells"
#include "prc_inc_combat"
#include "inc_utility"
#include "prc_inc_itmrstr"
#include "inc_newspellbook"
#include "prc_sp_func"
#include "psi_inc_manifest"

int RedWizRestrictedSchool()
{
    object oCaster = OBJECT_SELF;
    int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, oCaster);

    // No need for wasting CPU on non-Red Wizards
    if(iRedWizard > 0)
    {
        object oItem   = GetSpellCastItem();
        int nSpell     = PRCGetSpellId();
        int iSchool    = GetSpellSchool(nSpell);
        int iRWRes1;
        int iRWRes2;

        // Potion drinking is not restricted
        if(oItem != OBJECT_INVALID &&
           (GetBaseItemType(oItem) == BASE_ITEM_ENCHANTED_POTION ||
            GetBaseItemType(oItem) == BASE_ITEM_POTIONS
           ))
            return TRUE;

        // Determine forbidden schools
        if      (GetHasFeat(FEAT_RW_RES_ABJ, oCaster)) iRWRes1 = SPELL_SCHOOL_ABJURATION;
        else if (GetHasFeat(FEAT_RW_RES_CON, oCaster)) iRWRes1 = SPELL_SCHOOL_CONJURATION;
        else if (GetHasFeat(FEAT_RW_RES_DIV, oCaster)) iRWRes1 = SPELL_SCHOOL_DIVINATION;
        else if (GetHasFeat(FEAT_RW_RES_ENC, oCaster)) iRWRes1 = SPELL_SCHOOL_ENCHANTMENT;
        else if (GetHasFeat(FEAT_RW_RES_EVO, oCaster)) iRWRes1 = SPELL_SCHOOL_EVOCATION;
        else if (GetHasFeat(FEAT_RW_RES_ILL, oCaster)) iRWRes1 = SPELL_SCHOOL_ILLUSION;
        else if (GetHasFeat(FEAT_RW_RES_NEC, oCaster)) iRWRes1 = SPELL_SCHOOL_NECROMANCY;
        else if (GetHasFeat(FEAT_RW_RES_TRS, oCaster)) iRWRes1 = SPELL_SCHOOL_TRANSMUTATION;

        if      (GetHasFeat(FEAT_RW_RES_TRS, oCaster)) iRWRes2 = SPELL_SCHOOL_TRANSMUTATION;
        else if (GetHasFeat(FEAT_RW_RES_NEC, oCaster)) iRWRes2 = SPELL_SCHOOL_NECROMANCY;
        else if (GetHasFeat(FEAT_RW_RES_ILL, oCaster)) iRWRes2 = SPELL_SCHOOL_ILLUSION;
        else if (GetHasFeat(FEAT_RW_RES_EVO, oCaster)) iRWRes2 = SPELL_SCHOOL_EVOCATION;
        else if (GetHasFeat(FEAT_RW_RES_ENC, oCaster)) iRWRes2 = SPELL_SCHOOL_ENCHANTMENT;
        else if (GetHasFeat(FEAT_RW_RES_DIV, oCaster)) iRWRes2 = SPELL_SCHOOL_DIVINATION;
        else if (GetHasFeat(FEAT_RW_RES_CON, oCaster)) iRWRes2 = SPELL_SCHOOL_CONJURATION;
        else if (GetHasFeat(FEAT_RW_RES_ABJ, oCaster)) iRWRes2 = SPELL_SCHOOL_ABJURATION;

        // Compare the spell's school versus the restricted schools
        if(iSchool == iRWRes1 || iSchool == iRWRes2)
        {
            FloatingTextStrRefOnCreature(16822359, oCaster, FALSE); // "You cannot cast spells of your prohibited schools. Spell terminated."
            return FALSE;
        }
        // Other arcane casters cannot benefit from red wizard bonuses
        int nClassTest = PRCGetLastSpellCastClass();
        if(GetIsArcaneClass(nClassTest) && nClassTest != CLASS_TYPE_WIZARD)
        {
            FloatingTextStringOnCreature("You have attempted to illegaly merge another arcane caster with a Red Wizard. All spellcasting will now fail.", oCaster, FALSE);
            return FALSE;
        }
    }

    return TRUE;
}

int EShamConc()
{
    object oCaster     = OBJECT_SELF;
    int bInShambler    = GetLocalInt(oCaster, "PRC_IsInEctoplasmicShambler");
    int bJarringSong   = GetHasSpellEffect(SPELL_VIRTUOSO_JARRING_SONG, oCaster);
    int bReturn        = TRUE;
    if(bInShambler || bJarringSong)
    {
        string nSpellLevel = lookup_spell_level(PRCGetSpellId());

        bReturn = GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, (15 + StringToInt(nSpellLevel)));
        if(!bReturn)
        {
            if(bInShambler)
                FloatingTextStrRefOnCreature(16824061, oCaster, FALSE); // "Ectoplasmic Shambler has disrupted your concentration."
            else if(bJarringSong)
                FloatingTextStringOnCreature("Jarring Song has disrupted your concentration.", oCaster, FALSE);
        }
    }

    return bReturn;
}

int NullPsionicsField()
{
    int nCaster = GetLocalInt(OBJECT_SELF, "NullPsionicsField");
    int nTarget = GetLocalInt(PRCGetSpellTargetObject(), "NullPsionicsField");
    int nTest = TRUE;

    // If either of them have it, the spell fizzles.
    if (nCaster || nTarget)
    {
         nTest = FALSE;
    }
    return nTest;
}

int WardOfPeace()
{
    object oCaster = OBJECT_SELF;
    int nReturn = TRUE;
    if (GetLocalInt(oCaster, "TrueWardOfPeace") && GetLastSpellHarmful())
    {
        nReturn = FALSE;
    }

    return nReturn;
}

int DuskbladeArcaneChanneling()
{
    int nReturn = TRUE;
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "DuskbladeChannelActive"))
    {
        object oItem   = GetSpellCastItem();

        // Don't channel from objects
        if(oItem != OBJECT_INVALID)
            return TRUE;    
    
        //dont cast
        nReturn = FALSE;
        int nSpell     = PRCGetSpellId();
        //channeling active
        //find the item
        oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(!GetIsObjectValid(oItem)) oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
        if(!GetIsObjectValid(oItem)) oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
        if(!GetIsObjectValid(oItem)) oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
        if(GetIsObjectValid(oItem)
            && IsTouchSpell(nSpell)
            && IPGetIsMeleeWeapon(oItem)
            && GetIsEnemy(PRCGetSpellTargetObject())
            && !GetLocalInt(oItem, "X2_L_NUMTRIGGERS"))
        {
            //valid spell, store
            //this uses similar things to the spellsequencer/spellsword/arcanearcher stuff
            effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
            FloatingTextStringOnCreature("Duskblade Channel spell stored", OBJECT_SELF);
            //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
            int nSID = PRCGetSpellId()+1;
            int i;
            int nMax = 1;
            int nVal = 1;
            float fDelay = 60.0;
            if(GetLevelByClass(CLASS_TYPE_DUSKBLADE, oPC) >= 13)
            {
                nMax = 5;
                nVal = 2;
            }
            for(i=1; i<=nMax; i++)
            {
                SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i)  , nSID);
                SetLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i), PRCGetCasterLevel(OBJECT_SELF));
                SetLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i), PRCGetMetaMagicFeat());
                SetLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i), PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF));
            }
            SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nMax);

            itemproperty ipTest = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
            IPSafeAddItemProperty(oItem ,ipTest, fDelay);

            for (i = 1; i <= nMax; i++)
            {
                DelayCommand(fDelay, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(i)));
                DelayCommand(fDelay, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(i)));
                DelayCommand(fDelay, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_M" + IntToString(i)));
                DelayCommand(fDelay, DeleteLocalInt(oItem, "X2_L_SPELLTRIGGER_D" + IntToString(i)));
            }
            DelayCommand(fDelay, DeleteLocalInt(oItem, "X2_L_NUMTRIGGERS"));
            //mark it as discharging
            SetLocalInt(oItem, "DuskbladeChannelDischarge", nVal);
            DelayCommand(fDelay, DeleteLocalInt(oItem, "DuskbladeChannelDischarge"));
            //make attack
            ClearAllActions();
            ActionAttack(PRCGetSpellTargetObject());
        }
    }
    return nReturn;

}

int BardSorcPrCCheck()
{
    //check its a bard/sorc spell
    if(PRCGetLastSpellCastClass() != CLASS_TYPE_BARD
        && PRCGetLastSpellCastClass() != CLASS_TYPE_SORCERER)
        return TRUE;
    //check if they are casting via new spellbook
    if(GetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE) == CLASS_TYPE_BARD
        || GetLocalInt(OBJECT_SELF, PRC_CASTERCLASS_OVERRIDE) == CLASS_TYPE_SORCERER)
        return TRUE;
    //check they have bard/sorc in first arcane slot
    if(GetFirstArcaneClass() != CLASS_TYPE_BARD
        && GetFirstArcaneClass() != CLASS_TYPE_SORCERER)
        return TRUE;
    //check they have arcane PrC
    if(!GetArcanePRCLevels(OBJECT_SELF))
        return TRUE;
    //check if the newspellbooks are disabled
    if((GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK)
            && PRCGetLastSpellCastClass() == CLASS_TYPE_SORCERER)
        || (GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK)
            && PRCGetLastSpellCastClass() == CLASS_TYPE_BARD))
        return TRUE;
    //check they have bard/sorc levels
    if(!GetLevelByClass(CLASS_TYPE_BARD)
        && !GetLevelByClass(CLASS_TYPE_SORCERER))
        return TRUE;
    //at this point, they must be using the bioware spellbook
    //from a class that adds to sorc
    FloatingTextStringOnCreature("You must use the new spellbook on the class radial.", OBJECT_SELF, FALSE);
    return FALSE;
}


int KOTCHeavenDevotion(object oTarget)
{
    int iKOTC = GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oTarget);
    int nTest = TRUE;

    if (iKOTC >= 5)
    {
        if (MyPRCGetRacialType(OBJECT_SELF) == RACIAL_TYPE_OUTSIDER)
        {
            if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
            {
                if (GetSpellSchool(GetSpellId()) == SPELL_SCHOOL_ENCHANTMENT)
                {
                    nTest = FALSE;
                }
            }
        }
    }
    return nTest;
}

void CombatMedicHealingKicker()
{
    int nSpellId = PRCGetSpellId();
    if (!GetIsHealingSpell(nSpellId)) //If the spell that was just cast isn't healing, stop now
        return;

    object oTarget = PRCGetSpellTargetObject();

    //Three if/elseif statements. They check which of the healing kickers we use.
    //If no Healing Kicker localints are set, this if block should be ignored.
    if (GetLocalInt(OBJECT_SELF, "Heal_Kicker1") && oTarget != OBJECT_SELF)
    {
        /* Sanctuary effect, with special DC and 1 round duration
         * Script stuff taken from the spell by the same name
         */
        int nDC = 15 + GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, OBJECT_SELF) + GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF);

        effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
        effect eSanc = EffectSanctuary(nDC);
        effect eLink = EffectLinkEffects(eVis, eSanc);

        //Apply the Sanctuary VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_1);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_2);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_3);
    }
    else if (GetLocalInt(OBJECT_SELF, "Heal_Kicker2") && oTarget != OBJECT_SELF)
    {
        /* Reflex save increase, 1 round duration
         */
        int nRefs = GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, OBJECT_SELF);

        effect eSpeed = EffectVisualEffect(VFX_IMP_HASTE);
        effect eRefs = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nRefs);

        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSpeed, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRefs, oTarget, 6.0);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_1);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_2);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_3);
    }
    else if (GetLocalInt(OBJECT_SELF, "Heal_Kicker3") && oTarget != OBJECT_SELF)
    {
        /* Aid effect, with special HP bonus and 1 minute duration
         * Script stuff taken from the spell by the same name
         */
        int nBonus = 8 + GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, OBJECT_SELF);

        effect eAttack = EffectAttackIncrease(1);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
        effect eLink = EffectLinkEffects(eAttack, eSave);

        effect eHP = EffectTemporaryHitpoints(nBonus);

        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

        //Apply the Aid VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 60.0);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, 60.0);

        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_1);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_2);
        DecrementRemainingFeatUses(OBJECT_SELF, FEAT_HEALING_KICKER_3);
    }

}


// Performs the attack portion of the battlecast ability for the havoc mage
void Battlecast()
{
    object oPC = OBJECT_SELF;
    // If battlecast is turned off, exit
    if(!GetLocalInt(oPC, "HavocMageBattlecast")) return;
    object oTarget = PRCGetSpellTargetObject();

    // Get the item used to cast the spell
    object oItem = GetSpellCastItem();

    // Battlecast only works on spells cast by the Havoc Mage, not by items he uses.
    if (oItem != OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("You do not gain Battlecast from Items.", OBJECT_SELF, FALSE);
        return;
    }

    //if its not being cast on a hostile target or its at a location
    //get the nearest living seen hostile insead
    if(!spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
        || !GetIsObjectValid(oTarget))
    {
        oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, 1,
            CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY,
            CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
    }
    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nLevel = GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oPC);
    string sSpellLevel = lookup_spell_level(PRCGetSpellId());
    int nSpellLevel = StringToInt(sSpellLevel);

    // Don't want to smack allies upside the head when casting a spell.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC)
        && oTarget != oPC
        && GetDistanceToObject(oTarget) < FeetToMeters(15.0))
    {
        // Make sure the levels are right for both the caster and the spells.
        // Level 8 spells and under at level 5
        if (nLevel == 5 && 8 >= nSpellLevel) PerformAttack(oTarget, oPC, eVis, 0.0, 0, 0, 0, "*Battlecast Hit*", "*Battlecast Missed*");
        // Level 4 spells and under at level 3
        else if (nLevel >= 3 && 4 >= nSpellLevel) PerformAttack(oTarget, oPC, eVis, 0.0, 0, 0, 0, "*Battlecast Hit*", "*Battlecast Missed*");
        // Level 2 spells and under at level 1
        else if (nLevel >= 1 && 2 >= nSpellLevel) PerformAttack(oTarget, oPC, eVis, 0.0, 0, 0, 0, "*Battlecast Hit*", "*Battlecast Missed*");
    }
}


//Archmage and Heirophant SLA slection/storage setting
int ClassSLAStore()
{
    int nSLAID = GetLocalInt(OBJECT_SELF, "PRC_SLA_Store");
    if(nSLAID)
    {
        FloatingTextStringOnCreature("SLA "+IntToString(nSLAID)+" stored", OBJECT_SELF);
        int nMetamagic = PRCGetMetaMagicFeat();
        int nSpellID = PRCGetSpellId();
        SetPersistantLocalInt(OBJECT_SELF, "PRC_SLA_SpellID_"+IntToString(nSLAID), nSpellID+1);
        SetPersistantLocalInt(OBJECT_SELF, "PRC_SLA_Class_"+IntToString(nSLAID), PRCGetLastSpellCastClass());
        SetPersistantLocalInt(OBJECT_SELF, "PRC_SLA_Meta_"+IntToString(nSLAID), nMetamagic);
        int nSpellLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));
        switch(nMetamagic)
        {
            case METAMAGIC_QUICKEN:     nSpellLevel += 4; break;
            case METAMAGIC_STILL:       nSpellLevel += 1; break;
            case METAMAGIC_SILENT:      nSpellLevel += 1; break;
            case METAMAGIC_MAXIMIZE:    nSpellLevel += 3; break;
            case METAMAGIC_EMPOWER:     nSpellLevel += 2; break;
            case METAMAGIC_EXTEND:      nSpellLevel += 1; break;
        }
        int nUses = 1;
        switch(nSpellLevel)
        {
            default:
            case 9:
            case 8: nUses = 1; break;
            case 7:
            case 6: nUses = 2; break;
            case 5:
            case 4: nUses = 3; break;
            case 3:
            case 2: nUses = 4; break;
            case 1:
            case 0: nUses = 5; break;
        }
        SetPersistantLocalInt(OBJECT_SELF, "PRC_SLA_Uses_"+IntToString(nSLAID), nUses);
        DeleteLocalInt(OBJECT_SELF, "PRC_SLA_Store");
        return FALSE;
    }
    return TRUE;
}

int X2UseMagicDeviceCheck()
{
    int nRet = ExecuteScriptAndReturnInt("x2_pc_umdcheck",OBJECT_SELF);
    return nRet;
}

//------------------------------------------------------------------------------
// GZ: This is a filter I added to prevent spells from firing their original spell
// script when they were cast on items and do not have special coding for that
// case. If you add spells that can be cast on items you need to put them into
// des_crft_spells.2da
//------------------------------------------------------------------------------
int X2CastOnItemWasAllowed(object oItem)
{
    int bAllow = (Get2DACache(X2_CI_CRAFTING_SP_2DA,"CastOnItems",PRCGetSpellId()) == "1");
    if (!bAllow)
    {
        FloatingTextStrRefOnCreature(83453, OBJECT_SELF); // not cast spell on item
    }
    return bAllow;

}

//------------------------------------------------------------------------------
// Execute a user overridden spell script.
//------------------------------------------------------------------------------
int X2RunUserDefinedSpellScript()
{
    // See x2_inc_switches for details on this code
    string sScript =  GetModuleOverrideSpellscript();
    if (sScript != "")
    {
        ExecuteScript(sScript,OBJECT_SELF);
        if (GetModuleOverrideSpellScriptFinished() == TRUE)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//------------------------------------------------------------------------------
// Set the user-specific spell script
//------------------------------------------------------------------------------
void PRCSetUserSpecificSpellScript(string sScript)
{
    SetLocalString(OBJECT_SELF, "PRC_OVERRIDE_SPELLSCRIPT", sScript);
}

//------------------------------------------------------------------------------
// Get the user-specific spell script
//------------------------------------------------------------------------------
string PRCGetUserSpecificSpellScript()
{
    return GetLocalString(OBJECT_SELF, "PRC_OVERRIDE_SPELLSCRIPT");
}

//------------------------------------------------------------------------------
// Finish the spell, if necessary
//------------------------------------------------------------------------------
void PRCSetUserSpecificSpellScriptFinished()
{
    SetLocalInt(OBJECT_SELF, "PRC_OVERRIDE_SPELLSCRIPT_DONE", TRUE);
}

//------------------------------------------------------------------------------
// Figure out if we should finish the spell.
//------------------------------------------------------------------------------
int PRCGetUserSpecificSpellScriptFinished()
{
    int iRet = GetLocalInt(OBJECT_SELF, "PRC_OVERRIDE_SPELLSCRIPT_DONE");
    DeleteLocalInt(OBJECT_SELF, "PRC_OVERRIDE_SPELLSCRIPT_DONE");
    return iRet;
}

//------------------------------------------------------------------------------
// Run a user-specific spell script for classes that use spellhooking.
//------------------------------------------------------------------------------
int PRCRunUserSpecificSpellScript()
{
    string sScript = PRCGetUserSpecificSpellScript();
    if (sScript != "")
    {
        ExecuteScript(sScript,OBJECT_SELF);
        if (PRCGetUserSpecificSpellScriptFinished() == TRUE)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//------------------------------------------------------------------------------
// Created Brent Knowles, Georg Zoeller 2003-07-31
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
//------------------------------------------------------------------------------
int X2GetSpellCastOnSequencerItem(object oItem)
{

    if (!GetIsObjectValid(oItem))
    {
        return FALSE;
    }

    int nMaxSeqSpells = IPGetItemSequencerProperty(oItem); // get number of maximum spells that can be stored
    if(nMaxSeqSpells <1)
    {
        return FALSE;
    }
DoDebug("X2GetSpellCastOnSequencerItem() before cast from item check");
    if (GetIsObjectValid(GetSpellCastItem())) // spell cast from item?
    {
        // we allow scrolls
        int nBt = GetBaseItemType(GetSpellCastItem());
        if ( nBt !=BASE_ITEM_SPELLSCROLL && nBt != 105)
        {
            FloatingTextStrRefOnCreature(83373, OBJECT_SELF);
            return TRUE; // wasted!
        }
    }

DoDebug("X2GetSpellCastOnSequencerItem() before hostile");
    // Check if the spell is marked as hostile in spells.2da
    int nHostile = StringToInt(Get2DACache("spells","HostileSetting",PRCGetSpellId()));
    //spellswords and AAs can store hostile spells
    int bIsSSorAA = FALSE;
    if(nHostile
        && GetLevelByClass(CLASS_TYPE_SPELLSWORD, OBJECT_SELF) >= 4
        && IPGetIsMeleeWeapon(oItem))
    {
        nHostile = FALSE;
        bIsSSorAA = TRUE;
    }
    if(nHostile
        && GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF) >= 2
        && GetPRCSwitch(PRC_USE_NEW_IMBUE_ARROW)
        && GetBaseItemType(oItem) == BASE_ITEM_ARROW)
    {
        nHostile = FALSE;
        bIsSSorAA = TRUE;
    }
DoDebug("X2GetSpellCastOnSequencerItem() after bIsSSorAA stuff");

    if(nHostile)
    {
        FloatingTextStrRefOnCreature(83885,OBJECT_SELF);
        return TRUE; // no hostile spells on sequencers, sorry ya munchkins :)
    }
DoDebug("X2GetSpellCastOnSequencerItem() before nNumberOfTriggers");

    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = PRCGetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER"  +IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER_L"+IntToString(nNumberOfTriggers), PRCGetCasterLevel(OBJECT_SELF));
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER_M"+IntToString(nNumberOfTriggers), PRCGetMetaMagicFeat());
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER_D"+IntToString(nNumberOfTriggers), PRCGetSaveDC(OBJECT_INVALID, OBJECT_SELF));
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        //arcane archers and spellswords add an OnHit:DischargeSequencer property
        if(bIsSSorAA)
        {
            itemproperty ipTest = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
            IPSafeAddItemProperty(oItem ,ipTest, 99999999.9);
        }
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
    }
    else
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);

    return TRUE; // in any case, spell is used up from here, so do not fire regular spellscript
}

//------------------------------------------------------------------------------
// * This is our little concentration system for black blade of disaster
// * if the mage tries to cast any kind of spell, the blade is signaled an event to die
//------------------------------------------------------------------------------
void X2BreakConcentrationSpells()
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    if (GetIsObjectValid(oAssoc))
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
        }
    }
}

//------------------------------------------------------------------------------
// being hit by any kind of negative effect affecting the caster's ability to concentrate
// will cause a break condition for concentration spells
//------------------------------------------------------------------------------
int X2GetBreakConcentrationCondition(object oPlayer)
{
     effect e1 = GetFirstEffect(oPlayer);
     int nType;
     int bRet = FALSE;
     while (GetIsEffectValid(e1) && !bRet)
     {
        nType = GetEffectType(e1);

        if (nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
            nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_FRIGHTENED ||
            nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_CONFUSED ||
            nType == EFFECT_TYPE_DOMINATED || nType == EFFECT_TYPE_POLYMORPH)
         {
           bRet = TRUE;
         }
                    e1 = GetNextEffect(oPlayer);
     }
    return bRet;
}

void X2DoBreakConcentrationCheck()
{
    object oMaster = GetMaster();
    if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
    {
         if (GetIsObjectValid(oMaster))
         {
            int nAction = GetCurrentAction(oMaster);
            // master doing anything that requires attention and breaks concentration
            if (nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT ||
                nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT ||
                nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP ||
                nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL)
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
            else if (X2GetBreakConcentrationCondition(oMaster))
            {
                SignalEvent(OBJECT_SELF,EventUserDefined(X2_EVENT_CONCENTRATION_BROKEN));
            }
         }
    }
}

int CounterspellExploitCheck()
{
    if(GetCurrentAction(OBJECT_SELF) ==  ACTION_COUNTERSPELL)
    {
        ClearAllActions();
        SendMessageToPC(OBJECT_SELF,"Because of the infinite spell casting exploit, you cannot use counterspell in this manner.");
        return TRUE;
    }
    return FALSE;
}
void VoidCounterspellExploitCheck()
{
    if(GetCurrentAction(OBJECT_SELF) ==  ACTION_COUNTERSPELL)
    {
        ClearAllActions();
        SendMessageToPC(OBJECT_SELF,"Because of the infinite spell casting exploit, you cannot use counterspell in this manner.");
    }
}

//------------------------------------------------------------------------------
// if FALSE is returned by this function, the spell will not be cast
// the order in which the functions are called here DOES MATTER, changing it
// WILL break the crafting subsystems
//------------------------------------------------------------------------------
int X2PreSpellCastCode()
{
    object oCaster        = OBJECT_SELF;
    object oTarget        = PRCGetSpellTargetObject();
    object oSpellCastItem = GetSpellCastItem();
    int nOrigSpellID = GetSpellId();
    int nSpellID     = PRCGetSpellId();
    string sComponent = GetStringUpperCase(Get2DACache("spells", "VS", nSpellID));
    int nContinue;

    DeleteLocalInt(oCaster, "SpellConc"); // Something to do with Drangosong Lyrist? - Ornedan
    nContinue = !ExecuteScriptAndReturnInt("prespellcode", oCaster);

    //---------------------------------------------------------------------------
    // This stuff is only interesting for player characters we assume that use
    // magic device always works and NPCs don't use the crafting feats or
    // sequencers anyway. Thus, any NON PC spellcaster always exits this script
    // with TRUE (unless they are DM possessed or in the Wild Magic Area in
    // Chapter 2 of Hordes of the Underdark.
    //---------------------------------------------------------------------------
    if (!GetIsPC(oCaster)
        && !GetPRCSwitch(PRC_NPC_HAS_PC_SPELLCASTING)
        && !GetIsDMPossessed(oCaster)
        && !GetLocalInt(GetArea(oCaster), "X2_L_WILD_MAGIC"))
            return TRUE;

    //counterspell exploit check

    if(nContinue
        && CounterspellExploitCheck())
        nContinue = FALSE;
    DelayCommand(0.1,VoidCounterspellExploitCheck());
    DelayCommand(0.2,VoidCounterspellExploitCheck());
    DelayCommand(0.3,VoidCounterspellExploitCheck());
    DelayCommand(0.4,VoidCounterspellExploitCheck());
    DelayCommand(0.5,VoidCounterspellExploitCheck());
    DelayCommand(0.6,VoidCounterspellExploitCheck());
    DelayCommand(0.7,VoidCounterspellExploitCheck());
    DelayCommand(0.8,VoidCounterspellExploitCheck());
    DelayCommand(0.9,VoidCounterspellExploitCheck());
    DelayCommand(1.0,VoidCounterspellExploitCheck());
    DelayCommand(2.0,VoidCounterspellExploitCheck());
    DelayCommand(3.0,VoidCounterspellExploitCheck());

    //Pnp Tensers Transformation
    if(nContinue
        && GetPRCSwitch(PRC_PNP_TENSERS_TRANSFORMATION)
        && GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION))
        nContinue = FALSE;
    //PnP Timestop
    if(nContinue
        && GetPRCSwitch(PRC_TIMESTOP_NO_HOSTILE)
        && (GetHasSpellEffect(SPELL_TIME_STOP)
            || GetHasSpellEffect(4032)          //epic spell: Greater Timestop
            || GetHasSpellEffect(14236))        //psionic power: Temporal Acceleration
        && (!GetIsObjectValid(oTarget)
            || oTarget != oCaster
            || Get2DACache("spells", "HostileSetting", nOrigSpellID) == "1")
        )
    {
        nContinue = FALSE;
    }
    //Pnp spellschools
    if(nContinue
        && GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD))
    {
        int nSchool = GetSpellSchool(nSpellID);
        if(nSchool == SPELL_SCHOOL_ABJURATION
            && GetHasFeat(2265, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_CONJURATION
            && GetHasFeat(2266, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_DIVINATION
            && GetHasFeat(2267, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_ENCHANTMENT
            && GetHasFeat(2268, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_EVOCATION
            && GetHasFeat(2269, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_ILLUSION
            && GetHasFeat(2270, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_NECROMANCY
            && GetHasFeat(2271, oCaster))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_TRANSMUTATION
            && GetHasFeat(2272, oCaster))
            nContinue = FALSE;
        if(!nContinue)
            FloatingTextStringOnCreature("You cannot cast spells of an opposition school.", oCaster, FALSE);
    }
    //Pnp somatic components
    if(nContinue
        && (GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS)
            || GetPRCSwitch(PRC_PNP_SOMATIC_ITEMS)))
    {
        int nHandFree;
        int nHandRequired;
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
        if(!GetIsObjectValid(oItem)
            || GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD)
            nHandFree = TRUE;
        oItem = oSpellCastItem;
        //check item is not equiped
        if(!nHandFree
            && GetIsObjectValid(oItem)
            && GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS))
        {
            int nSlot;
            nHandRequired = TRUE;
            for(nSlot = 0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
            {
                if(GetItemInSlot(nSlot, oCaster) == oItem)
                    nHandRequired = FALSE;
            }
        }
        //check its a real spell and that it requires a free hand
        if(!nHandFree
            && !nHandRequired
            && !GetIsObjectValid(oItem)
            && GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS))
        {
            if(sComponent == "VS"
                || sComponent == "SV"
                || sComponent == "S")
                nHandRequired = TRUE;
        }

        if(nHandRequired && nHandFree)
        {
            nContinue = FALSE;
            FloatingTextStringOnCreature("You do not have any free hands.", oCaster, FALSE);
        }
    }


    //Corrupt or Sanctified spell
    if(nContinue)
    {
        int nClass = PRCGetLastSpellCastClass();

        // This should probably check if the caster is a spontaneous caster instead? - Ornedan
        if(nClass == CLASS_TYPE_SORCERER || nClass == CLASS_TYPE_BARD)
        {

            //Check for each Corrupt and Sanctified spell
            if(nSpellID == SPELL_ABSORB_STRENGTH           ||
               nSpellID == SPELL_APOCALYPSE_FROM_THE_SKY   ||
               nSpellID == SPELL_CLAWS_OF_THE_BEBILITH     ||
               nSpellID == SPELL_DEATH_BY_THORNS           ||
               nSpellID == SPELL_EVIL_WEATHER              ||
               nSpellID == SPELL_FANGS_OF_THE_VAMPIRE_KING ||
               nSpellID == SPELL_LAHMS_FINGER_DARTS        ||
               nSpellID == SPELL_POWER_LEECH               ||
               nSpellID == SPELL_RAPTURE_OF_RUPTURE        ||
               nSpellID == SPELL_RED_FESTER                ||
               nSpellID == SPELL_ROTTING_CURSE_OF_URFESTRA ||
               nSpellID == SPELL_SEETHING_EYEBANE          ||
               nSpellID == SPELL_TOUCH_OF_JUIBLEX          ||
               nSpellID == SPELL_AYAILLAS_RADIANT_BURST    ||
               nSpellID == SPELL_BRILLIANT_EMANATION       ||
               nSpellID == SPELL_DIVINE_INSPIRATION        ||
               nSpellID == SPELL_DIAMOND_SPRAY             ||
               nSpellID == SPELL_DRAGON_CLOUD              ||
               nSpellID == SPELL_EXALTED_FURY              ||
               nSpellID == SPELL_HAMMER_OF_RIGHTEOUSNESS   ||
               nSpellID == SPELL_PHIERANS_RESOLVE          ||
               nSpellID == SPELL_PHOENIX_FIRE              ||
               nSpellID == SPELL_RAIN_OF_EMBERS            ||
               nSpellID == SPELL_SICKEN_EVIL               ||
               nSpellID == SPELL_STORM_OF_SHARDS           ||
               nSpellID == SPELL_SUNMANTLE                 ||
               nSpellID == SPELL_TWILIGHT_LUCK
               )
            {
                nContinue = FALSE;
            }
        }
    }



    //---------------------------------------------------------------------------
    // Break any spell require maintaining concentration (only black blade of
    // disaster)
    // /*REM*/
    if(GetPRCSwitch(PRC_PNP_BLACK_BLADE_OF_DISASTER))
        X2BreakConcentrationSpells();
        //this is also in summon HB
        //but needed here to handle quickend spells
        //Disintegrate is cast from the blade so doenst end the summon
    //---------------------------------------------------------------------------

    //---------------------------------------------------------------------------
    // Run Red Wizard School Restriction Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = RedWizRestrictedSchool();

    //---------------------------------------------------------------------------
    // Run NullPsionicsField Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = NullPsionicsField();

    //---------------------------------------------------------------------------
    // Run WardOfPeace Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = WardOfPeace();

    //---------------------------------------------------------------------------
    // Run Ectoplasmic Shambler Concentration Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = EShamConc();

    //---------------------------------------------------------------------------
    // Baelnorn attempting to use items while projection
    //---------------------------------------------------------------------------
    if(nContinue                                         && // No need to evaluate if casting has been cancelled already
       GetLocalInt(oCaster, "BaelnornProjection_Active") && // If projection is active AND
       GetIsObjectValid(oSpellCastItem)                     // Cast from an item
       )
    {
        nContinue = FALSE; // Prevent casting
    }

    //---------------------------------------------------------------------------
    // Run Knight of the Chalice Heavenly Devotion check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = KOTCHeavenDevotion(oTarget);

    //---------------------------------------------------------------------------
    // Run Bard/Sorc PrC check
    //---------------------------------------------------------------------------
    if(nContinue)
        nContinue = BardSorcPrCCheck();

    //---------------------------------------------------------------------------
    // Run Inscribe Rune Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = InscribeRune();

    //---------------------------------------------------------------------------
    // Run Class Spell-like-ability Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = ClassSLAStore();

    //---------------------------------------------------------------------------
    // Run use magic device skill check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = X2UseMagicDeviceCheck();

    //-----------------------------------------------------------------------
    // run any user defined spellscript here
    //-----------------------------------------------------------------------
    if (nContinue)
        nContinue = X2RunUserDefinedSpellScript();

    //-----------------------------------------------------------------------
    // run any object-specific spellscript here
    //-----------------------------------------------------------------------
    if (nContinue)
        nContinue = PRCRunUserSpecificSpellScript();
    //---------------------------------------------------------------------------
    // Check for the new restricted itemproperties
    //---------------------------------------------------------------------------
    if(nContinue
        && GetIsObjectValid(oSpellCastItem)
        && !CheckPRCLimitations(oSpellCastItem, oCaster))
    {
        SendMessageToPC(oCaster, "You cannot use "+GetName(oSpellCastItem));
        nContinue = FALSE;
    }
if(DEBUG) DoDebug("x2_inc_spellhook pre-crafting "+IntToString(nContinue));
    //-----------------------------------------------------------------------
    // Check if spell was used for Duskblade channeling
    //-----------------------------------------------------------------------
    if (nContinue)
        nContinue = DuskbladeArcaneChanneling();


    //---------------------------------------------------------------------------
    // The following code is only of interest if an item was targeted
    //---------------------------------------------------------------------------
    if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {

if(DEBUG) DoDebug("x2_inc_spellhook pre-x2_pc_craft "+IntToString(nContinue));
        //-----------------------------------------------------------------------
        // Check if spell was used to trigger item creation feat
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft", oCaster);

if(DEBUG) DoDebug("x2_inc_spellhook pre-sequencer "+IntToString(nContinue));
        //-----------------------------------------------------------------------
        // Check if spell was used for on a sequencer item
        // Check if spell was used for Arcane Archer Imbue Arrow
        // Check if spell was used for Spellsword ChannelSpell
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = (!X2GetSpellCastOnSequencerItem(oTarget));


if(DEBUG) DoDebug("x2_inc_spellhook pre-tagbased "+IntToString(nContinue));
        //-----------------------------------------------------------------------
        // * Execute item OnSpellCast At routing script if activated
        //-----------------------------------------------------------------------
        if (nContinue
            && GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
        {
            SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
            int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget), oCaster);
            if (nRet == X2_EXECUTE_SCRIPT_END)
                return FALSE;
        }
if(DEBUG) DoDebug("x2_inc_spellhook pre-X2CastOnItemWasAllowed "+IntToString(nContinue));

        //-----------------------------------------------------------------------
        // Prevent any spell that has no special coding to handle targetting of items
        // from being cast on items. We do this because we can not predict how
        // all the hundreds spells in NWN will react when cast on items
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = X2CastOnItemWasAllowed(oTarget);
    }



    //spellsharing for bonded summoner
    //Pnp familiar spellsharing
    if (nContinue
        && GetHasFeat(FEAT_SUMMON_FAMILIAR, oCaster)
        && (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oCaster)
            || !GetPRCSwitch(PRC_PNP_FAMILIARS)
        && oTarget == oCaster
        && GetIsObjectValid(GetLocalObject(oCaster, "Familiar"))
        && (PRCGetLastSpellCastClass() == CLASS_TYPE_WIZARD ||
            PRCGetLastSpellCastClass() == CLASS_TYPE_SORCERER)
        && !GetLocalInt(oCaster, "PRC_SPELL_HOLD")     //holding the charge doesnt work
        && Get2DACache("spells", "Range", nSpellID) == "T"
        && !GetIsObjectValid(oSpellCastItem)     // no item spells
        && nSpellID != SPELL_SHAPECHANGE         // no polymorphs
        && nSpellID != SPELL_POLYMORPH_SELF
        && nSpellID != SPELL_TENSERS_TRANSFORMATION))
    {
        object oFam = GetLocalObject(oCaster, "Familiar");
        // Run the ShareSpell code to duplicate the spell on the familiar
       // spell has to be wiz/sorc and cast on self to be shared
        AssignCommand(oFam,
            ActionCastSpell(nSpellID, PRCGetCasterLevel(), 0, PRCGetSaveDC(oFam, oFam, nSpellID), PRCGetMetaMagicFeat(), CLASS_TYPE_INVALID, FALSE, TRUE, oFam));
    }

    // Healer Spellsharing
    if(nContinue && GetLevelByClass(CLASS_TYPE_HEALER, oCaster) >= 8)
    {
        object oComp = GetLocalObject(oCaster, "HealerCompanion");
        ActionCastSpell(nSpellID, PRCGetCasterLevel(), 0, PRCGetSaveDC(oComp, oComp, nSpellID), PRCGetMetaMagicFeat(), CLASS_TYPE_INVALID, FALSE, TRUE, oComp);
    }

    if(GetPRCSwitch(PRC_PW_SPELL_TRACKING))
    {
        if(GetLocalInt(oCaster, "UsingActionCastSpell"))
        {
        }
        else
        {
            string sSpell = IntToString(nOrigSpellID)+"|"; //use original spellID
            string sStored = GetPersistantLocalString(oCaster, "persist_spells");
            SetPersistantLocalString(oCaster, "persist_spells", sStored+sSpell);
        }
    }

    //Combat medic healing kicker
    if(nContinue && GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC))
        CombatMedicHealingKicker();

    // Havoc Mage Battlecast
    if(nContinue && GetLevelByClass(CLASS_TYPE_HAVOC_MAGE))
        Battlecast();

    //casting from staffs uses caster DC calculations
    if(nContinue
       && GetIsObjectValid(oSpellCastItem)
       && GetBaseItemType(oSpellCastItem) == BASE_ITEM_MAGICSTAFF
       && GetPRCSwitch(PRC_STAFF_CASTER_LEVEL))
    {
        int nDC = 10 + StringToInt(lookup_spell_innate(nSpellID));
        nDC += (GetAbilityForClass(GetFirstArcaneClass(oCaster), oCaster)-10)/2;
        SetLocalInt(oCaster, PRC_DC_BASE_OVERRIDE, nDC);
        DelayCommand(0.01, DeleteLocalInt(oCaster, PRC_DC_BASE_OVERRIDE));
    }
if(DEBUG) DoDebug("x2_inc_spellhook pre-spellfire "+IntToString(nContinue));
    //---------------------------------------------------------------------------
    // Spellfire
    //---------------------------------------------------------------------------
    if(nContinue)
    {
        if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oCaster))
        {
            int nStored = GetPersistantLocalInt(oCaster, "SpellfireLevelStored");
            int nCON = GetAbilityScore(oCaster, ABILITY_CONSTITUTION);
            if(nStored > 4 * nCON)
            {
                if(!GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, 25)) nContinue = FALSE;
            }
            else if(nStored > 3 * nCON)
            {
                if(!GetIsSkillSuccessful(oCaster, SKILL_CONCENTRATION, 20)) nContinue = FALSE;
            }
        }
        if(GetLocalInt(oTarget, "SpellfireAbsorbFriendly") && GetIsFriend(oTarget, oCaster))
        {
            if(CheckSpellfire(oCaster, oTarget, TRUE))
            {
                PRCShowSpellResist(oCaster, oTarget, SPELL_RESIST_MANTLE);
                nContinue = FALSE;
            }
        }
    }

    //-----------------------------------------------------------------------
    // Shifting casting restrictions
    //-----------------------------------------------------------------------
    // The variable tells that the new form is unable to cast spells (very inaccurate, determined by racial type)
    // with somatic or vocal components and is lacking Natural Spell feat
    if(nContinue                                           && // Any point to checking this?
       GetLocalInt(oCaster, "PRC_Shifting_RestrictSpells")    // See if the restriction might apply
       )
    {
        int bDisrupted  = FALSE;
        int nSpellLevel = StringToInt(Get2DACache("spells", "Innate", nSpellID));

        // Somatic component and no silent meta or high enough auto-still
        if((FindSubString(sComponent, "S") != -1)                                       &&
           !(PRCGetMetaMagicFeat() & METAMAGIC_STILL)                                   &&
           !(GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_3, oCaster)                       ||
             (nSpellLevel <= 6 && GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_2, oCaster)) ||
             (nSpellLevel <= 3 && GetHasFeat(FEAT_EPIC_AUTOMATIC_STILL_SPELL_1, oCaster))
             )
           )
            bDisrupted = TRUE;
        // Vocal component and no silent meta or high enough auto-silent
        if((FindSubString(sComponent, "V") != -1)                                        &&
           !(PRCGetMetaMagicFeat() & METAMAGIC_SILENT)                                   &&
           !(GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_3, oCaster)                       ||
             (nSpellLevel <= 6 && GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_2, oCaster)) ||
             (nSpellLevel <= 3 && GetHasFeat(FEAT_EPIC_AUTOMATIC_SILENT_SPELL_1, oCaster))
             )
           )
            bDisrupted = TRUE;
        if(bDisrupted)
        {
            FloatingTextStrRefOnCreature(16828386, oCaster, FALSE); // "Your spell failed due to being in a form that prevented either a somatic or a vocal component from being used"
            nContinue = FALSE;
        }
    }

    //Cleaning spell variables used for holding the charge
    if(!GetLocalInt(oCaster, "PRC_SPELL_EVENT"))
    {
        DeleteLocalInt(oCaster, "PRC_SPELL_CHARGE_COUNT");
        DeleteLocalInt(oCaster, "PRC_SPELL_CHARGE_SPELLID");
        DeleteLocalObject(oCaster, "PRC_SPELL_CONC_TARGET");
        DeleteLocalInt(oCaster, "PRC_SPELL_METAMAGIC");
        DeleteLocalManifestation(oCaster, "PRC_POWER_HOLD_MANIFESTATION");
    }
    else if(GetLocalInt(oCaster, "PRC_SPELL_CHARGE_SPELLID") != nSpellID)
    {   //Sanity check, in case something goes wrong with the action queue
        DeleteLocalInt(oCaster, "PRC_SPELL_EVENT");
    }

    return nContinue;
}


// Test main
//void main(){}