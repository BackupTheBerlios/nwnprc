#include "inc_combat2"

void main()
{


    object oTarget = GetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    int iEnhancement = GetWeaponRangeEnhancement(oWeap,OBJECT_SELF);
    int iDamageType = GetWeaponDamageType(oWeap);

    float iDistance = GetDistanceToObject(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iMaxAttacks = (GetBaseAttackBonus(OBJECT_SELF) - 1) / 5 + 1;

        iMaxAttacks = iMaxAttacks > 6 ? 6 : iMaxAttacks;

    int iBonus = 0;
    int iDamage = 0;

    if ( !(iType == BASE_ITEM_LONGBOW || iType ==BASE_ITEM_SHORTBOW ))  return;

    int nId = GetSpellId();

    int iAttacks =2 ;

    if (nId == SPELL_MANYSHOT2) iAttacks = 2;
    else if (nId == SPELL_MANYSHOT3) iAttacks = 3;
    else if (nId == SPELL_MANYSHOT4) iAttacks = 4;
    else if (nId == SPELL_MANYSHOT5) iAttacks = 5;
    else if (nId == SPELL_MANYSHOT6) iAttacks = 6;

    if (iAttacks>iMaxAttacks) iAttacks = iMaxAttacks;

    effect eArrow = EffectVisualEffect(357);

   int i;
   for (i = 0; i < iAttacks; i++)
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

    effect eDamage;

    float fDelay = 0.0;

    //Perform 1 attack

    //Roll to hit
    int iHit = DoRangedAttackS(OBJECT_SELF, oWeap, oTarget, iBonus-iAttacks*2 , TRUE, fDelay);

    int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);


    iAttacks--;
    if(iHit > 0)
    {

      //Check to see if we rolled a critical and determine damage accordingly
      if(iHit == 2 && !Immune)
          iDamage = GetRangedWeaponDamageS(OBJECT_SELF, oWeap, TRUE) + iBonus;
      else
          iDamage = GetRangedWeaponDamageS(OBJECT_SELF, oWeap, FALSE)+ iBonus;

      //Apply the damage
      eDamage = AddDmgEffectMulti(iDamage,DAMAGE_TYPE_PIERCING, GetItemInSlot(INVENTORY_SLOT_ARROWS,OBJECT_SELF),oTarget,iEnhancement,iHit);

//      eDamage = AddDmgEffect(EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, iEnhancement) ,  GetItemInSlot(INVENTORY_SLOT_ARROWS,OBJECT_SELF),oTarget,iEnhancement);
      DelayCommand(fDelay +2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

      while (iAttacks)
      {
        iDamage = GetRangedWeaponDamageS(OBJECT_SELF, oWeap, FALSE);
        iAttacks--;
        fDelay+=0.3;
        //Apply the damage
        eDamage = AddDmgEffectMulti(iDamage,DAMAGE_TYPE_PIERCING, GetItemInSlot(INVENTORY_SLOT_ARROWS,OBJECT_SELF),oTarget,iEnhancement,0);

//        eDamage = AddDmgEffect(EffectDamage(iDamage, DAMAGE_TYPE_PIERCING, iEnhancement) ,  GetItemInSlot(INVENTORY_SLOT_ARROWS,OBJECT_SELF),oTarget,iEnhancement);
        DelayCommand(fDelay + 1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));

      }


   }


}

