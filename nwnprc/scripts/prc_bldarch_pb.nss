//::///////////////////////////////////////////////
//:: Poison Blood spellscript
//:: prc_bldarch_pb
//:: Copyright (c) 2004 PRC Consortium.
//:://////////////////////////////////////////////
/*

    Restrictions
    ... only weapons and ammo can be poisoned
    ... restricted to piercing / slashing  damage

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-11
//:: Updated On: 2003-08-21
//:://////////////////////////////////////////////
#include "x2_inc_itemprop"
#include "X2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"

void main()
{

  object oItem   = GetSpellCastItem();
  object oPC     = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  string sTag    = GetTag(oItem);

  if (oTarget == OBJECT_INVALID || GetObjectType(oTarget) != OBJECT_TYPE_ITEM)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }
  int nType = GetBaseItemType(oTarget);
  if (!IPGetIsMeleeWeapon(oTarget) &&
      !IPGetIsProjectile(oTarget)   &&
       nType != BASE_ITEM_SHURIKEN &&
       nType != BASE_ITEM_DART &&
       nType != BASE_ITEM_THROWINGAXE)
  {
       FloatingTextStrRefOnCreature(83359,oPC);         //"Invalid target "
       return;
  }

  if (IPGetIsBludgeoningWeapon(oTarget))
  {
       FloatingTextStrRefOnCreature(83367,oPC);         //"Weapon does not do slashing or piercing damage "
       return;
  }

  if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19)) // 19 == itempoison
  {
        FloatingTextStrRefOnCreature(83407,oPC); // weapon already poisoned
        return;
  }

   // save DC and duration
   int nSaveDC =  10 + GetLevelByClass(CLASS_TYPE_BLARCHER, OBJECT_SELF);
   int nDuration = d6(2);
   
   // the poisons slot in poison.2da
   int nPoisonType = 105;

   int bHasFeat = GetHasFeat( FEAT_BLARCH_POISON_BLOOD , OBJECT_SELF);
   if (!bHasFeat) // without blood archer feat, they cannot use ability
   {
           FloatingTextStringOnCreature("Poison Blood ability failed.", oPC, FALSE);
           return;
   }

   // only adds poison property if the weapon is not already poisoned.
   itemproperty ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, nSaveDC, nPoisonType);
   IPSafeAddItemProperty(oTarget, ip, IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
   
   // Visual Effects and damage to player for using the ability
   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
   effect eDam = EffectDamage(3, DAMAGE_TYPE_DIVINE);
   
   //technically this is not 100% safe but since there is no way to retrieve the sub
   //properties of an item (i.e. itempoison), there is nothing we can do about it
   if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19))
   {
       // If weapon is poisoned, add proper effects
       FloatingTextStrRefOnCreature(83361, oPC);         //"Weapon is coated with poison"
       IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID), IntToFloat(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, FALSE);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
   }
   else
   {
       // Inform the player that no poison was added
       FloatingTextStringOnCreature("No poison applied to weapon.", oPC, FALSE);
   }
}