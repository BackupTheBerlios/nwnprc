#include "inc_combat"
#include "x2_inc_itemprop"
#include "X0_I0_SPELLS"

#include "inc_combat2"
#include "prc_inc_clsfunc"

const int FEAT_AP_SMITEGOOD1 = 3459;

void NoSmite(object oTarget ,string sText ,int iGood)
{

   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

   // no smite with ranged Weapon
   int iType=GetBaseItemType(oWeap);
   switch (iType)
   {
    case BASE_ITEM_BOLT:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_ARROW:
    case BASE_ITEM_SHORTBOW:
    case BASE_ITEM_LONGBOW:
    case BASE_ITEM_LIGHTCROSSBOW:
    case BASE_ITEM_HEAVYCROSSBOW:
    case BASE_ITEM_SLING:
       return;
       break;
   }
   
   int iNextAttackPenalty = 0;
   float fDelay = 0.0f;
   int iAttacks=NbAtk(OBJECT_SELF);
   int iDamage = 0;
   effect eDamage;

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);
   int iEnhancement = GetWeaponEnhancement(oWeap);
   int iDamageType = GetWeaponDamageType(oWeap);

   FloatingTextStringOnCreature(sText,OBJECT_SELF);

//   int SancMar  = Sanctify_Feat(GetBaseItemType(oWeap)) && iGood ? 1 :0 ;
  int Unholy   = GetHasFeat(FEAT_UNHOLY_STRIKE)   ? 1:0 ;
  int iEnhancementGD = (Unholy && iGood) ? DAMAGE_POWER_ENERGY : iEnhancement;

  for(iAttacks; iAttacks > 0; iAttacks--)
  {
    //Roll to hit  for Smite  Bonus CHA(1st atk) +Attack penalty +Weap Atk Bonus
    int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget,  iNextAttackPenalty, TRUE, fDelay);
 
    if(iHit > 0)
    {

       if (Immune && iHit==2) iHit=1;

        //Check to see if we rolled a critical and determine damage accordingly
       
        if(iHit == 2 )
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, TRUE);
        else
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, FALSE);

        //Apply the damage
        eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancement,iHit);        
        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, oTarget));
    }
    iNextAttackPenalty -= 5;
    fDelay += 1.0;


  }



}
void main()
{
  
   // take lvl for Speed
   int iFeat;
   int nClass = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN);
   if (nClass>19) iFeat = FEAT_AP_SMITEGOOD1+3;
   else if (nClass>9) iFeat = FEAT_AP_SMITEGOOD1+2;
   else if (nClass>4) iFeat = FEAT_AP_SMITEGOOD1+1;
   else if (nClass>0) iFeat = FEAT_AP_SMITEGOOD1;
   
   if (GetHasFeat(FEAT_SMITE_GOOD))
   {
        DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_GOOD);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
   }
   
   object oTarget=GetSpellTargetObject();
   
   ActionAttack(oTarget,TRUE);


   if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_GOOD)
   {
     NoSmite(oTarget,"Smite Failed : not Good",0);
     return;
   }// Paladin/Fist Raziel need a Loyal Good Alignment
   else if (GetAlignmentGoodEvil(OBJECT_SELF)!=ALIGNMENT_EVIL )
   {
     NoSmite(oTarget,"Smite Failed : you're  not Evil",1);
     return;
   }

   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

   int iNextAttackPenalty = 0;
   float fDelay = 0.0f;

   int iAttacks=NbAtk(OBJECT_SELF);

   int iDamage = 0;
   effect eDamage,eDamage2;
   effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

   int iEnhancement = GetWeaponEnhancement(oWeap);
   int iDamageType = GetWeaponDamageType(oWeap);
   int iGood  =1 ;
   
   int iSmit=iGood;
   int iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_1) ? 2:1;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_2) ? 3:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_3) ? 4:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_4) ? 5:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_5) ? 6:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_6) ? 7:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_7) ? 8:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_8) ? 9:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_9) ? 10:iEpicSmite;
       iEpicSmite = GetHasFeat(FEAT_EPIC_GREAT_SMITING_10)? 11:iEpicSmite;

   int iDmgBon =  (GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)+GetLevelByClass(CLASS_TYPE_PALADIN)+GetLevelByClass(CLASS_TYPE_BLACKGUARD)+GetLevelByClass(CLASS_TYPE_CHAMPION_BANE))* iEpicSmite ;
   int iBonus = GetAbilityModifier(ABILITY_CHARISMA)>0 ? GetAbilityModifier(ABILITY_CHARISMA):0;

   // no smite with ranged Weapon except the character has Ranged Smite Feat
   
   int iType=GetBaseItemType(oWeap);
   switch (iType)
   {
      case BASE_ITEM_SHORTBOW:
      case BASE_ITEM_LONGBOW:
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
      case BASE_ITEM_SLING:
         return ;
   }

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);

   //Perform a full round of attacks
  for(iAttacks; iAttacks > 0; iAttacks--)
  {
    //Roll to hit  for Smite  Bonus CHA(1st atk) +Attack penalty +Weap Atk Bonus
    int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget, iBonus + iNextAttackPenalty, TRUE, fDelay);


    // SancMar +1d4 vs Evil
   // int SancMar   = Sanctify_Feat(GetBaseItemType(oWeap))   ? 1:0 ;
//    int iHolyDmg  = (iSmit && (LvlRaziel>4)) || (LvlRaziel>9) ? d6(2):SancMar ;
//        iHolyDmg  = iHolyDmg && (LvlRaziel>6) && iOuts  && iSmit   ? d8(2):iHolyDmg;

    int Unholy   = GetHasFeat(FEAT_UNHOLY_STRIKE)   ? 1:0 ;
    int iEnhancementGD = (Unholy) ? DAMAGE_POWER_ENERGY : iEnhancement;
    
    if(iHit > 0)
    {

       if ( iSmit)   PlaySound("vs_npaladm1_bat2");
       if (Immune && iHit==2) iHit=1;

        //Check to see if we rolled a critical and determine damage accordingly
        // Dmg Bonus= Level Paladin+ Fist Raziel

        if(iHit == 2 )
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, TRUE,iDmgBon);
        else
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, FALSE,iDmgBon);

        //Apply the damage
        if (iSmit)
           eDamage = AddDmgEffectMulti(iDamage,DAMAGE_TYPE_DIVINE, oWeap,oTarget,DAMAGE_POWER_ENERGY,iHit);
//         eDamage = AddDmgEffect(EffectDamage(iDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY) ,oWeap,oTarget,DAMAGE_POWER_ENERGY);
        else
           eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancementGD,iHit);
//         eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, iEnhancementGD) ,oWeap,oTarget,iEnhancementGD);

        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eDamage,eVis), oTarget));


    }
    else
    {
       if ( iSmit)   FloatingTextStringOnCreature("Smite Failed",OBJECT_SELF);
    }



    iSmit=0;
    iNextAttackPenalty -= 5;
    fDelay += 1.0;
    iDmgBon=0;


  }
}
