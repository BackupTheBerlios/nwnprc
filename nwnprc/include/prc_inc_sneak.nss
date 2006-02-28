
#include "prc_class_const"
#include "prc_feat_const"
#include "inc_utility"
#include "NW_I0_GENERIC"

// * Various functions to determine sneak dice.

// * Used to find the total sneak dice a character is capable of.
int GetTotalSneakAttackDice(object oPC);

// * Used to find the total rogue sneak dice a character is capable of.
// -----------------------------------------------------------------------------------------
// Future PRC's go here.  DO NOT ADD ROGUE/BLACKGUARD/ASSASSIN SNEAK ATTACKS AS CLASS FEATS.
// Placeholder feats are fine, even encouraged.  Example: "Ranged Sneak Attack +1d6".
// The feat should do nothing, just show that you have the bonus.
// -----------------------------------------------------------------------------------------
int GetRogueSneak(object oPC);

// * Used to find the total blackguard sneak dice a character is capable of.
int GetBlackguardSneak(object oPC);

// * Used to find the total assassin sneak dice a character is capable of.
int GetAssassinSneak(object oPC);

// * Used to find how much a character has taken "Improved Sneak Attack".
int GetEpicFeatSneak(object oPC);

//:://////////////////////////////////////////////
//::  Sneak Attack Functions
//:://////////////////////////////////////////////

// Checks if attacker is flanking the defender or not
int GetIsFlanked(object oDefender, object oAttacker);

// Checks if an AoE spell is flanking the defender
int GetIsAOEFlanked(object oDefender, object oAttacker);

// Determines if a creature is helpless.
// (effective dex modifier of 0, and can be Coup De Graced).
int GetIsHelpless(object oDefender);

// Returns if oDefender is denied dex bonus to AC from spells
// int nIgnoreUD - ignores Uncanny Dodge
int GetIsDeniedDexBonusToAC(object oDefender, object oAttacker, int nIgnoreUD = FALSE);

// Returns FALSE if oDefender has no concealment
// or the int amount of concealment on the defender.
int GetIsConcealed(object oDefender, object oAttacker);

// Returns true if the Attacker can Sneak Attack the target
int GetCanSneakAttack(object oDefender, object oAttacker);

// Returns Sneak Attack Damage
int GetSneakAttackDamage(int iSneakAttackDice);

//:://////////////////////////////////////////////
//::  Definintions
//:://////////////////////////////////////////////

int GetTotalSneakAttackDice(object oPC)
{
     int iSneakAttackDice = GetRogueSneak(oPC) + GetBlackguardSneak(oPC) +
                            GetAssassinSneak(oPC) + GetEpicFeatSneak(oPC);
     return iSneakAttackDice;
}

int GetRogueSneak(object oPC)
{
   object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

   int iClassLevel;
   int iRogueSneak = 0;

   // Rogue
   iClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
   if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;

   // Arcane Trickster (Epic)
   iClassLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
   if (iClassLevel >= 12) iRogueSneak += (iClassLevel - 10) / 2;

   // Black Flame Zealot
   iClassLevel = GetLevelByClass(CLASS_TYPE_BFZ, oPC);
   if (iClassLevel) iRogueSneak += iClassLevel / 3;

   // Nightshade
   iClassLevel = GetLevelByClass(CLASS_TYPE_NIGHTSHADE, oPC);
   if (iClassLevel) iRogueSneak += iClassLevel / 3;

   //Ambush Attack
   if (GetHasFeat(FEAT_UR_SNEAKATK_3D6,oPC)) iRogueSneak += 3;

   // Outlaw Crimson Road
   iClassLevel = GetLevelByClass(CLASS_TYPE_OUTLAW_CRIMSON_ROAD, oPC);
   if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;

   // Temple Raider
   iClassLevel = GetLevelByClass(CLASS_TYPE_TEMPLE_RAIDER, oPC);
   if (iClassLevel>= 2) iRogueSneak += (iClassLevel + 1) / 3;

   // Ghost-Faced Killer
   iClassLevel = GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER, oPC);
   if (iClassLevel >= 2) iRogueSneak += ((iClassLevel + 1) / 3);

   // Ninja
   iClassLevel = GetLevelByClass(CLASS_TYPE_NINJA, oPC);
   if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;
   
   // Slayer of Domiel
   iClassLevel = GetLevelByClass(CLASS_TYPE_SLAYER_OF_DOMIEL, oPC);
   if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;   

   if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
   {
      // Peerless Archer
      iClassLevel = GetLevelByClass(CLASS_TYPE_PEERLESS, oPC);
      if (iClassLevel) iRogueSneak += (iClassLevel + 2) / 3;

      // Blood Archer
      iClassLevel = GetLevelByClass(CLASS_TYPE_BLARCHER, oPC);
      if ((iClassLevel >= 5) && (iClassLevel < 8)) iRogueSneak++;
      if ((iClassLevel >= 8) && (iClassLevel < 10)) iRogueSneak += 2;
      if (iClassLevel >= 10) iRogueSneak += 3;

      // Order of the Bow Initiate
      //iClassLevel = GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE, oPC);
   }
   if(GetBaseItemType(oWeapon) == BASE_ITEM_SLING)
   {
      // Halfling Warslinger
      iClassLevel = GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oPC);
      if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;
   }

   // Infiltrator
 /*iClassLevel = GetLevelByClass(CLASS_TYPE_INFILTRATOR, oPC);
   if ((iClassLevel >= 1) && (iClassLevel < 5)) iRogueSneak++;
   if (iClassLevel >= 5) iRogueSneak += 2;

   // Fang of Lolth
   iClassLevel = GetLevelByClass(CLASS_TYPE_FANG_OF_LOLTH, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 5)) iRogueSneak++;
   if ((iClassLevel >= 5) && (iClassLevel < 8)) iRogueSneak += 2;
   if ((iClassLevel >= 8) && (iClassLevel < 12)) iRogueSneak += 3;
   if ((iClassLevel >= 12) && (iClassLevel < 16)) iRogueSneak += 4;
   if ((iClassLevel >= 16) && (iClassLevel < 20)) iRogueSneak += 5;
   if (iClassLevel >= 20) iRogueSneak += 6;*/

   if (GetBaseItemType(oWeapon) == BASE_ITEM_WHIP)
   {
      // Lasher
      iClassLevel = GetLevelByClass(CLASS_TYPE_LASHER, oPC);
      if (iClassLevel > 0) iRogueSneak += ((iClassLevel - 1) / 4) + 1;
   }

   // -----------------------------------------------------------------------------------------
   // Future PRC's go here.  DO NOT ADD ROGUE/BLACKGUARD/ASSASSIN SNEAK ATTACKS AS CLASS FEATS.
   // Placeholder feats are fine, even encouraged.  Example: "Ranged Sneak Attack +1d6".
   // The feat should do nothing, just show that you have the bonus.
   // -----------------------------------------------------------------------------------------

   return iRogueSneak;
}

// --------------------------------------------------
// PLEASE DO NOT ADD ANY NEW CLASSES TO THIS FUNCTION
// --------------------------------------------------
int GetBlackguardSneak(object oPC)
{
   int iClassLevel;
   int iBlackguardSneak = 0;

   // Blackguard
   iClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
   if (iClassLevel) iBlackguardSneak += (iClassLevel - 1) / 3;
   if ((iClassLevel) && (GetLevelByClass(CLASS_TYPE_PALADIN) >= 5)) iBlackguardSneak++;  // bonus for pal/bg

   // Ninja Spy
   iClassLevel = GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC);
   if (iClassLevel) iBlackguardSneak += (iClassLevel + 1) / 3;

   // Arcane Trickster (Pre-Epic)
   iClassLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 11)) iBlackguardSneak += iClassLevel / 2;
   if (iClassLevel >= 11) iBlackguardSneak += 5;

   // Disciple of Baalzebul
   iClassLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 5)) iBlackguardSneak++;
   if ((iClassLevel >= 5) && (iClassLevel < 8)) iBlackguardSneak += 2;
   if (iClassLevel >= 8) iBlackguardSneak += 3;

   return iBlackguardSneak;
}

// --------------------------------------------------
// PLEASE DO NOT ADD ANY NEW CLASSES TO THIS FUNCTION
// --------------------------------------------------
int GetAssassinSneak(object oPC)
{
   int iClassLevel;
   int iAssassinSneakDice = 0;

   // Assassin
   iClassLevel = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
   if (iClassLevel) iAssassinSneakDice += (iClassLevel + 1) / 2;

   // Telflammar Shadowlord
   iClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC);
   if (iClassLevel >= 6) iAssassinSneakDice++;

   return iAssassinSneakDice;
}

int GetEpicFeatSneak(object oPC)
{
   int iEpicFeatDice = 0;
   int iCount;

   // Basically searches top-down for improved sneak attack feats until it finds one.
   for(iCount = FEAT_EPIC_IMPROVED_SNEAK_ATTACK_10; iCount >= FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1; iCount--)
   {
      if (GetHasFeat(iCount,oPC))
      {
         iEpicFeatDice = (iCount + 1) - FEAT_EPIC_IMPROVED_SNEAK_ATTACK_1;
         break;
      }
   }

   return iEpicFeatDice;
}

//:://////////////////////////////////////////////
//::  Sneak Attack Function Definitions
//:://////////////////////////////////////////////

int GetIsFlanked(object oDefender, object oAttacker)
{
    int bReturnVal = FALSE;

    if(GetIsObjectValid(oAttacker) && GetIsObjectValid(oDefender))
    {
        // I am assuming that if the Defender is facing away from the
        // Attacker then the Defender is flanked, as NWN "turns" an
        // attacker towards the defender

        vector vDefender = AngleToVector(GetFacing(oDefender));
        vector vAttacker = AngleToVector(GetFacing(oAttacker));
        vector vResult = vDefender + vAttacker;

        float iMagDefender = VectorMagnitude(vDefender);
        float iMagResult = VectorMagnitude(vResult);

        // If the magnitude of the Defenders facing vector is greater than the
        // result of the magnitude of the vector addition of the Attackers and
        // Defenders facing then the Defender is flanked.

        if(iMagDefender < iMagResult)
        {
             bReturnVal = TRUE;
        }
    }

    return bReturnVal;
}

// Checks if an AoE spell is against someone distracted in meleee combat
int GetIsAOEFlanked(object oDefender, object oAttacker)
{
    int bReturnVal = TRUE;

    // if they are not in combat then they are automatically flanked (surprise round)
    if(!GetIsFighting(oDefender) || !GetIsInCombat(oDefender) )
    {
         // checks if they are attacking something other than the caster
         object oTarget = GetAttackTarget(oDefender);
         if(oTarget == oAttacker)  bReturnVal = FALSE;
    }

    return bReturnVal;
}

int GetIsHelpless(object oDefender)
{
     int bIsHelpless = FALSE;

     // PnP describes a helpless defender as
     // A helpless foe - one who is bound, held, sleeping, paralyzed,
     // unconscious, or otherwise at your mercy - is an easy target.
     if( GetHasEffect(EFFECT_TYPE_PARALYZE, oDefender) )               bIsHelpless = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_SLEEP, oDefender) )             bIsHelpless = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_PETRIFY, oDefender) )           bIsHelpless = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_CUTSCENE_PARALYZE, oDefender) ) bIsHelpless = TRUE;

     return bIsHelpless;
}

int GetIsDeniedDexBonusToAC(object oDefender, object oAttacker, int nIgnoreUD = FALSE)
{
     int bIsDeniedDex = FALSE;
     int bDefenderHasTrueSight = GetHasEffect(EFFECT_TYPE_TRUESEEING, oAttacker);
     int bDefenderCanSeeInvisble = GetHasEffect(EFFECT_TYPE_SEEINVISIBLE, oAttacker);
     int bDefenderIsKnockedDown = GetHasFeatEffect(FEAT_KNOCKDOWN, oDefender) || GetHasFeatEffect(FEAT_IMPROVED_KNOCKDOWN, oDefender);

     // if the player is helpess, they are automatically denied dex bonus.
     if( GetIsHelpless(oDefender) ) return TRUE;

     // if the player is not fighting, then this is the "surprise round"
     if( !GetIsFighting(oDefender) || !GetIsInCombat(oDefender) )
     {
          bIsDeniedDex = TRUE;
     }

     // In NwN, knocked down targets are counted as denied dex bonus to AC.
     if( bDefenderIsKnockedDown ) bIsDeniedDex = TRUE;

     // if defender has spell effect on them causing them to be denied dex bonus to AC.
     if( GetHasEffect(EFFECT_TYPE_BLINDNESS, oDefender) )          bIsDeniedDex = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_ENTANGLE, oDefender) )      bIsDeniedDex = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_FRIGHTENED, oDefender) )    bIsDeniedDex = TRUE;
     else if( GetHasEffect(EFFECT_TYPE_STUNNED, oDefender) )       bIsDeniedDex = TRUE;

     // Note: This is wrong by PnP rules... but Bioware allows auto sneaks on Dazed targets.
     //       to keep in tune with the game engine I'll leave this active.
     else if( GetHasEffect(EFFECT_TYPE_DAZED, oDefender) )         bIsDeniedDex = TRUE;

     // if attacker is invisvisible/hiding/etc.
     else if( GetHasEffect(EFFECT_TYPE_INVISIBILITY, oAttacker)  && !bDefenderHasTrueSight && !bDefenderCanSeeInvisble )
     {
          bIsDeniedDex = TRUE;
     }
     else if( GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oAttacker)  && !bDefenderHasTrueSight && !bDefenderCanSeeInvisble )
     {
          bIsDeniedDex = TRUE;
     }
     else if( !GetObjectSeen(oAttacker, oDefender) )
     {
          bIsDeniedDex = TRUE;
     }

     // Check for Uncanny Dodge Vs. Sneak Attack.
     if( GetHasFeat(FEAT_UNCANNY_DODGE_2, oDefender) && !nIgnoreUD )
     {
          int iUncannyDodgeLevels;
          iUncannyDodgeLevels += GetLevelByClass(CLASS_TYPE_BARBARIAN, oDefender);
          iUncannyDodgeLevels += GetLevelByClass(CLASS_TYPE_ASSASSIN , oDefender);
          iUncannyDodgeLevels += GetLevelByClass(CLASS_TYPE_ROGUE    , oDefender);
          iUncannyDodgeLevels += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oDefender);

          // +4 because a rogue has to be 4 levels higher to flank
          iUncannyDodgeLevels += 4;

          int iSneakAttackLevels;
          iSneakAttackLevels = GetTotalSneakAttackDice(oAttacker);
          /*    Primogenitor - Not sure why the overall function isnt used

          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_ASSASSIN  , oAttacker);
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_ROGUE     , oAttacker);
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_BLACKGUARD, oAttacker);

          // add other sneak attacking PrC's here
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_ARCTRICK, oAttacker);
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oAttacker);
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_PEERLESS, oAttacker);
          iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_BLARCHER, oAttacker);

          //
          // Use template to add future classes
          // iSneakAttackLevels += GetLevelByClass(CLASS_TYPE_*, oAttacker);
          //
          */

          if(iUncannyDodgeLevels > iSneakAttackLevels)
          {
               bIsDeniedDex = FALSE;
          }

          if(GetLevelByClass(CLASS_TYPE_DWARVENDEFENDER, oDefender) > 0 )
          {
              bIsDeniedDex = FALSE;
          }
     }

     return bIsDeniedDex;
}

int GetIsConcealed(object oDefender, object oAttacker)
{
     int bIsConcealed = FALSE;

     int bAttackerHasTrueSight = GetHasEffect(EFFECT_TYPE_TRUESEEING, oAttacker);
     int bAttackerCanSeeInvisble = GetHasEffect(EFFECT_TYPE_SEEINVISIBLE, oAttacker);
     int bAttackerUltraVision = GetHasEffect(EFFECT_TYPE_ULTRAVISION, oAttacker);

     if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_50, oDefender) )          bIsConcealed = 50;
     else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_40, oDefender) )     bIsConcealed = 40;
     else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_30, oDefender) )     bIsConcealed = 30;
     else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_20, oDefender) )     bIsConcealed = 20;
     else if(GetHasFeat(FEAT_EPIC_SELF_CONCEALMENT_10, oDefender) )     bIsConcealed = 10;

     // darkness, invisible, imp invisible
     else if(GetStealthMode(oDefender) == STEALTH_MODE_ACTIVATED && !GetObjectSeen(oDefender, oAttacker) )  bIsConcealed = TRUE;
     else if(GetHasEffect(EFFECT_TYPE_SANCTUARY, oDefender) && !bAttackerHasTrueSight )
     {
          // if they player is hidden you know enough to try attacking, give 50% miss chance
          // as that is the highest concealment normally allowed.
          // couldn't find any rules that governed this though.
          bIsConcealed = 50;
     }
     else if(GetHasEffect(EFFECT_TYPE_INVISIBILITY, oDefender) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble )
     {
          bIsConcealed = 50;
     }
     else if(GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oDefender) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble  )
     {
          bIsConcealed = 50;
     }
     else if(GetHasEffect(EFFECT_TYPE_DARKNESS, oDefender) && !bAttackerHasTrueSight && !bAttackerUltraVision)
     {
          bIsConcealed = 50;
     }
     else if(GetHasFeatEffect(FEAT_EMPTY_BODY, oDefender) )
     {
          bIsConcealed = 50;
     }
     //else if(GetHasEffect(EFFECT_TYPE_ETHEREAL, oDefender) && !bAttackerHasTrueSight && !bAttackerCanSeeInvisble  )
     //{
     //     bIsConcealed = TRUE;
     //}

     // spell effects
     else if(GetHasSpellEffect(1764 , oDefender) && !bAttackerHasTrueSight) // blur spell
     {
          bIsConcealed = 20;
     }
     else if(GetHasSpellEffect(SPELL_DISPLACEMENT , oDefender) && !bAttackerHasTrueSight)
     {
          bIsConcealed = 50;
     }
     else if(GetHasSpellEffect(SPELL_SHADOW_EVADE , oDefender) && !bAttackerHasTrueSight)
     {
          int iSDlevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oDefender);
          if(iSDlevel <= 4)  bIsConcealed = 5;
          if(iSDlevel <= 6)  bIsConcealed = 10;
          if(iSDlevel <= 8)  bIsConcealed = 15;
          if(iSDlevel <= 10) bIsConcealed = 20;
     }

     // this is the catch-all effect
     else if(GetHasEffect(EFFECT_TYPE_CONCEALMENT, oDefender) && !bAttackerHasTrueSight)
     {
          if(bIsConcealed == FALSE) bIsConcealed = TRUE;
     }

     return bIsConcealed;
}

int GetCanSneakAttack(object oDefender, object oAttacker)
{
    //cant sneak non-creatures
     if(GetObjectType(oDefender) != OBJECT_TYPE_CREATURE)
        return FALSE;

     int bReturnVal = FALSE;
     int bIsInRange = FALSE;
     int bIsFlanked = GetIsFlanked(oDefender, oAttacker);
     int bIsDeniedDex = GetIsDeniedDexBonusToAC(oDefender, oAttacker);
     
     float fDistance = GetDistanceBetween(oAttacker, oDefender);
     if(fDistance <= FeetToMeters(30.0f) )     bIsInRange = TRUE;
     
     // Is only run if enemy is indeed flanked or denied dex bonus to AC
     // otherwise there is no reason to check further
     if(bIsFlanked || bIsDeniedDex && bIsInRange)
     {
          // so far they can be sneaked
          bReturnVal = TRUE;

          // checking for other factors that remove sneak attack
          if( GetIsImmune(oDefender, IMMUNITY_TYPE_CRITICAL_HIT, OBJECT_INVALID) )   bReturnVal = FALSE;
          if( GetIsImmune(oDefender, IMMUNITY_TYPE_SNEAK_ATTACK, OBJECT_INVALID) )   bReturnVal = FALSE;

          if( GetIsConcealed(oDefender, oAttacker) )   bReturnVal = FALSE;
     }

     return bReturnVal;
}

int GetSneakAttackDamage(int iSneakAttackDice)
{
     int iSneakAttackDamage = d6(iSneakAttackDice);
     return iSneakAttackDamage;
}