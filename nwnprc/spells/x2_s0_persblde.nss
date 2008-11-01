//::///////////////////////////////////////////////
//:: Shelgarn's Persistent Blade
//:: X2_S0_PersBlde
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dagger to battle for the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 26, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, Aug 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"

//::///////////////////////////////////////////////
//:: PRCGetIsMagicStatBonus
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns the modifier from the ability
    score that matters for this caster
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int PRCGetIsMagicStatBonus(object oCaster)
{
    //Declare major variables
    int nClass;
    int nAbility;

    if(nClass = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_INTELLIGENCE;
        }
    }
    if(nClass = GetLevelByClass(CLASS_TYPE_BARD, oCaster) || GetLevelByClass(CLASS_TYPE_SORCERER, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_CHARISMA;
        }
    }
    else if(nClass = GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) || GetLevelByClass(CLASS_TYPE_DRUID, oCaster)
         || GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) || GetLevelByClass(CLASS_TYPE_RANGER, oCaster))
    {
        if(nClass > 0)
        {
            nAbility = ABILITY_WISDOM;
        }
    }

    return GetAbilityModifier(nAbility, oCaster);
}


//Creates the weapon that the creature will be using.
void spellsCreateItemForSummoned(object oCaster, float fDuration)
{
    //Declare major variables
    int nStat = PRCGetIsMagicStatBonus(oCaster) / 2;
    // GZ: Just in case...
    if (nStat >20)
    {
        nStat =20;
    }
    else if (nStat <1)
    {
        nStat = 1;
    }
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    int i = 1;
    object oOldSummon;
    while(GetIsObjectValid(oSummon))
    {
        oOldSummon = oSummon;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster, i);
        i++;
    }
    oSummon = oOldSummon;
    object oWeapon;
    if (GetIsObjectValid(oSummon))
    {
        //Create item on the creature, epuip it and add properties.
        oWeapon = CreateItemOnObject("NW_WSWDG001", oSummon);
        // GZ: Fix for weapon being dropped when killed
        SetDroppableFlag(oWeapon,FALSE);
        AssignCommand(oSummon, ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND));
        // GZ: Check to prevent invalid item properties from being applies
        if (nStat>0)
        {
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(nStat), oWeapon,fDuration);
        }
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1,5),oWeapon,fDuration);
    }
}


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    // End of Spell Cast Hook


    //Declare major variables
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF) / 2;
    if (nDuration <1)
    {
        nDuration = 1;
    }
    effect eSummon = EffectSummonCreature("X2_S_FAERIE001");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    //Make metamagic check for extend
    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, PRCGetSpellTargetLocation());
    float fDuration = RoundsToSeconds(nDuration);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), fDuration);

    object oSelf = OBJECT_SELF;
    DelayCommand(1.0, spellsCreateItemForSummoned(oSelf,TurnsToSeconds(nDuration)));


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

