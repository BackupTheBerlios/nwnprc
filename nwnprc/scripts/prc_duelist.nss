//::///////////////////////////////////////////////
//:: [Duelist Feats]
//:: [prc_duelist.nss]
//:://////////////////////////////////////////////
//:: Check to see which Duelist feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 20, 2003
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_clsfunc"
#include "x2_i0_spells"

// * Applies the Duelist's AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus (2x int bonus if epic)
// * iOnOff = TRUE/FALSE
// * iEpic = TRUE/FALSE
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff, int iEpic = FALSE)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = iEpic ? iIntBonus * 2 : iIntBonus;

    // limits bonus to class level as per 3.5e rules.
    int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST,oPC);
    if(iIntBonus > iDuelistLevel) iIntBonus = iDuelistLevel;

    if(iOnOff){
        SetCompositeBonus(oSkin, "CannyDefenseBonus", iIntBonus, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != TRUE)
            FloatingTextStringOnCreature("Canny Defense On", oPC);
        SetLocalInt(oPC, "CannyDefense", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "CannyDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != FALSE)
            FloatingTextStringOnCreature("Canny Defense Off", oPC);
        SetLocalInt(oPC, "CannyDefense", FALSE);
   }
}

// * Applies the Duelist's reflex bonuses as CompositeBonuses on the object's skin.
// * iLevel = integer reflex save bonus
void DuelistGrace(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "GraceBonus") == iLevel) return;

    if(iLevel > 0){
        SetCompositeBonus(oSkin, "GraceBonus", iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != TRUE)
            FloatingTextStringOnCreature("Grace On", oPC);
        SetLocalInt(oPC, "Grace", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "GraceBonus", 0, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEBASETYPE_REFLEX);
        if(GetLocalInt(oPC, "Grace") != FALSE)
            FloatingTextStringOnCreature("Grace Off", oPC);
        SetLocalInt(oPC, "Grace", FALSE);
   }
}

void RemoveDuelistPreciseStrike(object oWeap)
{
    RemoveEffectsFromSpell(GetItemPossessor(oWeap), SPELL_DUELIST_DAMAGE);
}

void DuelistPreciseStrike(object oPC, object oWeap)
{
    ActionCastSpellOnSelf(SPELL_DUELIST_DAMAGE);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    //Determine which duelist feats the character has
    int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    int bEpicCD = 0;//GetHasFeat(FEAT_EPIC_DUELIST, oPC);
    int bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_1D4, oPC) ? 1 : 0;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_2D4, oPC) ? 2 : bPStrk;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_3D4, oPC) ? 3 : bPStrk;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_4D4, oPC) ? 4 : bPStrk;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_5D4, oPC) ? 5 : bPStrk;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_6D4, oPC) ? 6 : bPStrk;
    int bGrace  = GetHasFeat(FEAT_GRACE_2, oPC) ? 2 : 0;
        bGrace  = GetHasFeat(FEAT_GRACE_4, oPC) ? 4 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_6, oPC) ? 6 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_8, oPC) ? 8 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_10, oPC) ? 10 : bGrace;
    int iLefthand = GetBaseItemType(oLefthand);

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
        DuelistCannyDefense(oPC, oSkin, TRUE, bEpicCD);
    else
        DuelistCannyDefense(oPC, oSkin, FALSE);

    if(bPStrk > 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD &&
      (GetBaseItemType(oWeapon) == BASE_ITEM_RAPIER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_DAGGER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSWORD))
          DuelistPreciseStrike(oPC, oWeapon);
    
    if(GetLocalInt(oPC,"ONEQUIP") == 1)
       RemoveDuelistPreciseStrike(GetPCItemLastUnequipped());
       
    if(GetBaseAC(oArmor) != 0 ||
       GetBaseItemType(oLefthand) == BASE_ITEM_SMALLSHIELD ||
       GetBaseItemType(oLefthand) == BASE_ITEM_LARGESHIELD ||
       GetBaseItemType(oLefthand) == BASE_ITEM_TOWERSHIELD)
          RemoveDuelistPreciseStrike(oWeapon);
    
    if(bGrace > 0 && GetBaseAC(oArmor) == 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
          DuelistGrace(oPC, oSkin, bGrace);
    else
          DuelistGrace(oPC, oSkin, 0);

}
