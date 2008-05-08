//::///////////////////////////////////////////////
//:: Races of the Dragon Feats
//:: prc_rotdfeat.nss
//::///////////////////////////////////////////////
/*
    Handles the following feats from Races of the Dragon:
    Dragon Tail
    Dragon Wings
    Dragonwrought
*/
//:://////////////////////////////////////////////
//:: Created By: Fox
//:: Created On: Nov 13, 2007
//:://////////////////////////////////////////////

void dragonwrought(object oSkin);

#include "pnp_shft_poly"
#include "prc_ipfeat_const"
#include "x2_inc_itemprop"

//the feats common to all dragonwrought
void dragonwrought(object oSkin)
{
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, ItemPropertyDarkvision(), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_DRAGON_IMMUNE), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        
}

void main()
{

        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        int nSize = PRCGetCreatureSize(oPC);     
        int nWingType = CREATURE_WING_TYPE_DRAGON;
        int nTailType = CREATURE_TAIL_TYPE_LIZARD;

        //Adds the dragon tail
        if(GetHasFeat(FEAT_KOB_DRAGON_TAIL, oPC))
        {
            string sResRef = "prc_kobdratail_";
            sResRef += GetAffixForSize(nSize);
            if(DEBUG) DoDebug(sResRef);
            AddNaturalSecondaryWeapon(oPC, sResRef);
            DoTail(oPC, nTailType);             
        }
        
        //Adds the wings
        if(GetHasFeat(FEAT_KOB_DRAGON_WING_A, oPC) 
           || GetHasFeat(FEAT_KOB_DRAGON_WING_BC, oPC) 
           || GetHasFeat(FEAT_KOB_DRAGON_WING_BG, oPC) 
           || GetHasFeat(FEAT_KOB_DRAGON_WING_BM, oPC))
        {
             SetCompositeBonus(oSkin, "Dragon_Glide", 10, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
             DoWings(oPC, nWingType);
        }
        
        //+2 to Hide for Black, Blue, White, and Copper heritage
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BK, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BL, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_WH, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CP, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Hide", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
        }
        
        //+2 to Appraise for Red heritage
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_RD, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Appraise", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_APPRAISE);
        }
        
        //+2 to Move Silently for Green heritage
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GR, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Move_Silent", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
        }
        
        //+2 to Persuade(Diplomacy) for Amethyst and Crystal heritage
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_AM, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_CR, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Persuade", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
        }
        
        //+2 to Lore for Emerald, Sapphire, and Brass Heritage.  Brass should
        //have Gather Information, using Lore as substitute.
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_EM, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SA, oPC)
           || GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BS, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Lore", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE);
        }
        
        //+2 to Jump for Topaz, standing in for the +2 to Swim they should have
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_TP, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Jump", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_JUMP);
        }
        
        //+2 to Search for Bronze, standing in for +2 to Survival
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_BZ, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Search", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        }
        
        //+2 to Heal for Gold heritage
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_GD, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Heal", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
        }
        
        //+2 to Bluff for Silver heritage, standing in for +2 to Disguise
        if(GetHasFeat(FEAT_KOB_DRAGONWROUGHT_SR, oPC))
        {
             dragonwrought(oSkin);
             SetCompositeBonus(oSkin, "DA_Bluff", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_BLUFF);
        }
}
        