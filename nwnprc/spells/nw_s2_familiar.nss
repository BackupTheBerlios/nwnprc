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

#include "inc_npc"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_misc_const"
#include "prc_ipfeat_const"
#include "prc_alterations"
#include "inc_utility"
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
void ElementalFamiliar2(string iSize, string iType);

void ElementalFamiliar()
{

// add
    location loc = GetLocation(OBJECT_SELF);
    vector vloc = GetPositionFromLocation( loc );
    vector vLoc;
    location locSummon;

    vLoc = Vector( vloc.x + (Random(6) - 2.5f),
                       vloc.y + (Random(6) - 2.5f),
                       vloc.z );
    locSummon = Location( GetArea(OBJECT_SELF), vLoc, IntToFloat(Random(361) - 180) );

//

    object oPC = OBJECT_SELF;

    string iType = GetHasFeat(FEAT_BONDED_AIR, OBJECT_SELF)   ? "AIR"  : "" ;
           iType = GetHasFeat(FEAT_BONDED_EARTH, OBJECT_SELF) ? "EARTH"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_FIRE, OBJECT_SELF)  ? "FIRE"  : iType ;
           iType = GetHasFeat(FEAT_BONDED_WATER, OBJECT_SELF) ? "WATER"  : iType ;

    string iSize = GetHasFeat(FEAT_ELE_COMPANION_MED, OBJECT_SELF) ? "MED"  : "" ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_LAR, OBJECT_SELF) ? "LAR"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_HUG, OBJECT_SELF) ? "HUG"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_GRE, OBJECT_SELF) ? "GRE"  : iSize ;
           iSize = GetHasFeat(FEAT_ELE_COMPANION_ELD, OBJECT_SELF) ? "ELD"  : iSize ;

    string sRef = "HEN_"+iType+"_"+iSize+"2";
/*
    object oEle = CreateLocalNPC(OBJECT_SELF,ASSOCIATE_TYPE_FAMILIAR,sRef,locSummon,1);
    effect eDomi = SupernaturalEffect(EffectCutsceneDominated());
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDomi, oEle));
*/
    //Replaced by multisummon code
    //primogenitor
    MultisummonPreSummon(OBJECT_SELF, TRUE);
    effect eSummon = SupernaturalEffect(EffectSummonCreature(sRef, VFX_IMP_UNSUMMON));
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummon, OBJECT_SELF);
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
    while(GetIsObjectValid(oSummon))
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
SendMessageToPC(OBJECT_SELF, "oSummon "+IntToString(i)+" = "+GetName(oSummon));
    }
    DelayCommand(0.1, ElementalFamiliar2(iSize, iType));
}

void ElementalFamiliar2(string iSize, string iType)
{
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
    while(GetIsObjectValid(oSummon))
    {
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i);
SendMessageToPC(OBJECT_SELF, "oSummon "+IntToString(i)+" = "+GetName(oSummon));
    }
    object oEle = GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF, i-1);
SendMessageToPC(OBJECT_SELF, "oEle "+IntToString(i-1)+" = "+GetName(oSummon));
    //need to check this worked


    SetLocalObject(OBJECT_SELF, "BONDED",oEle);

    object oCreB=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oEle);
    object oCreL=GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oEle);
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oEle);
    object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oEle);


    int iPack ,iSave ;
    int iHD = GetHitDice(OBJECT_SELF);
    int iBonus = (iHD/5)+1;

    if (iType=="FIRE")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEIMMUNITY_100_PERCENT),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT),oHide);

        iPack = PACKAGE_ELEMENTAL_DEX ;
        iSave =  IP_CONST_SAVEBASETYPE_REFLEX ;

        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3),oHide);
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_1d6),oCreB);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d6),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,2),oHide);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreL);
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEBONUS_2d8),oCreR);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="WATER")
    {

       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3+1),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus*2/3),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

       iPack = PACKAGE_ELEMENTAL_STR ;
       iSave =  IP_CONST_SAVEBASETYPE_FORTITUDE ;

         if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="AIR")
    {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iBonus),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus*2/3),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        iPack = PACKAGE_ELEMENTAL_DEX ;
        iSave =  IP_CONST_SAVEBASETYPE_REFLEX ;


        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,5),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }
    else if (iType=="EARTH")
    {
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iBonus),oHide);
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_CON,iBonus*2/3),oHide);

        iPack = PACKAGE_ELEMENTAL_STR ;
        iSave =  IP_CONST_SAVEBASETYPE_FORTITUDE ;


        if (iSize=="MED")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
        }
        else if (iSize=="LAR")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="HUG")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_5_HP),oHide);
        }
        else if (iSize=="GRE")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,3),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }
        else if (iSize=="ELD")
        {
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyReducedSavingThrow(IP_CONST_SAVEBASETYPE_WILL,4),oHide);
           // AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,IP_CONST_DAMAGESOAK_10_HP),oHide);
        }

    }

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oHide);

    int Arcanlvl = GetCasterLvl(TYPE_ARCANE);


   if (Arcanlvl>26)
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oHide);

    if (Arcanlvl>21)
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oHide);

    if (Arcanlvl>11)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oHide);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_BarbEndurance),oHide);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oHide);
    }
    else  if (Arcanlvl>8)
    {
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oHide);
      ApplyEffectToObject(DURATION_TYPE_INSTANT,SupernaturalEffect(EffectSpellResistanceIncrease(Arcanlvl+5)),oEle);
    }


   //int i;
   for (i = 1; i < iHD; i++)
     LevelUpHenchman( oEle,CLASS_TYPE_ELEMENTAL,TRUE,iPack);

   object oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oEle);
     if  (!GetIsObjectValid(oCweap))
        oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oEle);
     if  (!GetIsObjectValid(oCweap))
        oCweap = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oEle);


   int iSoak =-1;

   if (iSize=="LAR" || iSize=="HUG")
      iSoak = IP_CONST_DAMAGESOAK_5_HP;
   else if (iSize=="GRE" || iSize=="ELD")
      iSoak = IP_CONST_DAMAGESOAK_10_HP;
   if (iHD>24)  iSoak++;
   if (iHD>30)  iSoak++;


   if (iSoak>=0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20,iSoak),oHide);



    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),GetItemInSlot(INVENTORY_SLOT_NECK,oEle));
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(iBonus),oHide);

    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS,iBonus),oHide);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS,iBonus),oHide);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSavingThrow(iSave,iBonus),oHide);

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
                SetLocalString(OBJECT_SELF, "DynConv_Script", "prc_pnp_fam_conv");
                ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
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
            //override normal familiars
            effect eInvalid;
            eBonus = eInvalid;
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
        //dont do normal familiars too
        return;
    }

    if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER))
        ElementalFamiliar();
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