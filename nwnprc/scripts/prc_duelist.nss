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


// * Applies the Duelist's AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus (2x int bonus if epic)
// * iOnOff = TRUE/FALSE
// * iEpic = TRUE/FALSE
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff, int iEpic = FALSE)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = iEpic ? iIntBonus * 2 : iIntBonus;

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

// * Applies the Duelist's parry skill bonuses as CompositeBonuses on the object's skin.
// * Bonus is determined by object's Duelist level
void DuelistElaborateParry(object oPC, object oSkin)
{
    int iClassBonus = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
    if(GetLocalInt(oSkin, "ElaborateParryBonus") == iClassBonus) return;

    SetCompositeBonus(oSkin, "ElaborateParryBonus", iClassBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PARRY);
}

void RemoveDuelistPreciseStrike(object oWeap)
{
   int iSlashBonus = GetLocalInt(oWeap,"DuelistPreciseSlash");
   int iSmashBonus = GetLocalInt(oWeap,"DuelistPreciseSmash");
   
   if (iSlashBonus) RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_SLASHING, iSlashBonus, 1, "DuelistPreciseSlash", -1, DURATION_TYPE_TEMPORARY);
   if (iSmashBonus) RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_BLUDGEONING, iSmashBonus, 1, "DuelistPreciseSmash", -1, DURATION_TYPE_TEMPORARY);
}

void DuelistPreciseStrike(object oPC, object oWeap)
{
   int iSlashBonus = 0;
   int iSmashBonus = 0;
   int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST,oPC);
   
   RemoveDuelistPreciseStrike(oWeap);
   
   
   //I'll do this based on level as opposed to by feats.
   switch(iDuelistLevel)
   {
      case 2: case 3: case 4: case 5:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d6;
         break;
      case 6: case 7: case 8: case 9:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d6;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d6;
         break;
      case 10: case 11: case 12: case 13:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d8;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d6;
         break;
      case 14: case 15: case 16: case 17:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d8;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d8;
         break;
      case 18: case 19: case 20: case 21:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d10;
	 iSmashBonus = IP_CONST_DAMAGEBONUS_1d8;
	 break;
      case 22: case 23: case 24: case 25:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d10;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d10;
         break;
      case 26: case 27: case 28: case 29:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d12;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d10;
         break;
      case 30:
         iSlashBonus = IP_CONST_DAMAGEBONUS_1d12;
         iSmashBonus = IP_CONST_DAMAGEBONUS_1d12;
         break;
      default:
         break;
   }
   if(iSlashBonus) SetLocalInt(oWeap,"DuelistPreciseSlash",iSlashBonus);
   if(iSmashBonus) SetLocalInt(oWeap,"DuelistPreciseSmash",iSmashBonus);
   
   if(iSlashBonus) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING, iSlashBonus), oWeap, 99999.9);
   if(iSmashBonus) AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, iSmashBonus), oWeap, 99999.9);
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
    int bEpicCD = GetHasFeat(FEAT_EPIC_DUELIST, oPC);
    int bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_1d6, oPC) ? 1 : 0;
        bPStrk  = GetHasFeat(FEAT_PRECISE_STRIKE_2d6, oPC) ? 2 : bPStrk;
    int bGrace  = GetHasFeat(FEAT_GRACE_2, oPC) ? 2 : 0;
        bGrace  = GetHasFeat(FEAT_GRACE_4, oPC) ? 4 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_6, oPC) ? 6 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_8, oPC) ? 8 : bGrace;
        bGrace  = GetHasFeat(FEAT_GRACE_10, oPC) ? 10 : bGrace;
    int bElabPr = GetHasFeat(FEAT_ELABORATE_PARRY, oPC);
    int iLefthand = GetBaseItemType(oLefthand);

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
        DuelistCannyDefense(oPC, oSkin, TRUE, bEpicCD);
    else
        DuelistCannyDefense(oPC, oSkin, FALSE);

    if(bPStrk > 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD &&
      (GetBaseItemType(oWeapon) == BASE_ITEM_RAPIER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_DAGGER ||
       GetBaseItemType(oWeapon) == BASE_ITEM_SHORTSWORD))
          DuelistPreciseStrike(oPC, oWeapon);
    
    if(GetLocalInt(oPC,"ONEQUIP") == 1)
       RemoveDuelistPreciseStrike(GetPCItemLastUnequipped());
       
    if(GetBaseAC(oArmor) != 0 ||
       GetBaseItemType(oLefthand) == BASE_ITEM_LARGESHIELD ||
       GetBaseItemType(oLefthand) == BASE_ITEM_TOWERSHIELD)
          RemoveDuelistPreciseStrike(oWeapon);
    
    if(bGrace > 0 && GetBaseAC(oArmor) == 0 &&
       GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD &&
       GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD)
          DuelistGrace(oPC, oSkin, bGrace);
    else
          DuelistGrace(oPC, oSkin, 0);

    if(bElabPr > 0) DuelistElaborateParry(oPC, oSkin);

}
