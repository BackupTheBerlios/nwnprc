//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
//::
//:: Found main script in rust monster scripts.
//:: Edited for PRC use. aser
//::

#include "NW_I0_GENERIC"

int IsItemMetal(object oItem)
{
  int nReturnVal=0;
  int type=GetBaseItemType(oItem);
  if((type<6)||type==9||type==10||type==12||type==13||type==17||type==18
     ||type==22||type==27||type==32||type==33||type==35||type==37||type==28
     ||type==40||type==41||type==42||type==47||type==51||type==52||type==53
     ||type==57||type==59||type==60||type==63||type==65||type==76||type==7
     ||type==19||type==20||type==21||type==28||type==31||type==44||type==45
     ||type==46||type==56||type==62||type==78||type==25||type==55||type==58)
  {
    nReturnVal=2;// Mostly metal
  }
  return nReturnVal;
}

void main()
{

        object oPC = OBJECT_SELF;
        object oTarget = GetSpellTargetObject();

    int iHit = TouchAttackMelee(oTarget);
     if (iHit > 0)
      {
        if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oTarget) != OBJECT_INVALID)
        {
          object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
          if (!GetWeaponRanged(oWeapon) && (IsItemMetal(oWeapon)>0))
          {
            string sWeapon = GetName(oWeapon);
            if(ReflexSave(oTarget,20))// saved
            {
             SendMessageToPC(oPC,"The weapon resists the rust effects.");
            }
            else //didn't save
            {
             SendMessageToPC(oPC,"You destroyed your opponents weapon.");
             DestroyObject(oWeapon);
             ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_ACID_L),oTarget);
            }
          }
        }
        else
        {
          if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget) != OBJECT_INVALID)
          {
            object oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTarget);
            if (IsItemMetal(oWeapon)>0)
            {
              string sWeapon = GetName(oWeapon);
              if(ReflexSave(oTarget,20))// saved
               {
                SendMessageToPC(oPC,"The weapon resists the rust effects.");
               }
               else //didn't save
               {
                SendMessageToPC(oPC,"You destroyed your opponents weapon.");
                DestroyObject(oWeapon);
                ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_ACID_L),oTarget);
               }
            }
          }
        }
     }
}
