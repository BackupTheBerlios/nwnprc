// * Various functions to determine sneak dice.

// * Used to find the total sneak dice a character is capable of.
int GetTotalSneakAttackDice(object oPC);

// * Used to find the total rogue sneak dice a character is capable of.
int GetRogueSneak(object oPC);

// * Used to find the total blackguard sneak dice a character is capable of.
int GetBlackguardSneak(object oPC);

// * Used to find the total assassin sneak dice a character is capable of.
int GetAssassinSneak(object oPC);

// * Used to find how much a character has taken "Improved Sneak Attack".
int GetEpicFeatSneak(object oPC);

#include "prc_class_const"
#include "inc_item_props"

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
   
   
   if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
   {
      // Peerless Archer
      iClassLevel = GetLevelByClass(CLASS_TYPE_PEERLESS, oPC);
      if (iClassLevel) iRogueSneak += (iClassLevel + 2) / 3;
      
      // Blood Archer
    /*iClassLevel = GetLevelByClass(CLASS_TYPE_BLARCHER, oPC);
      if ((iClassLevel >= 5) && (iClassLevel < 8)) iRogueSneak++;
      if ((iClassLevel >= 8) && (iClassLevel < 10)) iRogueSneak += 2;
      if (iClassLevel >= 10) iRogueSneak += 3;*/
       
      // Order of the Bow Initiate 
      //iClassLevel = GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE, oPC);
   }
   if(GetBaseItemType(oWeapon) == BASE_ITEM_SLING)
   {
      // Halfling Warslinger
      //iClassLevel = GetLevelByClass(CLASS_TYPE_HALFLING_WARSLINGER, oPC);
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