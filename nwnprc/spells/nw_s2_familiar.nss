//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dispel"

const int PACKAGE_ELEMENTAL_STR = PACKAGE_ELEMENTAL ;
const int PACKAGE_ELEMENTAL_DEX = PACKAGE_FEY ;
const int FAMILIAR_PNP_BAT = 1;
const int FAMILIAR_PNP_CAT = 2;
const int FAMILIAR_PNP_HAWK = 3;
const int FAMILIAR_PNP_LIZARD = 4;
const int FAMILIAR_PNP_OWL = 5;
const int FAMILIAR_PNP_RAT = 6;
const int FAMILIAR_PNP_RAVEN = 7;
const int FAMILIAR_PNP_SNAKE = 8;
const int FAMILIAR_PNP_TOAD = 9;
const int FAMILIAR_PNP_WEASEL = 10;


void BondedSummon2()
{
    object oPC = OBJECT_SELF;
    //piggy-backed onto multisummon code
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummon))
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
        if(DEBUG) DoDebug("nw_s2_familiar - ElementalFamiliar(): oSummon " + IntToString(i) + " = " + GetName(oSummon), oPC);
    }
    oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i-1);
    //set its name
    SetName(oSummon, GetFamiliarName(oPC));
    //apply bonus based on level
    int nArcaneLevel = GetCasterLvl(TYPE_ARCANE);
    object oSkin  = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oSummon);
    //in all cases
    IPSafeAddItemProperty(oSkin,
        PRCItemPropertyBonusFeat(ITEM_PROPERTY_IMPROVED_EVASION));  
    //9+ levels
    if(nArcaneLevel >= 9)
    {
        IPSafeAddItemProperty(oSkin,
            ItemPropertyBonusSpellResistance(GetSRByValue(nArcaneLevel+5)));    
    }
    //11+ levels
    if(nArcaneLevel >= 11)
    {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,
            SupernaturalEffect(EffectMovementSpeedIncrease(30)),
            oSummon);
    }
    //add their ondeath special
    AddEventScript(oSummon, EVENT_NPC_ONDEATH, "prc_bond_death");
}  

void BondedSummoner()
{
    object oPC = OBJECT_SELF;
    //find a suitable resref
    string sResRef;
    if(GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF))
    {
        if(GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF))
            sResRef = "x1_s_airsmall"; //this is the 4HD version in the SRD, which is medium
        if(GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF))
            sResRef = "prc_s_airlarge";
        if(GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF))
            sResRef = "nw_s_airhuge";
        if(GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF))
            sResRef = "nw_s_airgreat";
        if(GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF))
            sResRef = "nw_s_airelder";    
    }
    else if(GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF))
    {
        if(GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF))
            sResRef = "x1_s_earthsmall"; //this is the 4HD version in the SRD, which is medium
        if(GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF))
            sResRef = "prc_s_earthlarge";
        if(GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF))
            sResRef = "nw_s_earthhuge";
        if(GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF))
            sResRef = "nw_s_earthgreat";
        if(GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF))
            sResRef = "nw_s_earthelder";    
    }
    else if(GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF))
    {
        if(GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF))
            sResRef = "x1_s_firesmall"; //this is the 4HD version in the SRD, which is medium
        if(GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF))
            sResRef = "prc_s_firelarge";
        if(GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF))
            sResRef = "nw_s_firehuge";
        if(GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF))
            sResRef = "nw_s_firegreat";
        if(GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF))
            sResRef = "nw_s_fireelder";    
    }
    else if(GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF))
    {
        if(GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF))
            sResRef = "x1_s_watersmall"; //this is the 4HD version in the SRD, which is medium
        if(GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF))
            sResRef = "prc_s_waterlarge";
        if(GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF))
            sResRef = "nw_s_waterhuge";
        if(GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF))
            sResRef = "nw_s_watergreat";
        if(GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF))
            sResRef = "nw_s_waterelder";    
    }
    //piggy-backed onto multisummon code
    MultisummonPreSummon(oPC, TRUE);
    effect eSummon = SupernaturalEffect(EffectSummonCreature(sResRef, VFX_IMP_UNSUMMON));
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummon, oPC);
    //needs to be delayed so it finds thew new summon properly
    DelayCommand(0.0, BondedSummon2());
}  

void main()
{

    if(GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        object oPC = OBJECT_SELF;
        int nFamiliarType = GetPersistantLocalInt(OBJECT_SELF, "PnPFamiliarType");
        string sResRef;
        effect eBonus;
        switch(nFamiliarType)
        {
            case 0:
                //start conversation
                StartDynamicConversation("prc_pnp_fam_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, TRUE, oPC);
                return;
                break;
            case FAMILIAR_PNP_BAT:
                eBonus = EffectSkillIncrease(SKILL_LISTEN, 3);
                sResRef = "prc_pnpfam_bat";
                break;
            case FAMILIAR_PNP_CAT:
                eBonus = EffectSkillIncrease(SKILL_MOVE_SILENTLY, 3);
                break;
            case FAMILIAR_PNP_HAWK:
                eBonus = EffectSkillIncrease(SKILL_SPOT, 3);
                sResRef = "prc_pnpfam_hawk";
                break;
            case FAMILIAR_PNP_LIZARD:
                eBonus = EffectSkillIncrease(SKILL_JUMP, 3);
                break;
            case FAMILIAR_PNP_OWL:
                eBonus = EffectSkillIncrease(SKILL_SPOT, 3);
                break;
            case FAMILIAR_PNP_RAT:
                eBonus = EffectSavingThrowIncrease(SAVING_THROW_FORT, 3);
                sResRef = "prc_pnpfam_rat";
                break;
            case FAMILIAR_PNP_RAVEN:
                eBonus = EffectSkillIncrease(SKILL_APPRAISE, 3);
                break;
            case FAMILIAR_PNP_SNAKE:
                eBonus = EffectSkillIncrease(SKILL_BLUFF, 3);
                break;
            case FAMILIAR_PNP_TOAD:
                eBonus = EffectTemporaryHitpoints(3);
                break;
            case FAMILIAR_PNP_WEASEL:
                eBonus = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 3);
                break;
        }
        if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
        {
            BondedSummoner();
            return;
        }
        //this is the masters bonus
        eBonus = SupernaturalEffect(eBonus);
        if(!GetHasFeatEffect(FEAT_SUMMON_FAMILIAR, oPC))
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, OBJECT_SELF);
        effect eInvalid;
        eBonus = eInvalid;

        //spawn the familiar
        object oFam;
        oFam = RetrieveCampaignObject("prc_data", "Familiar", GetLocation(OBJECT_SELF), oPC);
        if(!GetIsObjectValid(oFam))
            oFam = CreateObject(OBJECT_TYPE_CREATURE, sResRef, GetLocation(OBJECT_SELF));
        if(!GetIsObjectValid(oFam))
            return;//something odd going on here

        //familiar basics
        int nABBonus = GetBaseAttackBonus(OBJECT_SELF)-GetBaseAttackBonus(oFam);
        int nAttacks = (GetBaseAttackBonus(OBJECT_SELF)/5)+1;
        if(nAttacks > 5)
            nAttacks = 5;
        SetBaseAttackBonus(nAttacks, oFam);
        //temporary HP for the moment, have to think of a better idea later
        int nHPBonus = (GetMaxHitPoints(OBJECT_SELF)/2)-GetMaxHitPoints(oFam);
        int i;
        for(i=0;i<GetPRCSwitch(FILE_END_SKILLS);i++)
        {
            int nBonus = GetSkillRank(i, OBJECT_SELF)-GetSkillRank(i, oFam);
            eBonus = EffectLinkEffects(eBonus, EffectSkillIncrease(i, nBonus));
        }
        //saving throws
        int nSaveRefBonus = GetReflexSavingThrow(OBJECT_SELF)-GetReflexSavingThrow(oFam);
        int nSaveFortBonus = GetFortitudeSavingThrow(OBJECT_SELF)-GetFortitudeSavingThrow(oFam);
        int nSaveWillBonus = GetWillSavingThrow(OBJECT_SELF)-GetWillSavingThrow(oFam);


        //scaling bonuses
        int nFamLevel = GetLevelByClass(CLASS_TYPE_WIZARD)
            +GetLevelByClass(CLASS_TYPE_SORCERER)
                +GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER);
        int nACBonus = nFamLevel/2;
        int nIntBonus = nFamLevel/2;
        int nSRBonus;
        if(nFamLevel>11)
            nSRBonus = nFamLevel+5;

        //effect doing
        eBonus = EffectLinkEffects(eBonus, EffectACIncrease(nACBonus, AC_NATURAL_BONUS));
        eBonus = EffectLinkEffects(eBonus, EffectAbilityIncrease(ABILITY_INTELLIGENCE, nIntBonus));
        eBonus = EffectLinkEffects(eBonus, EffectSpellResistanceIncrease(nSRBonus));
        eBonus = EffectLinkEffects(eBonus, EffectAttackIncrease(nABBonus));
        eBonus = EffectLinkEffects(eBonus, EffectTemporaryHitpoints(nHPBonus));
        eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nSaveRefBonus));
        eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_FORT, nSaveFortBonus));
        eBonus = EffectLinkEffects(eBonus, EffectSavingThrowIncrease(SAVING_THROW_WILL, nSaveWillBonus));
        //skills were linked earlier
        eBonus = SupernaturalEffect(eBonus);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oFam);

        //add the familiar as a henchman
        int nMaxHenchmen = GetMaxHenchmen();
        SetMaxHenchmen(99);
        AddHenchman(oFam, OBJECT_SELF);
        SetMaxHenchmen(nMaxHenchmen);
        //mark it as a familiar
        SetLocalInt(oFam, "IsFamiliar", TRUE);
        //link the owner to its familiar
        SetLocalObject(OBJECT_SELF, "Familiar", oFam);
        //raisable
        AssignCommand(oFam, SetIsDestroyable(FALSE, TRUE, TRUE));
        //set the name
        //set its name
        SetName(oFam, GetFamiliarName(OBJECT_SELF));
        //dont do normal familiars too
        return;
    }

    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
        BondedSummoner();
    else
        SummonFamiliar();

    if (GetLevelByClass(CLASS_TYPE_DIABOLIST) >= 2)
    {
        object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
        if (GetAppearanceType(oFam) != APPEARANCE_TYPE_IMP)
        {
            DestroyObject(oFam, 0.5);
        }
    }

}