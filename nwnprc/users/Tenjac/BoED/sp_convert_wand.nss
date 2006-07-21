//::///////////////////////////////////////////////
//:: Name      Convert Wand
//:: FileName  sp_convert_wand.nss
//:://////////////////////////////////////////////
/**@file Convert Wand
Transmutation 
Level: Clr 5 
Components: V, S 
Casting Time: 1 standard action 
Range: Touch
Target: Wand touched 
Duration: 1 minute/level
Saving Throw: None 
Spell Resistance: No

This spell temporarily transforms a magic wand of 
any type into a healing wand with the same number 
of charges remaining. At the end of the spell's 
duration, the wand's original effect is restored,
and any charges that were depleted remain so. The 
spell level of the wand determines how powerful a
healing instrument the wand becomes: 

Spell Level   New Wand Type

 
 1st          Wand of cure light wounds 
 
 2nd          Wand of cure moderate wounds
 
 3rd          Wand of cure serious wounds
 
 4th          Wand of cure critical wounds
 

For example, a 10th-level cleric can transform a wand 
of lightning bolt (3rd­level spell) into a wand of 
cure serious wounds for 10 minutes.

Author:    Tenjac
Created:   7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void WandCounter(object oPC, object oSkin, object oNewWand, int nCounter);

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oTargetWand = GetSpellTargetObject();
	object oSkin = GetPCSkin(oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	
	int nOrigCharge = GetItemCharges(oTargetWand);
	object oNewWand;
		
	//Get spell level
	itemproperty ipTest = GetFirstItemProperty(oTargetWand);
		
	while(GetIsItemPropertyValid(ipTest))
	{
		if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
		{ 	
			//Get row
			string sRow = IntToString(GetItemPropertySubType(ipTest));
			
			//Get spell level
			int nLevel = Get2daString("iprp_spells", "InnateLvl", sRow);
			break;
		}
		ipTest = GetNextItemProperty(oTargetWand);
	}
	
	//Copy item to hide
	oNewWand = CopyObject(oTargetWand, GetLocation(oSkin), oSkin, "ConvertedWand");
			
	//Destroy old
	DestroyObject(oTargetWand);
	
	//Determine wand to create
	switch(nLevel)
	{
		case 1: oNewWand = CreateItemOnObject(" ", oPC, 1);
		        break;
		
		case 2: oNewWand = CreateItemOnObject(" ", oPC, 1);
		        break;
		
		case 3: oNewWand = CreateItemOnObject(" ", oPC, 1);
		        break;
		
		case 4: oNewWand = CreateItemOnObject(" ", oPC, 1);
		        break;
		
		default: break;
	}
		
	int nCounter = FloatToInt(fDur) / 6;
	WandCounter(oPC, oSkin, oNewWand, nCounter);
		
	SPSetSchool();
}

void WandCounter(object oPC, object oSkin, object oNewWand, int nCounter)
{
	if(nCounter < 1)
	{
		//Get current charges
		int nNewCharge = GetItemCharges(oNewWand);
		
		//Get copied wand
		object oCopied = GetItemPossessedBy(oSkin, "ConvertedWand")
		
		//Copy wand back over
		object oOldWand = CopyObject(oCopied, GetLocation(oPC), oPC);
		
		//Destroy item on hide
		DestroyObject(oCopied);
		
		//Set charges
		SetItemCharges(oOldWand, nNewCharge);		
	}
	
	else
	{
		nCounter--;
		DelayCommand(6.0f, WandCounter(oPC, oSkin, oNewWand, nCounter));
	}
}
		
	
	


