#include "inc_combat"
#include "x2_inc_itemprop"
//#include "X0_I0_SPELLS"

#include "inc_combat2"
#include "prc_inc_clsfunc"

void Attack( effect eEffect, object oTarget,location loc)
{
  location lSmiter = GetLocation(OBJECT_SELF);
  if (GetDistanceBetweenLocations(loc,lSmiter)>4.0) return;
  if (GetIsDead(oTarget)) return;
  
  ApplyEffectToObject(DURATION_TYPE_INSTANT,eEffect,oTarget);
}

void SmiteChain(object oTarget,float fDelay)
{
  int nMax=5;
  int nDam;
  location lTarget=GetLocation(oTarget);

   effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

  //Declare the spell shape, size and the location.  Capture the first target object in the shape.
  object oTargets = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
  //Cycle through the targets within the spell shape until an invalid object is captured.
  while (GetIsObjectValid(oTargets) && nMax)
  {
     if (spellsIsTarget(oTargets, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTargets!=oTarget && GetAlignmentGoodEvil(oTargets)==ALIGNMENT_EVIL)
     {
         nDam=(GetRacialType(oTargets)==RACIAL_TYPE_UNDEAD ||GetRacialType(oTargets)== RACIAL_TYPE_OUTSIDER) ? d8(2) :d6(2);

         //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
         //nDam = PRCGetReflexAdjustedDamage(nDam, oTargets, (15+GetAbilityModifier(ABILITY_CHARISMA)), SAVING_THROW_TYPE_DIVINE);
         DelayCommand(fDelay + 0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectDamage( PRCGetReflexAdjustedDamage(nDam, oTargets, (15+GetAbilityModifier(ABILITY_CHARISMA)), SAVING_THROW_TYPE_DIVINE),DAMAGE_TYPE_DIVINE),eVis), oTargets));
     }
     //Select the next target within the spell shape.
     oTargets = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
     nMax--;
  }
}

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
   location loc = GetLocation(OBJECT_SELF);

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
           eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancement,iHit);
        else
           eDamage = AddDmgEffectMulti(iDamage,iDamageType, oWeap,oTarget,iEnhancement,iHit);
        
        
        DelayCommand(fDelay + 0.1, Attack(eDamage, oTarget,loc));


    }
    iNextAttackPenalty -= 5;
    fDelay += 1.0;


  }



}
void main()
{
  
   // take lvl for Speed
   int LvlRaziel=GetLevelByClass(CLASS_TYPE_FISTRAZIEL);
   int iFeat=(LvlRaziel+1)/2+FEAT_SMITE_GOOD_ALIGN-1;

   if (GetHasFeat(FEAT_SMITE_EVIL))
   {
        DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SMITE_EVIL);
        IncrementRemainingFeatUses(OBJECT_SELF,iFeat);
   }
   
   object oTarget=GetSpellTargetObject();
   
   ActionAttack(oTarget,TRUE);


   if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL)
   {
     NoSmite(oTarget,"Smite Failed : not Evil",0);
     return;
   }// Paladin/Fist Raziel need a Loyal Good Alignment
   else if (!(GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD && GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL)  )
   {
     NoSmite(oTarget,"Smite Failed : you're  not Lawful Good",1);
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
   int iEvil  =1 ;
   int iOuts  =(GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD ||GetRacialType(oTarget)== RACIAL_TYPE_OUTSIDER)  ? 1 :0 ;

   int iSmit=iEvil;
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

   int iDmgBon =  (GetLevelByClass(CLASS_TYPE_FISTRAZIEL)+GetLevelByClass(CLASS_TYPE_PALADIN)+GetLevelByClass(CLASS_TYPE_DIVINECHAMPION))* iEpicSmite ;
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
         break;
      /*
         if (!GetHasFeat(FEAT_RANGED_SMITE)){
            return;
         }
         else if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD){
            if (LvlRaziel > 0){
               while (GetHasFeat(FEAT_SMITE_EVIL)){
                  DecrementRemainingFeatUses(OBJECT_SELF, iFeat);
                  IncrementRemainingFeatUses(OBJECT_SELF, FEAT_RANGED_SMITE);
               }
            }
            else{
               while (GetHasFeat(FEAT_SMITE_EVIL)){
                  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SMITE_EVIL);
                  IncrementRemainingFeatUses(OBJECT_SELF, FEAT_RANGED_SMITE);
               }
            }
         }
         break;
      default:
         if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_GOOD)
         {
            if (LvlRaziel > 0)
            {
               while (GetHasFeat(FEAT_SMITE_EVIL))
               {
                  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_RANGED_SMITE);
                  IncrementRemainingFeatUses(OBJECT_SELF, iFeat);
               }
            }
            else
            {
               while (GetHasFeat(FEAT_SMITE_EVIL))
               {
                  DecrementRemainingFeatUses(OBJECT_SELF,FEAT_RANGED_SMITE);
                  IncrementRemainingFeatUses(OBJECT_SELF, FEAT_SMITE_EVIL);
               }
            }
         }
         break;*/
   }

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);

   location loc = GetLocation(OBJECT_SELF);
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

       if ( iSmit)   PlaySound("vs_npaladm1_bat2");
       if (Immune && iHit==2) iHit=1;

        //Check to see if we rolled a critical and determine damage accordingly
        // Dmg Bonus= Level Paladin+ Fist Raziel

        if(iHit == 2 || ( (LvlRaziel>2) && iSmit && !Immune))
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

        DelayCommand(fDelay + 0.1,Attack(EffectLinkEffects(eDamage,eVis), oTarget,loc));
        //DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eDamage,eVis), oTarget));

        if (LvlRaziel>8 && iSmit) SmiteChain(oTarget,fDelay);

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
