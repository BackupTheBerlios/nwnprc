#include "prc_spell_const"
#include "inc_combat2"
#include "nw_i0_spells"

int RangedAttackBonus(object oPC, object oWeap, object oTarget, int iMod = 0)
{
    //Declare in instantiate major variables
    int iBAB = GetBaseAttackBonus(oPC);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iDex > 0 ? iDex:0;

    int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC) && GetHasFeat(FEAT_ZEN_ARCHERY,oPC);
        iDex = iWis>iDex ? iWis:iDex;

    int RangeWeap=StringToInt(Get2DAString("baseitems", "RangedWeapon", iType));;
    int iBonus;
    int iEnhancement;

    object oAmmu= oWeap;
    switch (iType)
    {
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
         oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
         iEnhancement = GetAmmunitionEnhancement(oAmmu);
         break;
      case BASE_ITEM_SLING:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
        iEnhancement = GetAmmunitionEnhancement(oAmmu);
        break;
      case BASE_ITEM_SHORTBOW:
      case BASE_ITEM_LONGBOW:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
        iEnhancement = GetAmmunitionEnhancement(oAmmu);
       break;
    }

  
    iEnhancement = GetWeaponRangeEnhancement(oWeap,oPC) ;

    int Distance=FloatToInt(GetDistanceBetween(oPC,oTarget));

    int mRange=Distance/RangeWeap*2;
    int mMelee=GetMeleeAttackers15ft(oPC);

    int bPBShot = (mMelee) ? (GetHasFeat(FEAT_POINT_BLANK_SHOT,oPC)? 1:-4):0 ;
    int iTrueStrike = GetHasSpellEffect(SPELL_TRUE_STRIKE,oPC) ? 20:0 ;

    //Add up total attack bonus

        int iAttackBonus = iBAB;
        iAttackBonus += iDex;
        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
        iAttackBonus += iEnhancement;
        iAttackBonus += iMod;
        iAttackBonus -= mRange;
        iAttackBonus += bPBShot;
        iAttackBonus += iBonus; // Weapon mastery


    iAttackBonus += GetWeaponAtkBonusIP(oWeap,oTarget);
    iAttackBonus += AtkSpellEffect(oPC);

    return iAttackBonus;
}

void main()
{
   int nSpellId = GetSpellId();
   object oTarget = GetSpellTargetObject();
   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
   int iEnhancement = GetWeaponRangeEnhancement(oWeap,OBJECT_SELF);
   int iDamageType = GetWeaponDamageType(oWeap);

   int iDamage =0;

   if (!GetWeaponRanged(oWeap)) return;

   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);

   int iSizeT =StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oItem)));

   int iBonusA = iSizeT > 2 ? (iSizeT-2)*4:0 ;
   effect eDamage;

   if (iSizeT ==4 && !GetWeaponRanged(oWeap)) iBonusA+=4;

   float fDelay = 0.0;

   effect  eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);

   int iRoll = RangedAttackBonus(OBJECT_SELF, oWeap, oTarget, 0)+d20();
   //Perform 1 attack

   int iRef = MySavingThrow(SAVING_THROW_REFLEX,oTarget,iRoll-iBonusA);

    if(iRef == 0)
    {
       AssignCommand(oTarget,ClearAllActions());
       AssignCommand(oTarget,ActionPutDownItem(oItem));
    }


}
