#include "prc_class_const"

void main()
{

    int iGoldCost = (15*GetLevelByClass(CLASS_TYPE_RUNESCARRED,OBJECT_SELF));
    int iXPCost = (iGoldCost/25);
    effect eDam = EffectDamage(d6(3),DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);

    // Remove some gold from the player
    TakeGoldFromCreature(iGoldCost, GetPCSpeaker(), TRUE);

    // Remove some xp from the player
    GiveXPToCreature(GetPCSpeaker(), -iXPCost);

    //Apply damage from scribing rune
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,OBJECT_SELF);
}
