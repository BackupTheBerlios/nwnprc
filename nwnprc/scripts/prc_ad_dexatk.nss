#include "prc_inc_clsfunc"
void main()
{
object oPC = OBJECT_SELF;
object oWeapon = GetLocalObject(oPC, "CHOSEN_WEAPON");
int iType = GetBaseItemType(oWeapon);


    //1d2
    if(iType == BASE_ITEM_WHIP)
    {
    effect eAttackIncrease = EffectAttackIncrease(1,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);
    }

    //1d4
    if(iType == BASE_ITEM_DAGGER || BASE_ITEM_LIGHTHAMMER || BASE_ITEM_KUKRI
    || BASE_ITEM_SLING )
    {
     effect eAttackIncrease = EffectAttackIncrease(3,ATTACK_BONUS_MISC);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);

    }

    //1d6
    if (iType == BASE_ITEM_CLUB || BASE_ITEM_HANDAXE || BASE_ITEM_KAMA || BASE_ITEM_SHORTSWORD
    || BASE_ITEM_LIGHTMACE || BASE_ITEM_MAGICSTAFF ||  BASE_ITEM_QUARTERSTAFF || BASE_ITEM_RAPIER || BASE_ITEM_SCIMITAR
    || BASE_ITEM_SICKLE )
    {
    effect eAttackIncrease = EffectAttackIncrease(5,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);
    }

     //1d8
     if (iType == BASE_ITEM_BATTLEAXE || BASE_ITEM_LONGSWORD || BASE_ITEM_LIGHTFLAIL
     ||BASE_ITEM_WARHAMMER || BASE_ITEM_TWOBLADEDSWORD || BASE_ITEM_DIREMACE || BASE_ITEM_DOUBLEAXE
    || BASE_ITEM_MORNINGSTAR || BASE_ITEM_SHORTSPEAR )
    {
    effect eAttackIncrease = EffectAttackIncrease(7,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);

    }

     //1d10
    if(iType == BASE_ITEM_BASTARDSWORD ||  BASE_ITEM_HALBERD || BASE_ITEM_HEAVYFLAIL
    || BASE_ITEM_DWARVENWARAXE)
    {
     effect eAttackIncrease = EffectAttackIncrease(9,ATTACK_BONUS_MISC);
     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);
    }

    //1d12
    if(iType ==  BASE_ITEM_GREATAXE)
    {
    effect eAttackIncrease = EffectAttackIncrease(11,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);

    }

    //2d4
    if(iType == BASE_ITEM_SCYTHE)
    {
    effect eAttackIncrease = EffectAttackIncrease(7,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);

    }

    //2d6
    if(iType == BASE_ITEM_GREATSWORD)
    {
    effect eAttackIncrease = EffectAttackIncrease(11,ATTACK_BONUS_MISC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttackIncrease, oPC, 0.0);

    }
    FloatingTextStringOnCreature("Dexterous Attack Mode Activated", oPC, FALSE);
    DelayCommand(6.0, CheckCombatDexAttack(oPC));

}
