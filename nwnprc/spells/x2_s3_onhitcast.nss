//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file can hold your module specific
    OnHitCastSpell definitions

    How to use:
    - Add the Item Property OnHitCastSpell: UniquePower (OnHit)
    - Add code to this spellscript (see below)

   WARNING!
   This item property can be a major performance hog when used
   extensively in a multi player module. Especially in higher
   levels, with each player having multiple attacks, having numerous
   of OnHitCastSpell items in your module this can be a problem.

   It is always a good idea to keep any code in this script as
   optimized as possible.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "x2_inc_switches"

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor
   int nVassal;         //Vassal Level
   int nBArcher;        // Blood Archer level
   int nFoeHunter;      // Foe Hunter Level
   
   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        =  GetSpellCastItem();
   nVassal =  GetLevelByClass(CLASS_TYPE_VASSAL, OBJECT_SELF);
   nBArcher = GetLevelByClass(CLASS_TYPE_BLARCHER, OBJECT_SELF);
   nFoeHunter = GetLevelByClass(CLASS_TYPE_FOE_HUNTER, OBJECT_SELF);


   if (GetIsObjectValid(oItem))
   {
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ONHITCAST);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }

//// Stormlord Shocking & Thundering Spear

     if (GetHasFeat( FEAT_THUNDER_WEAPON,OBJECT_SELF))
           ExecuteScript("ft_shockweap",OBJECT_SELF);

     if (GetHasSpellEffect(TEMPUS_ENCHANT_WEAPON,oItem))
     {
       if ( (GetLocalInt(OBJECT_SELF,"WeapEchant1")==TEMPUS_ABILITY_VICIOUS && GetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace1")) ||
            (GetLocalInt(OBJECT_SELF,"WeapEchant2")==TEMPUS_ABILITY_VICIOUS && GetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace2")) ||
            (GetLocalInt(OBJECT_SELF,"WeapEchant3")==TEMPUS_ABILITY_VICIOUS && GetRacialType(oSpellTarget)==GetLocalInt(OBJECT_SELF,"WeapEchantRace3")) )
           ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(d6()),OBJECT_SELF);
     }

     if (GetIsPC(oSpellOrigin))
             SetLocalInt(oSpellOrigin,"DmgDealt",GetTotalDamageDealt());

   }
   
   /// Vassal of Bahamut Dragonwrack
     if (nVassal > 3)
        {
           if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                ExecuteScript("prc_vb_dw_armor", oSpellOrigin);
            }
           else
            {
                ExecuteScript("prc_vb_dw_weap", oSpellOrigin);
            }
         }
   /// Blood Archer Acidic Blood
      if (nBArcher > 2)
        {
           if (GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
            {
                ExecuteScript("prc_bldarch_ab", oSpellOrigin);
            }
         }

   // Frenzied Berserker Auto Frenzy
   if(GetHasFeat(FEAT_FRENZY, OBJECT_SELF) )
   {      
	if(!GetHasFeatEffect(FEAT_FRENZY))
	{	    
		// 10 + damage dealt in that hit
		int willSaveDC = 10 + GetTotalDamageDealt();
		int save = WillSave(OBJECT_SELF, willSaveDC, SAVING_THROW_TYPE_NONE, OBJECT_SELF);
        	if(save == 0)
        	{
			AssignCommand(OBJECT_SELF, ActionUseFeat(FEAT_FRENZY, OBJECT_SELF) );
		}
        }
        
        if(GetHasFeatEffect(FEAT_FRENZY) && GetHasFeat(FEAT_DEATHLESS_FRENZY, OBJECT_SELF) && GetCurrentHitPoints(OBJECT_SELF) == 1)
        {
             int iDam = GetTotalDamageDealt();
             iDam += GetLocalInt(OBJECT_SELF, "PC_Damage");
             SetLocalInt(OBJECT_SELF, "PC_Damage", iDam);
             
             int iCHP = GetCurrentHitPoints(OBJECT_SELF) - iDam;
             
             string sFeedback = GetName(OBJECT_SELF) + " : Current HP = " + IntToString(iCHP);
             SendMessageToPC(OBJECT_SELF, sFeedback);
        }
   }
   
   // Foe Hunter Damage Resistance
   if( nFoeHunter > 1 && GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
   {              
        DelayCommand(0.01, ExecuteScript("prc_fh_dr",OBJECT_SELF) );
   }
}
