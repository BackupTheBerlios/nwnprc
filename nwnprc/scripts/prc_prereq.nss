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
#include "soul_inc"


int Bard(object oPC)
{
        int iBard = GetLevelByClass(CLASS_TYPE_BARD, oPC);
        int iCha = GetAbilityScore(oPC, ABILITY_CHARISMA);
	int iBSpell;


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

	if (iCha < iBSpell)
	{
	iBSpell = iCha;
	} 

	return iBSpell;
}

int ArcSpell(object oPC, int iArcSpell)
{

	SetLocalInt(oPC, "PRC_ArcSpell1", 1);
	SetLocalInt(oPC, "PRC_ArcSpell2", 1);
	SetLocalInt(oPC, "PRC_ArcSpell3", 1);
	SetLocalInt(oPC, "PRC_ArcSpell4", 1);
	SetLocalInt(oPC, "PRC_ArcSpell5", 1);
	SetLocalInt(oPC, "PRC_ArcSpell6", 1);
	SetLocalInt(oPC, "PRC_ArcSpell7", 1);
	SetLocalInt(oPC, "PRC_ArcSpell8", 1);
	SetLocalInt(oPC, "PRC_ArcSpell9", 1);


	//A basic check to see what their primary class is
        int iSorc = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
        int iWiz = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
        int iCha = GetAbilityScore(oPC, ABILITY_CHARISMA);
        int iInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);


        iArcSpell = iWiz;
        
        if (iSorc > iWiz)
        {
        iArcSpell = iSorc - 1;
        }

	//Checks to see what level of spells they can cast
        iArcSpell += GetLevelByClass(CLASS_TYPE_ARCHMAGE, oPC)
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
        + (GetLevelByClass(CLASS_TYPE_SPELLSWORD, oPC) + 1) / 2;

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
	int iBSpell = Bard(oPC);
	if (iBSpell > iArcSpell)
	{
	iArcSpell = iBSpell;
	}

	//Finally, set the variables.
	if (iArcSpell >= 1)
	{
	SetLocalInt(oPC, "PRC_ArcSpell1", 0);
	SetLocalInt(oPC, "PRC_AllSpell1", 0);
	}
	if (iArcSpell >= 2)
	{
	SetLocalInt(oPC, "PRC_ArcSpell2", 0);
	SetLocalInt(oPC, "PRC_AllSpell2", 0);
	}
	if (iArcSpell >= 3)
	{
	SetLocalInt(oPC, "PRC_ArcSpell3", 0);
	SetLocalInt(oPC, "PRC_AllSpell3", 0);
	}
	if (iArcSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_ArcSpell4", 0);
	SetLocalInt(oPC, "PRC_AllSpell4", 0);
	}
	if (iArcSpell >= 5)
	{
	SetLocalInt(oPC, "PRC_ArcSpell5", 0);
	SetLocalInt(oPC, "PRC_AllSpell5", 0);
	}
	if (iArcSpell >= 6)
	{
	SetLocalInt(oPC, "PRC_ArcSpell6", 0);
	SetLocalInt(oPC, "PRC_AllSpell6", 0);
	}
	if (iArcSpell >= 7)
	{
	SetLocalInt(oPC, "PRC_ArcSpell7", 0);
	SetLocalInt(oPC, "PRC_AllSpell7", 0);
	}
	if (iArcSpell >= 8)
	{
	SetLocalInt(oPC, "PRC_ArcSpell8", 0);
	SetLocalInt(oPC, "PRC_AllSpell8", 0);
	}
	if (iArcSpell >= 9)
	{
	SetLocalInt(oPC, "PRC_ArcSpell9", 0);
	SetLocalInt(oPC, "PRC_AllSpell9", 0);
	}

SendMessageToPC(oPC, "You can cast Arcane spells of level " + IntToString(iArcSpell));

return iArcSpell;

}


int RanPal(object oPC)
{
        int iRanger = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
        int iPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
        int iWis = GetAbilityScore(oPC, ABILITY_WISDOM);
	int iRanPal;


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


	if (iWis < iRanPal)
	{
	iRanPal = iWis;
	} 

	return iRanPal;
}



int DivSpell(object oPC, int iDivSpell)
{

	SetLocalInt(oPC, "PRC_DivSpell1", 1);
	SetLocalInt(oPC, "PRC_DivSpell2", 1);
	SetLocalInt(oPC, "PRC_DivSpell3", 1);
	SetLocalInt(oPC, "PRC_DivSpell4", 1);
	SetLocalInt(oPC, "PRC_DivSpell5", 1);
	SetLocalInt(oPC, "PRC_DivSpell6", 1);
	SetLocalInt(oPC, "PRC_DivSpell7", 1);
	SetLocalInt(oPC, "PRC_DivSpell8", 1);
	SetLocalInt(oPC, "PRC_DivSpell9", 1);

	//Variables
        int iDruid = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
        int iCler = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
        int iWis = GetAbilityScore(oPC, ABILITY_WISDOM);



        iDivSpell = iCler;

       	//A basic check to see what their primary class is
        if (iDruid > iCler)
        {
        iDivSpell = iDruid;
        }


	//Checks to see what level of spells they can cast
        iDivSpell += GetLevelByClass(CLASS_TYPE_DIVESA, oPC)
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
	int iRanPal = RanPal(oPC);
	if (iRanPal > iDivSpell)
	{
	iDivSpell = iRanPal;
	}


	//Finally, set the variables.
	if (iDivSpell >= 1)
	{
	SetLocalInt(oPC, "PRC_DivSpell1", 0);
	SetLocalInt(oPC, "PRC_AllSpell1", 0);
	}
	if (iDivSpell >= 2)
	{
	SetLocalInt(oPC, "PRC_DivSpell2", 0);
	SetLocalInt(oPC, "PRC_AllSpell2", 0);
	}
	if (iDivSpell >= 3)
	{
	SetLocalInt(oPC, "PRC_DivSpell3", 0);
	SetLocalInt(oPC, "PRC_AllSpell3", 0);
	}
	if (iDivSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_DivSpell4", 0);
	SetLocalInt(oPC, "PRC_AllSpell4", 0);
	}
	if (iDivSpell >= 5)
	{
	SetLocalInt(oPC, "PRC_DivSpell5", 0);
	SetLocalInt(oPC, "PRC_AllSpell5", 0);
	}
	if (iDivSpell >= 6)
	{
	SetLocalInt(oPC, "PRC_DivSpell6", 0);
	SetLocalInt(oPC, "PRC_AllSpell6", 0);
	}
	if (iDivSpell >= 7)
	{
	SetLocalInt(oPC, "PRC_DivSpell7", 0);
	SetLocalInt(oPC, "PRC_AllSpell7", 0);
	}
	if (iDivSpell >= 8)
	{
	SetLocalInt(oPC, "PRC_DivSpell8", 0);
	SetLocalInt(oPC, "PRC_AllSpell8", 0);
	}
	if (iDivSpell >= 9)
	{
	SetLocalInt(oPC, "PRC_DivSpell9", 0);
	SetLocalInt(oPC, "PRC_AllSpell9", 0);
	}

SendMessageToPC(oPC, "You can cast Divine spells of level " + IntToString(iDivSpell));

return iDivSpell;

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
	SetLocalInt(oPC, "PRC_PrereqSOL", 1);

	if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) 
	{  
		if (iCleric)
		{
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

void main()
{
        //Declare Major Variables
        object oPC = GetPCLevellingUp();
        int iArcSpell;
        int iDivSpell;

	SetLocalInt(oPC, "PRC_AllSpell1", 1);
	SetLocalInt(oPC, "PRC_AllSpell2", 1);
	SetLocalInt(oPC, "PRC_AllSpell3", 1);
	SetLocalInt(oPC, "PRC_AllSpell4", 1);
	SetLocalInt(oPC, "PRC_AllSpell5", 1);
	SetLocalInt(oPC, "PRC_AllSpell6", 1);
	SetLocalInt(oPC, "PRC_AllSpell7", 1);
	SetLocalInt(oPC, "PRC_AllSpell8", 1);
	SetLocalInt(oPC, "PRC_AllSpell9", 1);


	iArcSpell = ArcSpell(oPC, iArcSpell);
	iDivSpell = DivSpell(oPC, iDivSpell);

	Hathran(oPC);
	Tempest(oPC);
	KOTC(oPC);
	ManAtArms(oPC);
	SOL(oPC);
	Shadowlord(oPC, iArcSpell);
	Shifter(oPC, iArcSpell, iDivSpell);
}