//::///////////////////////////////////////////////
//:: Knight - Shield Block
//:: prc_knght_block.nss
//:://////////////////////////////////////////////
//:: Bonus with the shield vs certain monsters
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 1, 2007
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	int nRace = MyPRCGetRacialType(oTarget);
	int nClass = GetLevelByClass(CLASS_TYPE_KNIGHT, oPC);
	int nBonus = 1;
	
	// Bonus grows at these levels.
	if (nClass >= 20) nBonus = 3;
	else if (nClass >= 11) nBonus = 2;
	
	effect eShield = EffectACIncrease(nBonus);

	eShield = VersusRacialTypeEffect(eShield, nRace);
	
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oPC, 6.0);
}
