#include "inc_combat"
#include "x2_inc_itemprop"
#include "prc_inc_clsfunc"
#include "inc_combat2"


void NoSmite(object oTarget ,string sText ,int iEvil)
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

   int SancMar  = Sanctify_Feat(GetBaseItemType(oWeap)) && iEvil ? 1 :0 ;

  for(iAttacks; iAttacks > 0; iAttacks--)
  {
    //Roll to hit  for Smite  Bonus CHA(1st atk) +Attack penalty +Weap Atk Bonus
    int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget,  iNextAttackPenalty, TRUE, fDelay);


    if(iHit > 0)
    {

       if (Immune && iHit==2) iHit=1;

        //Check to see if we rolled a critical and determine damage accordingly
        // Dmg Bonus= Level Paladin+ Fist Raziel

        if(iHit == 2 )
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, TRUE);
        else
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, FALSE);

        //Apply the damage
        //Apply the damage
        if (SancMar)
           eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,DAMAGE_POWER_ENERGY,iHit);
//         eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, DAMAGE_POWER_ENERGY) ,oWeap,oTarget,iEnhancement);
        else
           eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancement,iHit);
//          eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, iEnhancement) ,oWeap,oTarget,iEnhancement);

        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, oTarget));


    }
    iNextAttackPenalty -= 5;
    fDelay += 1.0;


  }



}
void main()
{

/*
   int iCha = GetAbilityModifier(ABILITY_CHARISMA)>0 ? GetAbilityModifier(ABILITY_CHARISMA):0 ;
        iCha+=2;
        iCha = (iCha >35) ? 35 :iCha;

    if (!iCha) return;

    int iLeftUse = 0;
    while (GetHasFeat(FEAT_SMITE_UNDEAD,OBJECT_SELF))
    {
      DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_UNDEAD);
      iLeftUse++;
    }

    iLeftUse = (iLeftUse>38) ? iCha : iLeftUse;

    while (iLeftUse)
    {
      IncrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_UNDEAD);
      iLeftUse--;
    }

*/

   object oTarget=GetSpellTargetObject();
   int iEvil = GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL;

    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD )
   {
     NoSmite(oTarget,"Smite Failed : not an Undead",iEvil);
     return;
   }// Paladin/Fist Raziel need a Loyal Good Alignment
   else if (!GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD  )
   {
     NoSmite(oTarget,"Smite Failed : you're  not Good",iEvil);
     return;
   }


   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

   AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyNoDamage(),oWeap,4.0);

//   ActionAttack(oTarget,TRUE);

   int iNextAttackPenalty = 0;
   float fDelay = 0.0f;

   int iAttacks=NbAtk(OBJECT_SELF);

   int iDamage = 0;
   effect eDamage,eDamage2;
   effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

   int iEnhancement = GetWeaponEnhancement(oWeap);
   int iDamageType = GetWeaponDamageType(oWeap);
   int iOuts  =(GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD ||GetRacialType(oTarget)== RACIAL_TYPE_OUTSIDER)  ? 1 :0 ;

   int iSmit=1;
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

   int iDmgBon =  (GetLevelByClass(CLASS_TYPE_FISTRAZIEL)+GetLevelByClass(CLASS_TYPE_PALADIN)+GetLevelByClass(CLASS_TYPE_DIVINECHAMPION)+GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT))* iEpicSmite ;
   int iBonus = GetAbilityModifier(ABILITY_WISDOM)>0 ? GetAbilityModifier(ABILITY_WISDOM):0;

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

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);

   //Perform a full round of attacks
  for(iAttacks; iAttacks > 0; iAttacks--)
  {
    //Roll to hit  for Smite  Bonus CHA(1st atk) +Attack penalty +Weap Atk Bonus
    int iHit = DoMeleeAttack(OBJECT_SELF, oWeap, oTarget, iBonus + iNextAttackPenalty, TRUE, fDelay);


    // SancMar +1d4 vs Evil
    int SancMar   = Sanctify_Feat(GetBaseItemType(oWeap))   ? 1:0 ;
//    int iHolyDmg  = (iSmit && (LvlRaziel>4)) || (LvlRaziel>9) ? d6(2):SancMar ;
//        iHolyDmg  = iHolyDmg && (LvlRaziel>6) && iOuts  && iSmit   ? d8(2):iHolyDmg;

    int iEnhancementGD = (SancMar) ? DAMAGE_POWER_ENERGY : iEnhancement;

    if(iHit > 0)
    {

       if (Immune && iHit==2) iHit=1;

        //Check to see if we rolled a critical and determine damage accordingly
        // Dmg Bonus= Level Paladin+ Fist Raziel

        if(iHit == 2 )
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, TRUE,iDmgBon);
        else
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, FALSE,iDmgBon);

        //Apply the damage
        if (iSmit)
        {
	   eDamage = AddDmgEffectMulti(iDamage,DAMAGE_TYPE_DIVINE, oWeap,oTarget,iEnhancementGD,iHit);
//         eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE, iEnhancementGD);
        }
        else
        {
 	    eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancementGD,iHit);
//          eDamage = EffectDamage(iDamage, iDamageType, iEnhancementGD);

        }

        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eDamage,eVis), oTarget));


    }

    iSmit=0;
    iNextAttackPenalty -= 5;
    fDelay += 1.0;
    iDmgBon=0;


  }
}

