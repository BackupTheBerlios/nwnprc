#include "prc_feat_const"

void main()
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

    if (oWeap!= OBJECT_INVALID) return;


    int iWis = GetAbilityModifier(ABILITY_WISDOM)>0 ? GetAbilityModifier(ABILITY_WISDOM):0 ;
        iWis+=2;
        iWis = (iWis >35) ? 35 :iWis;

    if (!iWis) return;

    int iLeftUse = 0;
    while (GetHasFeat(FEAT_FIST_OF_IRON,OBJECT_SELF))
    {
      DecrementRemainingFeatUses(OBJECT_SELF,FEAT_FIST_OF_IRON);
      iLeftUse++;
    }

    iLeftUse = (iLeftUse>38) ? iWis : iLeftUse;

    while (iLeftUse)
    {
      IncrementRemainingFeatUses(OBJECT_SELF,FEAT_FIST_OF_IRON);
      iLeftUse--;
    }

    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_BLUDGEONING);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eDamage), OBJECT_SELF,RoundsToSeconds(2));



}
