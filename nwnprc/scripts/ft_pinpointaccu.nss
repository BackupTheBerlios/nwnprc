#include "prc_spell_const"
#include "inc_combat2"

void main()
{
   int nSpellId = GetSpellId();
   object oTarget = GetSpellTargetObject();
   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
   int iEnhancement = GetWeaponEnhancement(oWeap);
   int iDamageType = GetWeaponDamageType(oWeap);
   int iBonusA = 2;
   int iDamage =0;

   if (!GetWeaponRanged(oWeap)) return;

   effect eArrow = EffectVisualEffect(357);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
//   SendMessageToPC(OBJECT_SELF,"GetSpellId"+IntToString(nSpellId));

   if (nSpellId == SPELL_PINPOINTACCURACY4) iBonusA = 2;
   else if (nSpellId == SPELL_PINPOINTACCURACY6) iBonusA = 6;

   int Attack  = NbAtk(OBJECT_SELF);
       Attack += GetHasSpellEffect(SPELL_EXTRASHOT);

   int iBonusD = GetHasFeat(FEAT_PERFECTSHOT) ? d4(Attack):0;

   effect eDamage;

   float fDelay = 0.0;

   //Perform 1 attack

   //Roll to hit
   int iHit = DoRangedAttackS(OBJECT_SELF, oWeap, oTarget, iBonusA , TRUE, fDelay);

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);

   if(iHit > 0)
   {

      //Check to see if we rolled a critical and determine damage accordingly
      if(iHit == 2 && !Immune)
          iDamage = GetRangedWeaponDamageS(OBJECT_SELF, oWeap, TRUE,0,GetHasFeat(FEAT_KILLINGSHOT) ? 2:0) + iBonusD;
      else
          iDamage = GetRangedWeaponDamageS(OBJECT_SELF, oWeap, FALSE)+ iBonusD;

      //Apply the damage
      eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, iEnhancement) ,  GetWeaponAmmu(oWeap,OBJECT_SELF),oTarget,iEnhancement);
      DelayCommand(fDelay +2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
   }


}
