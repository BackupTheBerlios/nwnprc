/*
  Echo of the Edge
  prc_iaijutsu_edg
  works for 1 attack only
*/

#include "NW_I0_GENERIC"
#include "prc_feat_const"
#include "prc_inc_combat"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int iMod = 0;

    int iCriticalMultiplier = GetWeaponCritcalMultiplier(oPC, oWeap);
    struct BonusDamage sWeaponBonusDamage = GetWeaponBonusDamage(oWeap, oTarget);
    struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oPC);
    int iWeapDamage = GetWeaponDamagePerRound(oTarget, oPC, oWeap, 0);
    int iAttackBonus = GetAttackBonus(oTarget, oPC, oWeap, 0);
    int iWeapEnch = GetDamagePowerConstant(oWeap, oTarget, oPC);
    int iReturn = GetAttackRoll(oTarget, oPC, oWeap, 0, iAttackBonus, 0, TRUE, 0.0);

    

    if(iReturn == 2)
    {
       	effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, TRUE, 0, 0, iCriticalMultiplier);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
	ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
	FloatingTextStringOnCreature("Critical Echoes of the Edge",OBJECT_SELF);
        ActionAttack(oTarget);
    }
    
    if(iReturn == 1)
    {
       effect eDamage = GetAttackDamage(oTarget, oPC, oWeap, sWeaponBonusDamage, sSpellBonusDamage, 0, iWeapDamage, FALSE, 0, 0, iCriticalMultiplier);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
       FloatingTextStringOnCreature("Echoes of the Edge",OBJECT_SELF);
       ActionAttack(oTarget);
    }
}
