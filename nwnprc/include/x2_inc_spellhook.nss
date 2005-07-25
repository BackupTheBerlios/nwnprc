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
// oItem - pass GetSpellTargetObject in here
int X2CastOnItemWasAllowed(object oItem);

// Sequencer Item Property Handling
// Returns TRUE (and charges the sequencer item) if the spell
// ... was cast on an item AND
// ... the item has the sequencer property
// ... the spell was non hostile
// ... the spell was not cast from an item
// in any other case, FALSE is returned an the normal spellscript will be run
// oItem - pass GetSpellTargetObject in here
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
#include "prc_inc_switch"
#include "prc_inc_itmrstr"
#include "inc_utility"

int RedWizRestrictedSchool()
{

    int iRedWizard = GetLevelByClass(CLASS_TYPE_RED_WIZARD, OBJECT_SELF);
    int nSpell = PRCGetSpellId();
    int iRWRes1;
    int iRWRes2;

    if (GetHasFeat(FEAT_RW_RES_ABJ, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_ABJURATION;
    else if (GetHasFeat(FEAT_RW_RES_CON, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_CONJURATION;
    else if (GetHasFeat(FEAT_RW_RES_DIV, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_DIVINATION;
    else if (GetHasFeat(FEAT_RW_RES_ENC, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_ENCHANTMENT;
    else if (GetHasFeat(FEAT_RW_RES_EVO, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_EVOCATION;
    else if (GetHasFeat(FEAT_RW_RES_ILL, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_ILLUSION;
    else if (GetHasFeat(FEAT_RW_RES_NEC, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_NECROMANCY;
    else if (GetHasFeat(FEAT_RW_RES_TRS, OBJECT_SELF)) iRWRes1 = SPELL_SCHOOL_TRANSMUTATION;

    if (GetHasFeat(FEAT_RW_RES_TRS, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_TRANSMUTATION;
    else if (GetHasFeat(FEAT_RW_RES_NEC, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_NECROMANCY;
    else if (GetHasFeat(FEAT_RW_RES_ILL, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_ILLUSION;
    else if (GetHasFeat(FEAT_RW_RES_EVO, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_EVOCATION;
    else if (GetHasFeat(FEAT_RW_RES_ENC, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_ENCHANTMENT;
    else if (GetHasFeat(FEAT_RW_RES_DIV, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_DIVINATION;
    else if (GetHasFeat(FEAT_RW_RES_CON, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_CONJURATION;
    else if (GetHasFeat(FEAT_RW_RES_ABJ, OBJECT_SELF)) iRWRes2 = SPELL_SCHOOL_ABJURATION;
    
    if (iRedWizard > 0)
    {
        int iSchool = GetSpellSchool(nSpell);
        if (iSchool == iRWRes1) 
        {
            FloatingTextStringOnCreature("You cannot cast spells of your prohibited schools. Spell terminated.", OBJECT_SELF, FALSE);
            return FALSE;
        }
        else if (iSchool == iRWRes2)
        {
            FloatingTextStringOnCreature("You cannot cast spells of your prohibited schools. Spell terminated.", OBJECT_SELF, FALSE);
            return FALSE;
        }
        else
        {
        return TRUE;        
        }
    }

    return TRUE;
}

int EShamConc()
{
    int nConc = GetLocalInt(OBJECT_SELF, "EShamConc");
    string nSpellLevel = lookup_spell_level(PRCGetSpellId());
    int nTest = TRUE;
    
    if (nConc)
    {
         nTest = GetIsSkillSuccessful(OBJECT_SELF, SKILL_CONCENTRATION, (15 + StringToInt(nSpellLevel)));
         if (!nTest)  FloatingTextStringOnCreature("Ectoplasmic Shambler has disrupted your concentration.", OBJECT_SELF, FALSE);
    }
    return nTest;
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

    object oTarget = GetSpellTargetObject();

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
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nLevel = GetLevelByClass(CLASS_TYPE_HAVOC_MAGE, oPC);
    string sSpellLevel = lookup_spell_level(PRCGetSpellId());
    int nSpellLevel = StringToInt(sSpellLevel);
    
    // Don't want to smack allies upside the head when casting a spell.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oPC) && oTarget != oPC)
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
    if (nMaxSeqSpells <1)
    {
        return FALSE;
    }

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

    // Check if the spell is marked as hostile in spells.2da
    int nHostile = StringToInt(Get2DACache("spells","HostileSetting",PRCGetSpellId()));
    if(nHostile ==1)
    {
        FloatingTextStrRefOnCreature(83885,OBJECT_SELF);
        return TRUE; // no hostile spells on sequencers, sorry ya munchkins :)
    }

    int nNumberOfTriggers = GetLocalInt(oItem, "X2_L_NUMTRIGGERS");
    // is there still space left on the sequencer?
    if (nNumberOfTriggers < nMaxSeqSpells)
    {
        // success visual and store spell-id on item.
        effect eVisual = EffectVisualEffect(VFX_IMP_BREACH);
        nNumberOfTriggers++;
        //NOTE: I add +1 to the SpellId to spell 0 can be used to trap failure
        int nSID = PRCGetSpellId()+1;
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER" + IntToString(nNumberOfTriggers), nSID);
        SetLocalInt(oItem, "X2_L_SPELLTRIGGER_L" + IntToString(nNumberOfTriggers), PRCGetCasterLevel(OBJECT_SELF));
        SetLocalInt(oItem, "X2_L_NUMTRIGGERS", nNumberOfTriggers);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, OBJECT_SELF);
        FloatingTextStrRefOnCreature(83884, OBJECT_SELF);
    }
    else
    {
        FloatingTextStrRefOnCreature(83859,OBJECT_SELF);
    }

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
    object oTarget = GetSpellTargetObject();
    int nContinue;

    DeleteLocalInt(OBJECT_SELF, "SpellConc");
    nContinue = !ExecuteScriptAndReturnInt("prespellcode",OBJECT_SELF);

    //---------------------------------------------------------------------------
    // This stuff is only interesting for player characters we assume that use
    // magic device always works and NPCs don't use the crafting feats or
    // sequencers anyway. Thus, any NON PC spellcaster always exits this script
    // with TRUE (unless they are DM possessed or in the Wild Magic Area in
    // Chapter 2 of Hordes of the Underdark.
    //---------------------------------------------------------------------------
    if (!GetIsPC(OBJECT_SELF)
        && !GetPRCSwitch(PRC_NPC_HAS_PC_SPELLCASTING)
        && !GetIsDMPossessed(OBJECT_SELF)
        && !GetLocalInt(GetArea(OBJECT_SELF), "X2_L_WILD_MAGIC"))
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
            || oTarget != OBJECT_SELF
            || Get2DACache("spells", "HostileSetting", GetSpellId()) == "1")
        )
    {
        nContinue = FALSE;
    }        
    //Pnp spellschools
    if(nContinue
        && GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS)
        && GetLevelByClass(CLASS_TYPE_WIZARD))
    {       
        int nSchool = GetSpellSchool(PRCGetSpellId());
        if(nSchool == SPELL_SCHOOL_ABJURATION
            && GetHasFeat(2265))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_CONJURATION
            && GetHasFeat(2266))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_DIVINATION
            && GetHasFeat(2267))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_ENCHANTMENT
            && GetHasFeat(2268))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_EVOCATION
            && GetHasFeat(2269))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_ILLUSION
            && GetHasFeat(2270))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_NECROMANCY
            && GetHasFeat(2271))
            nContinue = FALSE;
        else if(nSchool == SPELL_SCHOOL_TRANSMUTATION
            && GetHasFeat(2272))
            nContinue = FALSE;
        if(!nContinue)
            FloatingTextStringOnCreature("You cannot cast spells of an opposition school.", OBJECT_SELF, FALSE); 
    }        
    //Pnp somatic components
    if(nContinue
        && (GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS)
            || GetPRCSwitch(PRC_PNP_SOMATIC_ITEMS)))
    {
        int nSpellId = GetSpellId(); //use the original spellID
        int nHandFree;
        int nHandRequired;
        object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        if(!GetIsObjectValid(oItem)
            || GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD)
            nHandFree = TRUE;
        oItem = GetSpellCastItem();   
        //check item is not equiped
        if(!nHandFree 
            && GetIsObjectValid(oItem)
            && GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS))
        {
            int nSlot;
            nHandRequired = TRUE;
            for(nSlot = 0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
            {
                if(GetItemInSlot(nSlot) == oItem)
                    nHandRequired = FALSE;
            }
        }   
        //check its a real spell and that it requires a free hand
        if(!nHandFree 
            && !nHandRequired
            && !GetIsObjectValid(oItem)
            && GetPRCSwitch(PRC_PNP_SOMATIC_COMPOMENTS))
        {
            string sComponent = Get2DACache("spells", "VS", nSpellId);
            if(sComponent == "VS"
                || sComponent == "SV"
                || sComponent == "S")            
                nHandRequired = TRUE;
        }     
        
        if(nHandRequired && nHandFree)
        {
            nContinue = FALSE;   
            FloatingTextStringOnCreature("You do not have any free hands.", OBJECT_SELF, FALSE);   
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
    // Run Ectoplasmic Shambler Concentration Check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = EShamConc();      
        
    //---------------------------------------------------------------------------
    // Run Knight of the Chalice Heavenly Devotion check
    //---------------------------------------------------------------------------
    if (nContinue)
        nContinue = KOTCHeavenDevotion(oTarget);            

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
        && GetIsObjectValid(GetSpellCastItem())
        && !CheckPRCLimitations(GetSpellCastItem(), OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, "You cannot use "+GetName(GetSpellCastItem()));
        nContinue = FALSE;
    }


    //---------------------------------------------------------------------------
    // The following code is only of interest if an item was targeted
    //---------------------------------------------------------------------------
    if (GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {

        //-----------------------------------------------------------------------
        // Check if spell was used to trigger item creation feat
        //-----------------------------------------------------------------------
        if (nContinue) 
            nContinue = !ExecuteScriptAndReturnInt("x2_pc_craft",OBJECT_SELF);

        //-----------------------------------------------------------------------
        // Check if spell was used for on a sequencer item
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = (!X2GetSpellCastOnSequencerItem(oTarget));
            
        //-----------------------------------------------------------------------
        // Check if spell was used for Arcane Archer Imbue Arrow
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = !ExecuteScriptAndReturnInt("aa_spellhook",OBJECT_SELF);
            
        //-----------------------------------------------------------------------
        // Check if spell was used for Spellsword ChannelSpell
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = !ExecuteScriptAndReturnInt("prc_spell_chanel",OBJECT_SELF);            

        //-----------------------------------------------------------------------
        // * Execute item OnSpellCast At routing script if activated
        //-----------------------------------------------------------------------
        if (nContinue
            && GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
        {
            SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
            int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oTarget),OBJECT_SELF);
            if (nRet == X2_EXECUTE_SCRIPT_END)
                return FALSE;
        }

        //-----------------------------------------------------------------------
        // Prevent any spell that has no special coding to handle targetting of items
        // from being cast on items. We do this because we can not predict how
        // all the hundreds spells in NWN will react when cast on items
        //-----------------------------------------------------------------------
        if (nContinue)
            nContinue = X2CastOnItemWasAllowed(oTarget);
    }



    //spellsharing for bonded summoner
    if (nContinue 
        && GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER) 
        && !GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        object oFam = GetLocalObject(OBJECT_SELF, "BONDED");
        // Run the ShareSpell code to duplicate the spell on the familiar
        if (GetIsObjectValid(oFam))
        {
            int bIsWizSorc = (PRCGetLastSpellCastClass() == CLASS_TYPE_WIZARD ||
                PRCGetLastSpellCastClass() == CLASS_TYPE_SORCERER);

            // spell has to be wiz/sorc and cast on self to be shared
            if ((oTarget == OBJECT_SELF) && (bIsWizSorc) &&
                (!GetIsObjectValid(GetSpellCastItem())) && // no item spells
                (PRCGetSpellId()!=SPELL_SHAPECHANGE) &&       // no polymorphs
                (PRCGetSpellId()!=SPELL_POLYMORPH_SELF) &&
                (PRCGetSpellId()!=SPELL_TENSERS_TRANSFORMATION))
            {
                SetLocalInt(oFam, PRC_CASTERLEVEL_OVERRIDE, PRCGetCasterLevel());
                AssignCommand(oFam, ActionCastSpellAtObject (PRCGetSpellId(), oFam, PRCGetMetaMagicFeat(), TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                // Make sure this variable gets deleted as quickly as possible in case it's added in error.
                AssignCommand(oFam, DeleteLocalInt(oFam, PRC_CASTERLEVEL_OVERRIDE));
            }
        }
    }
    //Pnp familiar spellsharing
    if(nContinue 
        && GetPRCSwitch(PRC_PNP_FAMILIARS) 
        && !GetIsObjectValid(GetSpellCastItem())
        && oTarget == OBJECT_SELF
        && GetHasFeat(FEAT_SUMMON_FAMILIAR))
    {
        object oFam = GetLocalObject(OBJECT_SELF, "Familiar");
        AssignCommand(oFam, ActionDoCommand(SetLocalInt(oFam, "PRC_Castlevel_Override", PRCGetCasterLevel())));
        AssignCommand(oFam, ActionCastSpellAtObject (PRCGetSpellId(), oFam, PRCGetMetaMagicFeat(), TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        // Make sure this variable gets deleted as quickly as possible in case it's added in error.
        AssignCommand(oFam, ActionDoCommand(DeleteLocalInt(oFam, "PRC_Castlevel_Override")));
    
    }
    
    if(GetPRCSwitch(PRC_PW_SPELL_TRACKING))
    {
        if(GetLocalInt(OBJECT_SELF, "UsingActionCastSpell"))
        {
        }
        else
        {
            string sSpell = IntToString(GetSpellId())+"|"; //use original spellID
            string sStored = GetPersistantLocalString(OBJECT_SELF, "persist_spells");
            SetPersistantLocalString(OBJECT_SELF, "persist_spells", sStored+sSpell); 
        }
    }
    
    //Combat medic healing kicker
    if(nContinue && GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC))
        CombatMedicHealingKicker();

    // Havoc Mage Battlecast
    if(nContinue && GetLevelByClass(CLASS_TYPE_HAVOC_MAGE))
        Battlecast();

    return nContinue;
}

