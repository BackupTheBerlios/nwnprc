//::///////////////////////////////////////////////
//:: Cruelest Cut
//:: rava_cruelestcut
//::
//:://////////////////////////////////////////////
/*
    Target takes Constitution damage of 1d4 for 5 rds
    plus 1 round for every ravager level
*/
//:://////////////////////////////////////////////
//:: Created By: aser
//:: Created On: Feb/21/04
//:://////////////////////////////////////////////

//#include "NW_I0_SPELLS"
//#include "X2_inc_switches"
#include "inc_combat"
#include "prc_class_const"
void main()
{

    //Declare major variables
    int iLevel = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
    int iDur = 5 + iLevel;

    //Setup some base damage
    int iStrMod = GetAbilityModifier(ABILITY_STRENGTH,OBJECT_SELF);
    int unarmDamage = d3(1);
    int armedDamage = GetMeleeWeaponDamage(OBJECT_SELF,oItem1,TRUE,0);
    unarmDamage = unarmDamage + iStrMod;
    armedDamage = armedDamage + iStrMod;

    //Set the Effects
    effect eDam1;
    effect eDam2;
    eDam1 = EffectDamage(unarmDamage, DAMAGE_TYPE_BLUDGEONING);
    eDam2 = EffectDamage(armedDamage, DAMAGE_TYPE_SLASHING);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eEffect;
    eEffect = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1));
    effect eLink1 = EffectLinkEffects(eVis, eDam1);
    effect eLink2 = EffectLinkEffects(eVis, eDam2);

   //Check for Touch and Apply the Effects
   if(TouchAttackMelee(oTarget,TRUE)>0)
    {
       if(!GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
        {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(iDur));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
        }
       else
        {
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds(iDur));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
        }

    }

}

