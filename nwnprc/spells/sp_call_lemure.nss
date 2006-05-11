//::///////////////////////////////////////////////
//:: Name      Call Lemure Horde
//:: FileName  sp_call_lemure.nss
//:://////////////////////////////////////////////
/**@file Call Lemure Horde 
Conjuration (Calling) [Evil] 
Level: Mortal Hunter 4, Sor/Wiz 5 
Components: V S, Soul 
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Effect: 3d4 1emures 
Duration: One year 
Saving Throw: None 
Spell Resistance: No

The caster calls 3d4 lemures from the Nine Hells to 
where he is, offering them the soul that he has
prepared. In exchange, they will serve the caster
for one year as guards, slaves, or whatever else
he needs them for. They are non­-intelligent, 
so the caster cannot give them more complicated
tasks than can be described in about five words.

No matter how many times the caster casts this 
spell, he can control no more than 2 HD worth 
of fiends per caster level. If he exceeds this
number, all the newly called creatures fall under 
the caster's control, and any excess from previous
castings become uncontrolled. The caster chooses 
which creatures to release.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


int GetControlledFiendHD(object oPC);

#include "spinc_common"

voide main()
{
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMaxHDControlled = nCasterLevel * 2;
	int nTotalControlled = GetControlledFiendHD(oPC);
	int nLemures = d4(3);
	int nCounter = nLemures;
	object oLemure;
	location lLoc = GetSpellTargetLocation();
	
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	//determine how many to take control of 
	int nLemuresToControl = (nMaxHDControlled - nTotalControlled);
	
	//Summon loop
	while(nCounter > 0)
	{
		oLemure = CreateObject(OBJECT_TYPE_CREATURE, "nw_lemure", lLoc, FALSE);
		{
			if(nLemuresToControl > 0)
			{
				//Get original max henchmen
				int nMax = GetMaxHenchmen();
				
				//Set new max henchmen high
				SetMaxHenchmen(150);
				
				//Make henchman
				AddHenchman(oPC, oLemure);
				
				//Restore original max henchmen
				SetMaxHenchmen(nMax);
				
				//decrement nDretches to Control
				nLemuresToControl--;
			}			
			nCounter--;			
		}
	}
	SPEvilShift(oPC);
	SPSetSchool();
}

int GetControlledFiendHD(object oPC)
{
	int nHDControlled;
	int nAssociate = 1;
	int nType;
	object oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nAssociate)
	
	while(GetIsObjectValid(oAssociate))
	{
		nType = MyPRCGetRacialType(oAssociate);
		
		//if a fiend, count HD
		if((nType == RACIAL_TYPE_OUTSIDER) && GetAlignmentGoodEvil(oAssociate == ALIGNMENT_EVIL))
		{
			nHDControlled += GetHitDice(oAssociate)
		}
		
		//increment nAssociate
		nAssociate++;
		
		oAssocitate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nAssociate)
	}
	return nHDControlled;
}