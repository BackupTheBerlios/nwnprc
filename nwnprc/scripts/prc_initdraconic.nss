#include "heartward_inc"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "soul_inc"
#include "inc_item_props"

int FindUnarmedDmg(object oPC,int bUnarmedDmg)
{

  int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);
      iMonk = (iMonk >20) ? 20 :iMonk ;

  int iSize =GetCreatureSize(oPC);


  int iDmg = 0;

  if (iMonk)
  {
    int iLvDmg = iMonk/4+2;

    if (iSize == CREATURE_SIZE_SMALL ||iSize== CREATURE_SIZE_TINY)
      iLvDmg--;

     iDmg =iLvDmg ;


  }

   iDmg+=bUnarmedDmg;

     switch (iDmg)
     {
        case 0:
          return IP_CONST_MONSTERDAMAGE_1d3;
        case 1:
          return IP_CONST_MONSTERDAMAGE_1d4;
        case 2:
          return IP_CONST_MONSTERDAMAGE_1d6;
        case 3:
          return IP_CONST_MONSTERDAMAGE_1d8;
        case 4:
          return IP_CONST_MONSTERDAMAGE_1d10;
        case 5:
          return IP_CONST_MONSTERDAMAGE_2d6;
        case 6:
          return IP_CONST_MONSTERDAMAGE_2d8;
        case 7:
          return IP_CONST_MONSTERDAMAGE_2d10;
        case 8:
          return IP_CONST_MONSTERDAMAGE_3d6;
        case 9:
         return IP_CONST_MONSTERDAMAGE_3d8;
        case 10:
         return IP_CONST_MONSTERDAMAGE_3d10;
      }


  return IP_CONST_MONSTERDAMAGE_1d2;

}

//-1 d2
//0  d3
//1  d4
//2  d6
//3  d8
//4  d10
//5  2d6
//6  2d8
//7  2d10
//8  3d6
//9  3d8
//10 3d10


void ClawDragon(object oPC,int bUnarmedDmg,int Enh,int iEquip)
{

   object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);

//   object oWeapL =  GetItemPossessedBy(oPC,"NW_IT_CREWPB010");
   if ( oWeapL==OBJECT_INVALID )
   {
      object oSlamL=CreateItemOnObject("NW_IT_CREWPB010",oPC);

      SetIdentified(oSlamL,TRUE);
      AssignCommand(oPC,ActionEquipItem(oSlamL,INVENTORY_SLOT_CWEAPON_L));
      oWeapL = oSlamL;
   }


    if (GetTag(oWeapL)!="NW_IT_CREWPB010") return;

      int iDmg =FindUnarmedDmg(oPC,bUnarmedDmg);

      int iMonk = GetLevelByClass(CLASS_TYPE_MONK,oPC);

      int iKi = GetHasFeat(FEAT_KI_STRIKE,oPC) ? 1 : 0 ;
          iKi = (iMonk>12)                     ? 2 : iKi;
          iKi = (iMonk>15)                     ? 3 : iKi;

      int iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4,oPC) ? 1 : 0 ;
          iEpicKi = GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5,oPC) ? 2 : iEpicKi ;

      iKi+= iEpicKi;
      Enh+= iKi;


      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iDmg),oWeapL);

      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_ATTACK_BONUS,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oWeapL);

      TotalAndRemoveProperty(oWeapL,ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING),oWeapL);

return ;



}

void BonusFeat(object oPC,object oSkin)
{

     if (GetHasFeat(FEAT_WEAPON_FOCUS_UNARMED_STRIKE,oPC) && !GetHasFeat(FEAT_WEAPON_FOCUS_CREATURE,oPC))
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oSkin);

     if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_UNARMED_STRIKE,oPC) && !GetHasFeat(FEAT_WEAPON_SPECIALIZATION_CREATURE,oPC))
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapSpecCreature),oSkin);

     if (GetHasFeat(FEAT_IMPROVED_CRITICAL_UNARMED_STRIKE,oPC) && !GetHasFeat(FEAT_IMPROVED_CRITICAL_CREATURE,oPC))
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_ImpCritCreature),oSkin);

     if (GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_UNARMED,oPC) && !GetHasFeat(FEAT_EPIC_WEAPON_FOCUS_CREATURE,oPC))
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicFocCreature),oSkin);

     if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_UNARMED,oPC) && !GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_CREATURE,oPC))
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapEpicSpecCreature),oSkin);


}

void SpellResistancePC(object oPC,object oSkin,int iLevel)
{

    iLevel = (iLevel-10)/2;

    if (iLevel>IP_CONST_SPELLRESISTANCEBONUS_32)
          iLevel=IP_CONST_SPELLRESISTANCEBONUS_32;

    if (GetLocalInt(oSkin,"IniSR")==iLevel) return;
    RemoveSpecificProperty(oSkin,ITEM_PROPERTY_SPELL_RESISTANCE,-1,IP_CONST_ONHIT_SAVEDC_26,GetLocalInt(oSkin,"IniSR"));
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusSpellResistance(iLevel),oSkin);
    SetLocalInt(oSkin,"IniSR",iLevel);
}

void StunStrike(object oPC,object oSkin)
{

    if (GetLocalInt(oSkin,"IniStunStrk")) return;

    object oWeapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
    if (GetTag(oWeapL)!="NW_IT_CREWPB010") return;
    RemoveSpecificProperty(oWeapL,ITEM_PROPERTY_ON_HIT_PROPERTIES,IP_CONST_ONHIT_STUN,IP_CONST_ONHIT_SAVEDC_26,IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN,IP_CONST_ONHIT_SAVEDC_26,IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS),oWeapL);
    SetLocalInt(oSkin,"IniStunStrk",1);

}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

   // NW_IT_CREWPB010


   int bEnh =  GetHasFeat(FEAT_CLAWDRAGON,oPC) ? 1: 0;
       bEnh =  GetHasFeat(FEAT_CLAWENH2,oPC)   ? 2: bEnh;
       bEnh =  GetHasFeat(FEAT_CLAWENH3,oPC)   ? 3: bEnh;

   int bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE1,oPC) ? 1:0;
       bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE2,oPC) ? 2:bUnarmedDmg;


   if (bEnh)ClawDragon(oPC,bUnarmedDmg,bEnh,GetLocalInt(oPC,"ONEQUIP"));

   if (GetHasFeat(FEAT_INIDR_SPELLRESISTANCE,oPC)) SpellResistancePC(oPC,oSkin,GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC,oPC)+15);
   if (GetHasFeat(FEAT_INIDR_STUNSTRIKE,oPC)) StunStrike(oPC,oSkin);


   BonusFeat(oPC,oSkin);

}