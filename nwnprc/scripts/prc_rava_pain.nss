//::///////////////////////////////////////////////
//:: Pain Touch
//:: rava_visage
//::
//:://////////////////////////////////////////////
/*
    Touched Target takes damage depending upon Ravager Level,
    and if carrying something in the left hand
    (1d4 + level), or unarmed (1d8 + level)
    The +12/10 is to symbolize the base damage
*/
//:://////////////////////////////////////////////
//:: Created By: aser
//:: Created On: Feb/21/04
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "X2_inc_switches"
#include "prc_class_const"
#include "inc_combat"
void main()
{
    //Declare major variables

    int ravaLevel = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF);
    int iStrMod = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
    int unarmDamage = d8(1) + ravaLevel;
    int armedDamage = d4(1) + ravaLevel;

    unarmDamage = unarmDamage + iStrMod;
    armedDamage = armedDamage + iStrMod;

    effect eDam1;
    effect eDam2;
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    eDam1 = EffectDamage(unarmDamage, DAMAGE_TYPE_DIVINE);
    eDam2 = EffectDamage(armedDamage, DAMAGE_TYPE_DIVINE);
    object oTarget = GetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    int iDamage = GetMeleeWeaponDamage(OBJECT_SELF,oItem1,TRUE,0);

    //Melee Attack
    if(TouchAttackMelee(oTarget,TRUE)>0)
    {
             //If left hand empty, the touch attack hand is empty
        if(!GetIsObjectValid(oItem2))
        {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else
        {
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
          effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);
          ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);

        }
     }
}

