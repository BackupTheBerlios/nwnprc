#include "inc_combat"
#include "x2_inc_itemprop"
#include "X0_I0_SPELLS"

#include "inc_combat2"
#include "Soul_inc"

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
         //nDam = GetReflexAdjustedDamage(nDam, oTargets, (15+GetAbilityModifier(ABILITY_CHARISMA)), SAVING_THROW_TYPE_DIVINE);
         DelayCommand(fDelay + 0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectLinkEffects(EffectDamage( GetReflexAdjustedDamage(nDam, oTargets, (15+GetAbilityModifier(ABILITY_CHARISMA)), SAVING_THROW_TYPE_DIVINE),DAMAGE_TYPE_DIVINE),eVis), oTargets));
     }
     //Select the next target within the spell shape.
     oTargets = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE );
     nMax--;
  }
}

void NoSmite(object oTarget ,string sText)
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
   float fDelay = 1.5f;

   int iAttacks=NbAtk(OBJECT_SELF);

   int iDamage = 0;
   effect eDamage;

   int Immune = GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT);
   int iEnhancement = GetWeaponEnhancement(oWeap);
   int iDamageType = GetWeaponDamageType(oWeap);

   FloatingTextStringOnCreature(sText,OBJECT_SELF);

   int iEvil  = GetAlignmentGoodEvil(oTarget)==ALIGNMENT_EVIL ;
   int SancMar  = Sanctify_Feat(GetBaseItemType(oWeap))  ? 1 :0 ;

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
           eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, DAMAGE_POWER_ENERGY) ,oWeap,oTarget,iEnhancement);
        else
           eDamage = AddDmgEffect(EffectDamage(iDamage, iDamageType, iEnhancement) ,oWeap,oTarget,iEnhancement);

        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage, oTarget));


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

   if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL)
   {
     NoSmite(oTarget,"Smite Failed : not Evil");
     return;
   }// Paladin/Fist Raziel need a Loyal Good Alignment
   else if (!(GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD && GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL)  )
   {
     NoSmite(oTarget,"Smite Failed : you're  not Lawful Good");
     return;
   }

   object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);

   int iNextAttackPenalty = 0;
   float fDelay = 1.5f;

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

        if(iHit == 2 || ( (LvlRaziel>2) && iSmit && !Immune))
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, TRUE,iDmgBon);
        else
            iDamage = GetMeleeWeaponDamageS(OBJECT_SELF, oWeap, oTarget, FALSE,iDmgBon);

        //Apply the damage
        if (iSmit)
           eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE, iEnhancementGD);
        else
        {
            eDamage = EffectDamage(iDamage, iDamageType, iEnhancementGD);

        }

        DelayCommand(fDelay + 0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectLinkEffects(eDamage,eVis), oTarget));

        if (LvlRaziel>8 && iSmit) SmiteChain(oTarget,fDelay);

    }

    iSmit=0;
    iNextAttackPenalty -= 5;
    fDelay += 1.0;
    iDmgBon=0;


  }
}
