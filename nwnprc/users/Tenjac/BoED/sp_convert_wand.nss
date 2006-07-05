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

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	object oTargetWand = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	
	int nOrigCharge = GetItemCharges(oTargetWand);
	int nNewCharge;
	object oNewWand;
	
	//Get spell level
	int nLevel = ;
	
	//Copy item to hide
		
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
	
	//Schedule deletion
		
	SPSetSchool();
}

	
	
	
	


