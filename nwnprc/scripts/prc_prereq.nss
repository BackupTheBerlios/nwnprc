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

void ArcSpell(object oPC, int iArcSpell)
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
	}
	if (iArcSpell >= 2)
	{
	SetLocalInt(oPC, "PRC_ArcSpell2", 0);
	}
	if (iArcSpell >= 3)
	{
	SetLocalInt(oPC, "PRC_ArcSpell3", 0);
	}
	if (iArcSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_ArcSpell4", 0);
	}
	if (iArcSpell >= 5)
	{
	SetLocalInt(oPC, "PRC_ArcSpell5", 0);
	}
	if (iArcSpell >= 6)
	{
	SetLocalInt(oPC, "PRC_ArcSpell6", 0);
	}
	if (iArcSpell >= 7)
	{
	SetLocalInt(oPC, "PRC_ArcSpell7", 0);
	}
	if (iArcSpell >= 8)
	{
	SetLocalInt(oPC, "PRC_ArcSpell8", 0);
	}
	if (iArcSpell >= 9)
	{
	SetLocalInt(oPC, "PRC_ArcSpell9", 0);
	}

SendMessageToPC(oPC, "You can cast Arcane spells of level " + IntToString(iArcSpell));

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



void DivSpell(object oPC, int iDivSpell)
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
	}
	if (iDivSpell >= 2)
	{
	SetLocalInt(oPC, "PRC_DivSpell2", 0);
	}
	if (iDivSpell >= 3)
	{
	SetLocalInt(oPC, "PRC_DivSpell3", 0);
	}
	if (iDivSpell >= 4)
	{
	SetLocalInt(oPC, "PRC_DivSpell4", 0);
	}
	if (iDivSpell >= 5)
	{
	SetLocalInt(oPC, "PRC_DivSpell5", 0);
	}
	if (iDivSpell >= 6)
	{
	SetLocalInt(oPC, "PRC_DivSpell6", 0);
	}
	if (iDivSpell >= 7)
	{
	SetLocalInt(oPC, "PRC_DivSpell7", 0);
	}
	if (iDivSpell >= 8)
	{
	SetLocalInt(oPC, "PRC_DivSpell8", 0);
	}
	if (iDivSpell >= 9)
	{
	SetLocalInt(oPC, "PRC_DivSpell9", 0);
	}

SendMessageToPC(oPC, "You can cast Divine spells of level " + IntToString(iDivSpell));

}

void Hathran(object oPC)
{

    SetLocalInt(oPC, "PRC_Female", 1);

    if (GetGender(oPC) == GENDER_FEMALE)
    {
    SetLocalInt(oPC, "PRC_Female", 0);
    }

}

void main()
{
        //Declare Major Variables
        object oPC = GetPCLevellingUp();
        int iArcSpell;
        int iDivSpell;

ArcSpell(oPC, iArcSpell);
DivSpell(oPC, iDivSpell);
Hathran(oPC);

}