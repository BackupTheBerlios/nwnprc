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

  // Get the 2da row to lookup the poison from the last three letters of the tag
  int nRow = StringToInt(GetStringRight(sTag,3));

  if (nRow ==0)
  {
     FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
     WriteTimestampedLogEntry ("Error: Item with tag " +GetTag(oItem) + " has the PoisonWeapon spellscript attached but tag does not contain 3 letter receipe code at the end!");
     return;
  }

   int nSaveDC     =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"SaveDC",nRow));
   int nDuration   =  5;
   int nPoisonType =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"PoisonType",nRow)) ;
   int nApplyDC    =  StringToInt(Get2DAString(X2_IP_POISONWEAPON_2DA,"ApplyCheckDC",nRow)) ;

   int bHasFeat = GetHasFeat( FEAT_BLARCH_POISON_BLOOD , OBJECT_SELF);
   if (!bHasFeat) // without handle poison feat, do ability check
   {
           FloatingTextStrRefOnCreature(83368,oPC);               //"Failed"
           return;
   }
   else
   {
       // some feedback to
       FloatingTextStrRefOnCreature(83369,oPC);         //"Auto success "
   }

    itemproperty ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON,nSaveDC,nPoisonType);
   IPSafeAddItemProperty(oTarget, ip,IntToFloat(nDuration),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

   effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
   effect eDam = EffectDamage(3, DAMAGE_TYPE_DIVINE);
   //technically this is not 100% safe but since there is no way to retrieve the sub
   //properties of an item (i.e. itempoison), there is nothing we can do about it
   if (IPGetItemHasItemOnHitPropertySubType(oTarget, 19))
   {
       FloatingTextStrRefOnCreature(83361,oPC);         //"Weapon is coated with poison"
       IPSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_ACID),IntToFloat(nDuration),X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,FALSE);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, OBJECT_SELF);
   }
   else
   {
       FloatingTextStrRefOnCreature(83360,oPC);         //"Nothing happens
   }

}