// Written by WodahsEht.
// Calculates the total sneak attack damage die given by all classes,
// and applies the resulting bonuses to the skin.  KNOWN ISSUE:
// Sneak attack feats of the same type can appear twice on the character sheet.
// For instance, Rogue +3d6 appears alongside Rogue +10d6.  They do not stack.
// The damage is 10d6.
// 
// Compatibility with old PRC's is maintained.

#include "prc_class_const"
#include "inc_item_props"

int GetRogueSneak(object oPC)
{
   object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   int iRogueSneak = 0;
   int iBowEquipped = FALSE;
   int iClassLevel;

   iClassLevel = GetLevelByClass(CLASS_TYPE_ROGUE, oPC);
   if (iClassLevel) iRogueSneak += (iClassLevel + 1) / 2;

   // The Arcane Trickster is given a special case.  Before level 10, it
   // gains blackguard sneaks by feats.  To avoid breaking the class, this
   // was kept.  After level 10, it gains rogue sneaks to be applied to the skin.
   iClassLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
   if (iClassLevel >= 12) iRogueSneak += (iClassLevel - 10) / 2;

   iClassLevel = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC);
   if (iClassLevel >= 6) iRogueSneak++;

   if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGBOW ||
       GetBaseItemType(oWeapon) == BASE_ITEM_SHORTBOW)
          iBowEquipped = TRUE;

   if (iBowEquipped)
   {
      iClassLevel = GetLevelByClass(CLASS_TYPE_PEERLESS, oPC);
      if (iClassLevel) iRogueSneak += (iClassLevel + 2) / 3;

      //iClassLevel = GetLevelByClass(CLASS_TYPE_BLARCHER, oPC);
      //if ((iClassLevel >= 5) && (iClassLevel < 8)) iRogueSneak++;
      //if ((iClassLevel >= 8) && (iClassLevel < 10)) iRogueSneak += 2;
      //if (iClassLevel >= 10) iRogueSneak += 3;
   }

   //iClassLevel = GetLevelByClass(CLASS_TYPE_INFILTRATOR, oPC);
   //if ((iClassLevel >= 1) && (iClassLevel < 5)) iRogueSneak++;
   //if (iClassLevel >= 5) iRogueSneak += 2;

   //iClassLevel = GetLevelByClass(CLASS_TYPE_FANG_OF_LOLTH, oPC);
   //if ((iClassLevel >= 2) && (iClassLevel < 5)) iRogueSneak++;
   //if ((iClassLevel >= 5) && (iClassLevel < 8)) iRogueSneak += 2;
   //if ((iClassLevel >= 8) && (iClassLevel < 12)) iRogueSneak += 3;
   //if ((iClassLevel >= 12) && (iClassLevel < 16)) iRogueSneak += 4;
   //if ((iClassLevel >= 16) && (iClassLevel < 20)) iRogueSneak += 5;
   //if (iClassLevel >= 20) iRogueSneak += 6;

     iClassLevel = GetLevelByClass(CLASS_TYPE_BFZ, oPC);
     if ((iClassLevel >= 3) && (iClassLevel < 6)) iRogueSneak++;
     if ((iClassLevel >= 6) && (iClassLevel < 9)) iRogueSneak += 2;
     if (iClassLevel >= 9) iRogueSneak += 3;

   //Future PRC's go here.  DO NOT ADD SNEAK ATTACKS AS CLASS FEATS.
   //Also, there are a couple of instances in the combat system
   //which will need to be updated, as well as the impromptu sneak attack
   //from the Arcane Trickster.

   return iRogueSneak;
}

int GetBlackguardSneak(object oPC)
{
   int iClassLevel;
   int iBlackguardSneak = 0;

   iClassLevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
   if (iClassLevel) iBlackguardSneak += (iClassLevel - 1) / 3;
   if ((iClassLevel) && (GetLevelByClass(CLASS_TYPE_PALADIN) >= 5)) iBlackguardSneak++;  // bonus for pal/bg

   //Epic Ninja has Blackguard Sneaks as well...
   iClassLevel = GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC);
   if (iClassLevel) iBlackguardSneak += (iClassLevel + 1) / 3;

   //More special case on the Arcane Trickster... (see above)
   iClassLevel = GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 11)) iBlackguardSneak += iClassLevel / 2;
   if (iClassLevel >= 11) iBlackguardSneak += 5;

   //This guy was also given feats but he doesn't have any progression after this...
   iClassLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL, oPC);
   if ((iClassLevel >= 2) && (iClassLevel < 5)) iBlackguardSneak++;
   if ((iClassLevel >= 5) && (iClassLevel < 8)) iBlackguardSneak += 2;
   if (iClassLevel >= 8) iBlackguardSneak += 3;

   return iBlackguardSneak;
}

void ApplySneakToSkin(object oPC, int iRogueSneak, int iBlackguardSneak)
{
   object oSkin = GetPCSkin(oPC);

   int iRogueSneakFeat = 0;
   int iBlackguardSneakFeat = 0;
   int iPreviousSneakFeat = 0;

   //Rogue Sneaks, in increasing order, from iprp_feat.2da:
   //1-3: 32-34, 4: 301, 5: 39, 6-20: 302-316
   if (iRogueSneak > 20) return;  //Error, should never happen.

   if ((iRogueSneak >= 1) && (iRogueSneak < 4)) iRogueSneakFeat = iRogueSneak + 31;
   if (iRogueSneak == 4) iRogueSneakFeat = 301;
   if (iRogueSneak == 5) iRogueSneakFeat = 39;
   if (iRogueSneak >= 6) iRogueSneakFeat = iRogueSneak + 296;

   //SendMessageToPC(oPC, "iRogueSneakFeat = " + IntToString(iRogueSneakFeat) +
   //                     " iRogueSneak = " + IntToString(iRogueSneak));

   //Blackguard Sneaks
   //1-15: 276-290
   if (iBlackguardSneak > 15) return; //Error, should never happen.

   if (iBlackguardSneak) iBlackguardSneakFeat = iBlackguardSneak + 275;

   //SendMessageToPC(oPC, "iBlackguardSneakFeat = " + IntToString(iBlackguardSneakFeat) +
   //                     " iBlackguardSneak = " + IntToString(iBlackguardSneak));


   // This is basically to always readd the sneaks on every event PRCEvalFeats is called...
   iPreviousSneakFeat = GetLocalInt(oSkin,"RogueSneakDice");
   if (iPreviousSneakFeat) DelayCommand(0.1, RemoveSpecificProperty(oSkin,
                           ITEM_PROPERTY_BONUS_FEAT,iPreviousSneakFeat));

   iPreviousSneakFeat = GetLocalInt(oSkin,"BlackguardSneakDice");
   if (iPreviousSneakFeat) DelayCommand(0.1, RemoveSpecificProperty(oSkin,
                           ITEM_PROPERTY_BONUS_FEAT,iPreviousSneakFeat));

   SetLocalInt(oSkin,"RogueSneakDice",iRogueSneakFeat);
   SetLocalInt(oSkin,"BlackguardSneakDice",iBlackguardSneakFeat);

   if (iRogueSneak) DelayCommand(0.2, AddItemProperty(DURATION_TYPE_PERMANENT,
                           ItemPropertyBonusFeat(iRogueSneakFeat), oSkin));
   if (iBlackguardSneak) DelayCommand(0.2, AddItemProperty(DURATION_TYPE_PERMANENT,
                           ItemPropertyBonusFeat(iBlackguardSneakFeat), oSkin));
}


void main()
{
   object oPC = OBJECT_SELF;

   int iRogueSneakDice = GetRogueSneak(oPC);
   int iBlackguardSneakDice = GetBlackguardSneak(oPC);
   int iFinalSneakDice = iRogueSneakDice + iBlackguardSneakDice;
   
   if(iRogueSneakDice > 20)        //Basically, if the total sneaks spill over the rogue limit,
   {                               //Add it to the Blackguard sneaks.  Only possible with a Rog39/PA1 ATM.
      iBlackguardSneakDice += iRogueSneakDice - 20;
      iRogueSneakDice = 20;
   }
   if(iBlackguardSneakDice > 15)   //Same as above, handles BG spillover.  Not really possible, but...
   {
      iRogueSneakDice += iBlackguardSneakDice - 15;
      iBlackguardSneakDice = 15;
   }
   if(iRogueSneakDice > 20)
   {
      //Keep in mind we are not considering the Assassin's Death Attack or Improved
      //Sneak Attack.  If we hit more than +35d6 there is something wrong with the
      //character or the above code.
      SendMessageToPC(oPC,"Fatal error: +35d6 Rogue/Blackguard Sneak Attack exceeded!");
      return;
   }

   //Debug messages:
   //SendMessageToPC(oPC,"You will have a total of " + IntToString(iFinalSneakDice) +
   //                " Sneak Dice.");
   //SendMessageToPC(oPC,IntToString(iRogueSneakDice) + " are Rogue, and " +
   //                IntToString(iBlackguardSneakDice) + " are Blackguard.");

   if(iFinalSneakDice) ApplySneakToSkin(oPC,iRogueSneakDice,iBlackguardSneakDice);
}
