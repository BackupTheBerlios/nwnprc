//#include "prc_spell_const"
//#include "inc_combat2"
#include "nw_i0_spells"
//#include "x2_i0_spells"
#include "inc_addragebonus"

int BonusAtk(int iDmg)
{
  switch (iDmg)
  {
    case 1:  return DAMAGE_BONUS_1;
    case 2:  return DAMAGE_BONUS_2;
    case 3:  return DAMAGE_BONUS_3;
    case 4:  return DAMAGE_BONUS_4;
    case 5:  return DAMAGE_BONUS_5;
    case 6:  return DAMAGE_BONUS_6;
    case 7:  return DAMAGE_BONUS_7;
    case 8:  return DAMAGE_BONUS_8;
    case 9:  return DAMAGE_BONUS_9;
    case 10:  return DAMAGE_BONUS_10;
    case 11:  return DAMAGE_BONUS_11;
    case 12:  return DAMAGE_BONUS_12;
    case 13:  return DAMAGE_BONUS_13;
    case 14:  return DAMAGE_BONUS_14;
    case 15:  return DAMAGE_BONUS_15;
    case 16:  return DAMAGE_BONUS_16;
    case 17:  return DAMAGE_BONUS_17;
    case 18:  return DAMAGE_BONUS_18;
    case 19:  return DAMAGE_BONUS_19;
    case 20:  return DAMAGE_BONUS_20;
 }
    if (iDmg>20) return DAMAGE_BONUS_20;

  return 0;
}

void EnforceActionMode()
{
   if(GetHasSpellEffect(GetSpellId(), OBJECT_SELF))
   {
       SetActionMode(OBJECT_SELF,ACTION_MODE_POWER_ATTACK,FALSE);
       SetActionMode(OBJECT_SELF,ACTION_MODE_IMPROVED_POWER_ATTACK,FALSE);
       
       DelayCommand(3.0, EnforceActionMode());
   }
}

void main()
{

   if(!GetHasFeat(FEAT_POWER_ATTACK))
   {
      FloatingTextStringOnCreature("Prereq: Power Attack feat ", OBJECT_SELF, FALSE);
      return;
   }

   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);


   if(GetWeaponRanged(oWeap) ) return;

   effect eDamage;
   effect eToHit;

   int nSpell = GetSpellId();

   if (GetHasFeatEffect(FEAT_SUPREME_POWER_ATTACK)) return;

   if ( nSpell>SPELL_POWER_ATTACK5 && !GetHasFeat(FEAT_IMPROVED_POWER_ATTACK))
   {
      FloatingTextStringOnCreature("Prereq: Improved Power Attack feat ", OBJECT_SELF, FALSE);
      return;
   }

   int iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK1,OBJECT_SELF)  ? SPELL_POWER_ATTACK1 : 0;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK2,OBJECT_SELF)  ? SPELL_POWER_ATTACK2 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK3,OBJECT_SELF)  ? SPELL_POWER_ATTACK3 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK4,OBJECT_SELF)  ? SPELL_POWER_ATTACK4 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK5,OBJECT_SELF)  ? SPELL_POWER_ATTACK5 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK6,OBJECT_SELF)  ? SPELL_POWER_ATTACK6 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK7,OBJECT_SELF)  ? SPELL_POWER_ATTACK7 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK8,OBJECT_SELF)  ? SPELL_POWER_ATTACK8 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK9,OBJECT_SELF)  ? SPELL_POWER_ATTACK9 : iSpell;
       iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK10,OBJECT_SELF) ? SPELL_POWER_ATTACK10: iSpell;


   if(!iSpell )
   {
      int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
      int iDmg,iHit,iDex;

       if (nSpell == SPELL_POWER_ATTACK1)      {  iHit = 1;}
       else if (nSpell == SPELL_POWER_ATTACK2) {  iHit = 2;}
       else if (nSpell == SPELL_POWER_ATTACK3) {  iHit = 3;}
       else if (nSpell == SPELL_POWER_ATTACK4) {  iHit = 4;}
       else if (nSpell == SPELL_POWER_ATTACK5) {  iHit = 5;}
       else if (nSpell == SPELL_POWER_ATTACK6) {  iHit = 6;}
       else if (nSpell == SPELL_POWER_ATTACK7) {  iHit = 7;}
       else if (nSpell == SPELL_POWER_ATTACK8) {  iHit = 8;}
       else if (nSpell == SPELL_POWER_ATTACK9) {  iHit = 9;}
       else if (nSpell == SPELL_POWER_ATTACK10){  iHit = 10;}

      if(GetHasFeat(FEAT_FOCUSED_STRIKE))
      {
        iDex = GetAbilityModifier(ABILITY_DEXTERITY)>0 ? GetAbilityModifier(ABILITY_DEXTERITY):0 ;
        if (iDex>iHit) iDex=iHit;
        
      }
             
       if (GetHasFeat(FEAT_SUPREME_POWER_ATTACK)) iHit = iHit*2;
       
       iDmg = BonusAtk(iHit+iDex);

       eDamage = EffectDamageIncrease(iDmg, nDamageBonusType);
       eToHit = EffectAttackDecrease(iHit);

       SetActionMode(OBJECT_SELF,ACTION_MODE_POWER_ATTACK,FALSE);
       SetActionMode(OBJECT_SELF,ACTION_MODE_IMPROVED_POWER_ATTACK,FALSE);

       DelayCommand(3.0, EnforceActionMode());

       effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);

       string nMes = "*Power Attack Mode Activated*";
       FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
       if (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER)>1)
       {
         RemoveEffectsFromSpell(OBJECT_SELF,SPELL_UR_FAVORITE_ENEMY); 
         ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY,OBJECT_SELF,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
       }
       
   }
   else
   {
      RemoveSpellEffects(iSpell,OBJECT_SELF,OBJECT_SELF);
      if (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER)>1)
      {
        RemoveEffectsFromSpell(OBJECT_SELF,SPELL_UR_FAVORITE_ENEMY); 
       ActionCastSpellAtObject(SPELL_UR_FAVORITE_ENEMY,OBJECT_SELF,METAMAGIC_ANY,TRUE,0,PROJECTILE_PATH_TYPE_DEFAULT,TRUE);
      }
      string nMes = "*Power Attack Mode Deactivated*";
      FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
   }


}
