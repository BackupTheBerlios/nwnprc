//#include "x2_inc_switches"
#include "prc_alterations"
#include "prc_ipfeat_const"
#include "prc_getcast_lvl"
#include "inc_item_props"



const int IPRP_CONST_ONHIT_DURATION_5_PERCENT_1_ROUNDS = 20;

int Sanctify_Feat(int iTypeWeap)
{
       switch(iTypeWeap)
            {
                case BASE_ITEM_BASTARDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BASTARDSWORD);
                case BASE_ITEM_BATTLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_BATTLEAXE);
                case BASE_ITEM_CLUB: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_CLUB);
                case BASE_ITEM_DAGGER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DAGGER);
                case BASE_ITEM_DART: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DART);
                case BASE_ITEM_DIREMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DIREMACE);
                case BASE_ITEM_DOUBLEAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DOUBLEAXE);
                case BASE_ITEM_DWARVENWARAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_DWAXE);
                case BASE_ITEM_GREATAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATAXE);
                case BASE_ITEM_GREATSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_GREATSWORD);
                case BASE_ITEM_HALBERD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HALBERD);
                case BASE_ITEM_HANDAXE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HANDAXE);
                case BASE_ITEM_HEAVYCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYCROSSBOW);
                case BASE_ITEM_HEAVYFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_HEAVYFLAIL);
                case BASE_ITEM_KAMA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KAMA);
                case BASE_ITEM_KATANA: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KATANA);
                case BASE_ITEM_KUKRI: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_KUKRI);
                case BASE_ITEM_LIGHTCROSSBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTCROSSBOW);
                case BASE_ITEM_LIGHTFLAIL: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTFLAIL);
                case BASE_ITEM_LIGHTHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LIGHTHAMMER);
                case BASE_ITEM_LIGHTMACE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MACE);
                case BASE_ITEM_LONGBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGBOW);
                case BASE_ITEM_LONGSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_LONGSWORD);
                case BASE_ITEM_MORNINGSTAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_MORNINGSTAR);
                case BASE_ITEM_QUARTERSTAFF: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_QUATERSTAFF);
                case BASE_ITEM_RAPIER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_RAPIER);
                case BASE_ITEM_SCIMITAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCIMITAR);
                case BASE_ITEM_SCYTHE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SCYTHE);
                case BASE_ITEM_SHORTBOW: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTBOW);
                case BASE_ITEM_SHORTSPEAR: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SPEAR);
                case BASE_ITEM_SHORTSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHORTSWORD);
                case BASE_ITEM_SHURIKEN: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SHURIKEN);
                case BASE_ITEM_SLING: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
                case BASE_ITEM_SICKLE: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SICKLE);
                case BASE_ITEM_TWOBLADEDSWORD: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_TWOBLADED);
                case BASE_ITEM_WARHAMMER: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_WARHAMMER);
                case BASE_ITEM_WHIP: return GetHasFeat(FEAT_SANCTIFY_MARTIAL_SLING);
            }
    return 0;
}

int Add_SneakAtk(int nD6)
{
  int Iprp_Feat;

   if (nD6>20) nD6=20;

   if (nD6<6)
   {
      switch (nD6)
      {
        case 1:
          Iprp_Feat = 32;
          break;
        case 2:
          Iprp_Feat = 33;
          break;
        case 3:
          Iprp_Feat = 34;
          break;
        case 4:
          Iprp_Feat = IP_CONST_FEAT_SNEAKATK4;
          break;
        case 5:
          Iprp_Feat = 39;
          break;
      }
   }
   else
     Iprp_Feat = IP_CONST_FEAT_SNEAKATK4+nD6-5;

   return  Iprp_Feat;
}




int DamageConv(int iMonsDmg)
{

   switch(iMonsDmg)
   {
     case IP_CONST_MONSTERDAMAGE_1d4:  return 1;
     case IP_CONST_MONSTERDAMAGE_1d6:  return 2;
     case IP_CONST_MONSTERDAMAGE_1d8:  return 3;
     case IP_CONST_MONSTERDAMAGE_1d10: return 4;
     case IP_CONST_MONSTERDAMAGE_1d12: return 5;
     case IP_CONST_MONSTERDAMAGE_1d20: return 6;

     case IP_CONST_MONSTERDAMAGE_2d4:  return 10;
     case IP_CONST_MONSTERDAMAGE_2d6:  return 11;
     case IP_CONST_MONSTERDAMAGE_2d8:  return 12;
     case IP_CONST_MONSTERDAMAGE_2d10: return 13;
     case IP_CONST_MONSTERDAMAGE_2d12: return 14;
     case IP_CONST_MONSTERDAMAGE_2d20: return 15;

     case IP_CONST_MONSTERDAMAGE_3d4:  return 20;
     case IP_CONST_MONSTERDAMAGE_3d6:  return 21;
     case IP_CONST_MONSTERDAMAGE_3d8:  return 22;
     case IP_CONST_MONSTERDAMAGE_3d10: return 23;
     case IP_CONST_MONSTERDAMAGE_3d12: return 24;
     case IP_CONST_MONSTERDAMAGE_3d20: return 25;


   }


  return 0;
}

int ConvMonsterDmg(int iMonsDmg)
{

   switch(iMonsDmg)
   {
     case 1:  return IP_CONST_MONSTERDAMAGE_1d4;
     case 2:  return IP_CONST_MONSTERDAMAGE_1d6;
     case 3:  return IP_CONST_MONSTERDAMAGE_1d8;
     case 4:  return IP_CONST_MONSTERDAMAGE_1d10;
     case 5:  return IP_CONST_MONSTERDAMAGE_1d12;
     case 6:  return IP_CONST_MONSTERDAMAGE_1d20;
     case 10: return IP_CONST_MONSTERDAMAGE_2d4;
     case 11: return IP_CONST_MONSTERDAMAGE_2d6;
     case 12: return IP_CONST_MONSTERDAMAGE_2d8;
     case 13: return IP_CONST_MONSTERDAMAGE_2d10;
     case 14: return IP_CONST_MONSTERDAMAGE_2d12;
     case 15: return IP_CONST_MONSTERDAMAGE_2d20;
     case 20: return IP_CONST_MONSTERDAMAGE_3d4;
     case 21: return IP_CONST_MONSTERDAMAGE_3d6;
     case 22: return IP_CONST_MONSTERDAMAGE_3d8;
     case 23: return IP_CONST_MONSTERDAMAGE_3d10;
     case 24: return IP_CONST_MONSTERDAMAGE_3d12;
     case 25: return IP_CONST_MONSTERDAMAGE_3d20;

   }

   return 0;
}

int MonsterDamage(object oItem)
{
   int iBonus;
   int iTemp ;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MONSTER_DAMAGE)
        {
          iTemp= GetItemPropertyCostTableValue(ip);
          iBonus = iTemp > iBonus ? iTemp : iBonus ;
        }
        ip = GetNextItemProperty(oItem);
    }

   return iBonus;
}

int FeatIniDmg(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    { 
	if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT)
        {

          if (GetItemPropertySubType(ip)==IP_CONST_FEAT_WeapFocCreature) return 1;
        }
	ip = GetNextItemProperty(oItem);
    }
    return 0;
}
	

void AddIniDmg(object oPC)
{

   int bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE1,oPC) ? 1:0;
       bUnarmedDmg = GetHasFeat(FEAT_INCREASE_DAMAGE2,oPC) ? 2:bUnarmedDmg;

   if (!bUnarmedDmg) return;

   object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
   object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
   object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);

   int iDmg;
   int iConv;
   int iStr =  GetAbilityModifier(ABILITY_STRENGTH,oPC);
   int iWis =  GetAbilityModifier(ABILITY_WISDOM,oPC);
       iWis = iWis > iStr ? iWis : 0;


   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
   {
     SetCompositeBonusT(oCweapB,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonusT(oCweapL,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
     SetCompositeBonusT(oCweapR,"",iWis,ITEM_PROPERTY_ATTACK_BONUS);
   }
   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL,9999.0);
     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR,9999.0);
   }

   
   if ( oCweapB != OBJECT_INVALID && !FeatIniDmg(oCweapB))
   {
      iDmg =  MonsterDamage(oCweapB);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapB,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapB);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapB);

   }
   if ( oCweapL != OBJECT_INVALID && !FeatIniDmg(oCweapL))
   {
      iDmg =  MonsterDamage(oCweapL);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapL,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapL);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapL);

   }
   if ( oCweapR != OBJECT_INVALID && !FeatIniDmg(oCweapR))
   {
      iDmg =  MonsterDamage(oCweapR);
      iConv = DamageConv(iDmg);
      iConv = ConvMonsterDmg(iConv+bUnarmedDmg);
      TotalAndRemoveProperty(oCweapR,ITEM_PROPERTY_MONSTER_DAMAGE,-1);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(iConv),oCweapR);
      AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_WeapFocCreature),oCweapR);

   }



}




void AddCriti(object oPC,object oSkin,int ip_feat_crit,int nFeat)
{
  //if (GetLocalInt(oSkin, "ManAcriT"+IntToString(ip_feat_crit))) return;
    if (GetHasFeat(nFeat,oPC))return;
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(ip_feat_crit),oSkin);


}

void ImpCrit(object oPC,object oSkin)
{
  if (GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD,FEAT_IMPROVED_CRITICAL_BASTARD_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE,FEAT_IMPROVED_CRITICAL_BATTLE_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_CLUB,FEAT_IMPROVED_CRITICAL_CLUB);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER,FEAT_IMPROVED_CRITICAL_DAGGER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DART,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DART,FEAT_IMPROVED_CRITICAL_DART);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DIRE_MACE,FEAT_IMPROVED_CRITICAL_DIRE_MACE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE,FEAT_IMPROVED_CRITICAL_DOUBLE_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE,FEAT_IMPROVED_CRITICAL_DWAXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE,FEAT_IMPROVED_CRITICAL_GREAT_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD,FEAT_IMPROVED_CRITICAL_GREAT_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD,FEAT_IMPROVED_CRITICAL_HALBERD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE,FEAT_IMPROVED_CRITICAL_HAND_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW,FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL,FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KAMA,FEAT_IMPROVED_CRITICAL_KAMA);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA,FEAT_IMPROVED_CRITICAL_KATANA);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI,FEAT_IMPROVED_CRITICAL_KUKRI);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW,FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL,FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER,FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_MACE,FEAT_IMPROVED_CRITICAL_LIGHT_MACE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD,FEAT_IMPROVED_CRITICAL_LONG_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW,FEAT_IMPROVED_CRITICAL_LONGBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR,FEAT_IMPROVED_CRITICAL_MORNING_STAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER,FEAT_IMPROVED_CRITICAL_RAPIER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR,FEAT_IMPROVED_CRITICAL_SCIMITAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE,FEAT_IMPROVED_CRITICAL_SCYTHE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD,FEAT_IMPROVED_CRITICAL_SHORT_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW,FEAT_IMPROVED_CRITICAL_SHORTBOW);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN,FEAT_IMPROVED_CRITICAL_SHURIKEN);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE,FEAT_IMPROVED_CRITICAL_SICKLE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SLING,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SLING,FEAT_IMPROVED_CRITICAL_SLING);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR,FEAT_IMPROVED_CRITICAL_SPEAR);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_STAFF,FEAT_IMPROVED_CRITICAL_STAFF);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE,FEAT_IMPROVED_CRITICAL_THROWING_AXE);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD,FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_WAR_HAMMER,FEAT_IMPROVED_CRITICAL_WAR_HAMMER);
  if (GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,oPC)) AddCriti(oPC,oSkin,IP_CONST_FEAT_IMPROVED_CRITICAL_WHIP,FEAT_IMPROVED_CRITICAL_WHIP);

}

void FeatUsePerDay(object oPC,int iFeat, int iAbiMod = ABILITY_CHARISMA, int iMod = 0)
{

    if (!GetHasFeat(iFeat,oPC)) return;

    int iAbi= GetAbilityModifier(iAbiMod,oPC)>0 ? GetAbilityModifier(iAbiMod,oPC):0 ;
        if ( iAbiMod == -1) iAbi =0;
        iAbi+=iMod;
        iAbi = (iAbi >85) ? 85 :iAbi;



    int iLeftUse = 0;
    while (GetHasFeat(iFeat,oPC))
    {
      DecrementRemainingFeatUses(oPC,iFeat);
      iLeftUse++;
    }

    if (!iAbi) return;

    iLeftUse = (iLeftUse>88) ? iAbi : iLeftUse;

    while (iLeftUse)
    {
      IncrementRemainingFeatUses(oPC,iFeat);
      iLeftUse--;
    }

}

void SpellSol(object oPC)
{

   int Sol = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,oPC);
   int iWis = GetAbilityScore(oPC,ABILITY_WISDOM);
   if (Sol>10) Sol=10;
   
   if (!Sol) return ;

   int iLvl1 = (Sol+3)/5 + (iWis<12 ? 0 :(iWis-4)/8) ;
   int iLvl2 = (Sol+1)/5 + (iWis<14 ? 0 :(iWis-6)/8) ;
   int iLvl3 = (Sol-1)/5 + (iWis<16 ? 0 :(iWis-8)/8) ;
   int iLvl4 = (Sol-3)/5 + (iWis<18 ? 0 :(iWis-10)/8) ;
   
   FeatUsePerDay(oPC,FEAT_SPELLLVL1,-1,iLvl1);
   FeatUsePerDay(oPC,FEAT_SPELLLVL2,-1,iLvl2);
   FeatUsePerDay(oPC,FEAT_SPELLLVL3,-1,iLvl3);
   FeatUsePerDay(oPC,FEAT_SPELLLVL4,-1,iLvl4);

}

void SpellShadow(object oPC)
{

   int Sha = GetLevelByClass(CLASS_TYPE_SHADOWLORD,oPC);
   int iInt = GetAbilityScore(oPC,ABILITY_INTELLIGENCE);
   
   if (!Sha) return ;

   int iLvl1 = (Sha/2) + (iInt<12 ? 0 :(iInt-4)/8) ;
   int iLvl2 = (Sha-2)/2 + (iInt<14 ? 0 :(iInt-6)/8) ;
   int iLvl3 = (Sha-5)   + (iInt<16 ? 0 :(iInt-8)/8) ;
   
   if (Sha == 6) iLvl1--;

   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV01,-1,iLvl1);
   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV21,-1,iLvl2);
   FeatUsePerDay(oPC,FEAT_SHADOWSPELLLV31,-1,iLvl3);

}

void SpellKotMC(object oPC)
{

   int KotMC = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE,oPC);
   int iWis = GetAbilityScore(oPC,ABILITY_WISDOM);
   
   if (!KotMC) return;

   int iLvl1 = (KotMC+2)/5 + (iWis<12 ? 0 :(iWis-4)/8) ;
   int iLvl2 = (KotMC-2)/5 + (iWis<14 ? 0 :(iWis-6)/8) ;
   int iLvl3 = (KotMC-4)/5 + (iWis<16 ? 0 :(iWis-8)/8) ;
   
   FeatUsePerDay(oPC,FEAT_KOTMC_SL_1,-1,iLvl1);
   FeatUsePerDay(oPC,FEAT_KOTMC_SL_2,-1,iLvl2);
   FeatUsePerDay(oPC,FEAT_KOTMC_SL_3,-1,iLvl3);
}

void FeatSpecialUsePerDay(object oPC)
{
    FeatUsePerDay(oPC,FEAT_FIST_OF_IRON, ABILITY_WISDOM, 3);
    FeatUsePerDay(oPC,FEAT_SMITE_UNDEAD, ABILITY_CHARISMA, 3);
    SpellSol(oPC);  
    SpellKotMC(oPC);
    SpellShadow(oPC);
    FeatUsePerDay(oPC,FEAT_SA_SHIELDSHADOW,-1,GetCasterLvl(TYPE_ARCANE,oPC));

}

int CanCastSpell(int iSpelllvl = 0,int iAbi = ABILITY_WISDOM,int iASF = 0,object oCaster=OBJECT_SELF)
{
   string iMsg =" You cant cast your spell because your ability score is too low";
   int iScore = GetAbilityScore(oCaster,iAbi); 
   if (iScore < 10 + iSpelllvl)
   {
       FloatingTextStringOnCreature(iMsg, oCaster, FALSE);
       return 0;
   }  
   if (iASF)
   {
     int ASF = GetArcaneSpellFailure(oCaster); 
     int idice = d100(1);
     if (idice <= ASF && idice!=100)
     {
        FloatingTextStringOnCreature("Spell failed due to arcane spell failure (roll:"+IntToString(idice)+")", oCaster, FALSE);
        return 0; 
     }
      
   }
   
   return 1;     
}

