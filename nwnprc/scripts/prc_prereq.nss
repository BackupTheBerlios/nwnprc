//::///////////////////////////////////////////////
//:: PRC Prerequisites
//:: prc_prereq.nss
//:://////////////////////////////////////////////
//:: Check to see what classes a PC is capable of taking.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  
//:: Created On: July 3rd, 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "prc_inc_sneak"
#include "soul_inc"

// This part needs to be changed for every new arcane caster.
int GetArcanePRCLevels(object oPC)
{
   int iArcanePRCLevels = GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC)
        + GetLevelByClass(CLASS_TYPE_ARCTRICK, oPC)
        + GetLevelByClass(CLASS_TYPE_ELDRITCH_KNIGHT, oPC)
        + GetLevelByClass(CLASS_TYPE_ES_ACID, oPC)
        + GetLevelByClass(CLASS_TYPE_ES_COLD, oPC)
        + GetLevelByClass(CLASS_TYPE_ES_ELEC, oPC)
        + GetLevelByClass(CLASS_TYPE_ES_FIRE, oPC)
        + GetLevelByClass(CLASS_TYPE_HARPERMAGE, oPC)
        + GetLevelByClass(CLASS_TYPE_MAGEKILLER, oPC)
        + GetLevelByClass(CLASS_TYPE_MASTER_HARPER, oPC)
        + GetLevelByClass(CLASS_TYPE_TRUENECRO, oPC)
        + GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oPC)
        + (GetLevelByClass(CLASS_TYPE_ACOLYTE, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_HATHRAN, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_ORCUS, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) + 1) / 2;

   return iArcanePRCLevels;
}
   
// This part needs to be changed for every new divine caster.
int GetDivinePRCLevels(object oPC)
{
   int iDivinePRCLevels = GetLevelByClass(CLASS_TYPE_DIVESA, oPC)
        + GetLevelByClass(CLASS_TYPE_DIVESC, oPC)
        + GetLevelByClass(CLASS_TYPE_DIVESE, oPC)
        + GetLevelByClass(CLASS_TYPE_DIVESF, oPC)
        + GetLevelByClass(CLASS_TYPE_FISTRAZIEL, oPC)
        + GetLevelByClass(CLASS_TYPE_HEARTWARDER, oPC)
        + GetLevelByClass(CLASS_TYPE_HIEROPHANT, oPC)
        + GetLevelByClass(CLASS_TYPE_HOSPITALER, oPC)
        + GetLevelByClass(CLASS_TYPE_MASTER_OF_SHROUDS, oPC)
        + GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oPC)
        + GetLevelByClass(CLASS_TYPE_STORMLORD, oPC)
        + (GetLevelByClass(CLASS_TYPE_KNIGHT_CHALICE, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_OCULAR, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_TEMPUS, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_HATHRAN, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_BFZ, oPC) + 1) / 2
        + (GetLevelByClass(CLASS_TYPE_WARPRIEST, oPC) + 1) / 2;

        if ( !GetHasFeat(FEAT_SF_CODE, oPC))
              iDivinePRCLevels += (GetLevelByClass(CLASS_TYPE_SACREDFIST, oPC) + 1) / 2;
        
   return iDivinePRCLevels;
}

int GetBardSpellLevel(object oPC)
{
        int iBard = GetLevelByClass(CLASS_TYPE_BARD, oPC);
        int iCha = GetAbilityScore(oPC, ABILITY_CHARISMA) - 10;
        int iShad = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC);
        int iInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE) - 10;
	int iBSpell;
	int iSSpell;
	
	// Adjust the Bard's level upwards if it is the one recieving the benefits of
	// the PRC's.
	if ((iBard > GetLevelByClass(CLASS_TYPE_SORCERER)) &&
	    (iBard > GetLevelByClass(CLASS_TYPE_WIZARD)))
	     iBard += GetArcanePRCLevels(oPC);

	if (iBard >= 16)
	{
	iBSpell = 6;
	}
	else if (iBard >= 13)
	{
	iBSpell = 5;
	}
	else if (iBard >= 10)
	{
	iBSpell = 4;
	}
	else if (iBard >= 7)
	{
	iBSpell = 3;
	}
	else if (iBard >= 4)
	{
	iBSpell = 2;
	}
	else if (iBard >= 2)
	{
	iBSpell = 1;
	}

	else if (iShad >= 5)
	{
	iSSpell = 3;
	}
	else if (iShad >= 3)
	{
	iSSpell = 2;
	}
	else if (iShad >= 1)
	{
	iSSpell = 1;
	}

	if (iInt < iSSpell)
	{
	iSSpell = iInt;
	} 

	if (iCha < iBSpell)
	{
	iBSpell = iCha;
	} 

	if (iSSpell > iBSpell)
	{
	iBSpell = iSSpell;
	} 

	return iBSpell;
}

int GetRanPalSpellLevel(object oPC)
{
        int iRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
        int iPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
        int iSoldier = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT, oPC);
        int iWis = GetAbilityScore(oPC, ABILITY_WISDOM) - 10;
	int iRanPal;
	int iSOL;

	// Adjust the Rangers's level upwards if it is the one recieving the benefits of
	// the PRC's.
	if ((iRanger > GetLevelByClass(CLASS_TYPE_CLERIC)) &&
	    (iRanger > GetLevelByClass(CLASS_TYPE_DRUID)) &&
	    (iRanger > iPaladin))
	     iRanger += GetDivinePRCLevels(oPC);
	
	// Likewise for the Paladin.
	if ((iPaladin > GetLevelByClass(CLASS_TYPE_CLERIC)) &&
	    (iPaladin > GetLevelByClass(CLASS_TYPE_DRUID)) &&
	    (iPaladin > iRanger))
	     iPaladin += GetDivinePRCLevels(oPC);

	if (iRanger >= 14 || iPaladin >= 14)
	{
	iRanPal = 4;
	}
	else if (iRanger >= 11 || iPaladin >= 11)
	{
	iRanPal = 3;
	}
	else if (iRanger >= 8 || iPaladin >= 8)
	{
	iRanPal = 2;
	}
	else if (iRanger >= 4 || iPaladin >= 4)
	{
	iRanPal = 1;
	}

	if (iSoldier >= 8)
	{
	iSOL = 4;
	}
	else if (iSoldier >= 6)
	{
	iSOL = 3;
	}
	else if (iSoldier >= 4)
	{
	iSOL = 2;
	}
	else if (iSoldier >= 2)
	{
	iSOL = 1;
	}

	if (iSOL > iRanPal)
	{
	iRanPal = iSOL;
	}

	if (iWis < iRanPal)
	{
	iRanPal = iWis;
	} 

	return iRanPal;
}

int ArcSpell(object oPC, int iArcSpell)
{
	//A basic check to see what their primary class is
        int iSorc = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
        int iWiz = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        int iCha = GetAbilityScore(oPC, ABILITY_CHARISMA) - 10;
        int iInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE) - 10;


        iArcSpell = iWiz;
        
        if (iSorc > iWiz)
        {
             if (iSorc = 1)
                  iArcSpell = 1;
             else
                  iArcSpell = iSorc - 1;
        }

	//Checks to see what level of spells they can cast
        iArcSpell += GetArcanePRCLevels(oPC);

        iArcSpell = (iArcSpell + 1) / 2;
	if (iArcSpell > 9)
	{
	iArcSpell = 9;
	}
	
	//Check to see they have a high enough casting stat for their spell level
        if (iSorc > iWiz)
        {
		if (iCha < iArcSpell)
		{
		iArcSpell = iCha;
		}
        }
	else if (iInt < iArcSpell)
	{
	iArcSpell = iInt;
	} 

	//Check for Bards
	int iBSpell = GetBardSpellLevel(oPC);
	if (iBSpell > iArcSpell)
	{
	iArcSpell = iBSpell;
	}
	
	//Finally, set the variables.
	string sVariable1;
	string sVariable2;
	int iCount;
		
	for (iCount = 1; iCount <= 9; iCount++)
	{
	   string sVariable1 = "PRC_ArcSpell" + IntToString(iCount);
	   string sVariable2 = "PRC_AllSpell" + IntToString(iCount);
	   if (iArcSpell >= iCount)
	   {
	      SetLocalInt(oPC, sVariable1, 0);
	      SetLocalInt(oPC, sVariable2, 0);
	   }
	}
        
        return iArcSpell;
}

int DivSpell(object oPC, int iDivSpell)
{
	//Variables
        int iDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
        int iCler = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
        int iWis = GetAbilityScore(oPC, ABILITY_WISDOM) - 10;

        iDivSpell = iCler;

       	//A basic check to see what their primary class is
        if (iDruid > iCler)
        {
        iDivSpell = iDruid;
        }

	//Checks to see what level of spells they can cast
        iDivSpell += GetDivinePRCLevels(oPC);

	iDivSpell = (iDivSpell + 1) / 2;
	if (iDivSpell > 9)
	{
	iDivSpell = 9;
	}
	
	//Check to see they have a high enough casting stat for their spell level
	if (iWis < iDivSpell)
	{
	iDivSpell = iWis;
	} 

	//Check for rangers and paladins
	int iRanPal = GetRanPalSpellLevel(oPC);
	if (iRanPal > iDivSpell)
	{
	iDivSpell = iRanPal;
	}

	//Finally, set the variables.
	string sVariable1;
	string sVariable2;
	int iCount;
	
	for (iCount = 1; iCount <= 9; iCount++)
	{
	   string sVariable1 = "PRC_DivSpell" + IntToString(iCount);
	   string sVariable2 = "PRC_AllSpell" + IntToString(iCount);
	   if (iDivSpell >= iCount)
	   {
	      SetLocalInt(oPC, sVariable1, 0);
	      SetLocalInt(oPC, sVariable2, 0);	      
	   }
	}

        return iDivSpell;
}

void SneakRequirement(object oPC)
{
   int iSneak = GetTotalSneakAttackDice(oPC);
   int iCount;
   string sVariable;
   
   for (iCount = 1; iCount <= 30; iCount++)
   {
      sVariable = "PRC_SneakLevel" + IntToString(iCount);
      if (iSneak >= iCount)
         SetLocalInt(oPC, sVariable, 0);
   }
}     

void Hathran(object oPC)
{

    SetLocalInt(oPC, "PRC_Female", 1);

    if (GetGender(oPC) == GENDER_FEMALE)
    {
    SetLocalInt(oPC, "PRC_Female", 0);
    }
}

void Shifter(object oPC, int iArcSpell, int iDivSpell)
{

	SetLocalInt(oPC, "PRC_PrereqShift", 1);

	if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) && GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oPC) && iDivSpell >= 5)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) && iArcSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) && iArcSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_DRUID, oPC) >= 5)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) >= 15)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_INITIATE_DRACONIC, oPC) >= 10)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC) >= 7)
	{
	SetLocalInt(oPC, "PRC_PrereqShift", 0);
	}
}

void Tempest(object oPC)
{
	SetLocalInt(oPC, "PRC_PrereqTemp", 1);

	if ((GetHasFeat(FEAT_AMBIDEXTERITY, oPC) && GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oPC)) || GetHasFeat(FEAT_RANGER_DUAL, oPC))
	{
	SetLocalInt(oPC, "PRC_PrereqTemp", 0);
	}
}

void KOTC(object oPC)
{
	SetLocalInt(oPC, "PRC_PrereqKOTC", 1);

	
	if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >= 1)
	{
	SetLocalInt(oPC, "PRC_PrereqKOTC", 0);
	}
	if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 4)
	{
	SetLocalInt(oPC, "PRC_PrereqKOTC", 0);
	}
}

void Shadowlord(object oPC, int iArcSpell)
{
	int iShadLevel = GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);
    
	int iShadItem;
	if(GetHasItem(oPC,"shadowwalkerstok"))
	{
	iShadItem = 1;
	}

	SetLocalInt(oPC, "PRC_PrereqTelflam", 1);

	if ( iArcSpell >= 4 || iShadLevel  || iShadItem)
	{
        SetLocalInt(oPC, "PRC_PrereqTelflam", 0);
	}
}

void SOL(object oPC)
{       
	int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


	if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) 
	{  
		if (iCleric)
		{
		SetLocalInt(oPC, "PRC_PrereqSOL", 1);
		int iElishar = GetHasFeat(FEAT_GOOD_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_HEALING_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_KNOWLEDGE_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_LUCK_DOMAIN_POWER,oPC)+
		GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER,oPC)+GetHasFeat(FEAT_SUN_DOMAIN_POWER,oPC);
	
			if (iElishar>1)
			{
			SetLocalInt(oPC, "PRC_PrereqSOL", 0);
			}
		}	
	}	
}

void ManAtArms(object oPC)
{       

  int iWF;
  
  iWF = GetHasFeat(FEAT_WEAPON_FOCUS_BASTARD_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_BATTLE_AXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_CLUB,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_DAGGER,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DART,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DIRE_MACE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_DOUBLE_AXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_DWAXE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_GREAT_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HALBERD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HAND_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_HEAVY_FLAIL,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_KAMA,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LONG_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER,oPC);
        


  iWF += GetHasFeat(FEAT_WEAPON_FOCUS_KATANA,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_KUKRI,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_FLAIL,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_HAMMER,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_LIGHT_MACE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_LONGBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_MORNING_STAR,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SCIMITAR,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SCYTHE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SHORTBOW,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SHURIKEN,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_SICKLE,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SLING,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_SPEAR,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_STAFF,oPC)+GetHasFeat(FEAT_WEAPON_FOCUS_THROWING_AXE,oPC)+
        GetHasFeat(FEAT_WEAPON_FOCUS_WAR_HAMMER,oPC);//+GetHasFeat(FEAT_WEAPON_FOCUS_WHIP,oPC);
   
        
	SetLocalInt(oPC, "PRC_PrereqMAA", 1);

	if (iWF > 3) 
	{
	SetLocalInt(oPC, "PRC_PrereqMAA", 0);
	}
}

void BFZ(object oPC)
{       
	int iCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);


	if (iCleric > 0)
	{
		SetLocalInt(oPC, "PRC_PrereqBFZ", 1);
		if (GetHasFeat(FEAT_FIRE_DOMAIN_POWER,oPC) && GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER,oPC))
		{
		SetLocalInt(oPC, "PRC_PrereqBFZ", 0);
		}	
	}	
}

void main()
{
        //Declare Major Variables
        object oPC = OBJECT_SELF;
        int iArcSpell;
        int iDivSpell;
        int iArcSpell1;
        int iDivSpell1;
        int iSnkLevel;
        
        // Initialize all the variables.
        string sVariable;
	int iCount;
	for (iCount = 1; iCount <= 9; iCount++)
	{
	   sVariable = "PRC_AllSpell" + IntToString(iCount);
	   SetLocalInt(oPC, sVariable, 1);
	   
	   sVariable = "PRC_ArcSpell" + IntToString(iCount);
	   SetLocalInt(oPC, sVariable, 1);

	   sVariable = "PRC_DivSpell" + IntToString(iCount);
	   SetLocalInt(oPC, sVariable, 1);
	}
	for (iCount = 1; iCount <= 30; iCount++)
	{
	   sVariable = "PRC_SneakLevel" + IntToString(iCount);
	   SetLocalInt(oPC, sVariable, 1);
	}        

	// Find the spell levels.
	iArcSpell1 = ArcSpell(oPC, iArcSpell);
	iDivSpell1 = DivSpell(oPC, iDivSpell);

	// Find the sneak attack capacity.
        SneakRequirement(oPC);
        
        // Special requirements for several classes.
        Hathran(oPC);
	Tempest(oPC);
	KOTC(oPC);
	BFZ(oPC);
	ManAtArms(oPC);
	SOL(oPC);
	Shadowlord(oPC, iArcSpell1);
	Shifter(oPC, iArcSpell1, iDivSpell1);
	
	// Truly massive debug message flood if activated.
	/*
	string sPRC_AllSpell;
	string sPRC_ArcSpell;
	string sPRC_DivSpell;
	for (iCount = 1; iCount <= 9; iCount++)
	{
	   sPRC_AllSpell = "PRC_AllSpell" + IntToString(iCount);
	   sPRC_ArcSpell = "PRC_ArcSpell" + IntToString(iCount);
	   sPRC_DivSpell = "PRC_DivSpell" + IntToString(iCount);
	   SendMessageToPC(oPC, sPRC_AllSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_AllSpell)) + ". " +
	                        sPRC_ArcSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_ArcSpell)) + ". " +
	                        sPRC_DivSpell + " is " + IntToString(GetLocalInt(oPC, sPRC_DivSpell)) + ".");
	}
 	for (iCount = 1; iCount <= 30; iCount++)
	{
	   sVariable = "PRC_SneakLevel" + IntToString(iCount);
	   SendMessageToPC(oPC, sVariable + " is " + IntToString(GetLocalInt(oPC, sVariable)) + ".");
	}
	*/

}