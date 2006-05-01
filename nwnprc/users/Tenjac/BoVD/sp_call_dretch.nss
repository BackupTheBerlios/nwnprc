//::///////////////////////////////////////////////
//:: Name      Call Dretch Horde
//:: FileName  sp_call_dretch.nss
//:://////////////////////////////////////////////
/**@file Call Dretch Horde 
Conjuration (Calling) [Evil] 
Level: Demonologist 3, Mortal Hunter 4, Sor/Wiz 5 
Components: V S, Soul 
Casting Time: 1 minute 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: 2d4 dretches
Duration: One year 
Saving Throw: None 
Spell Resistance: No

The caster calls 2d4 dretches from the Abyss to where
she is, offering them the soul that she has prepared.
In exchange, they will serve the caster for one year
as guards, slaves, or whatever else she needs them
for. They are profoundly stupid, so the caster cannot
give them more complicated tasks than can be described
in about ten words.

No matter how many times the caster casts this spell, 
she can control no more than 2 HD worth of fiends per
caster level. If she exceeds this number, all the newly
called creatures fall under the caster's control, and 
any excess from previous castings become uncontrolled.
The caster chooses which creatures to release.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

int GetTotalAssociateHD(object oPC);

#include "spinc_common"

voide main()
{
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMaxHDControlled = nCasterLevel * 2;
	int nTotalControlled = GetTotalAssociateHD(oPC);
	int nDretches = d4(2);
	int nCounter = nDretches;
	
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	//Summon loop
	while(nCounter > 0)
	{
		
		nCounter--;
	}
	
	//If you can't control them all
	if((nDretches * 2) > nMaxHDControlled - nTotalControlled)
	{
		//drop extras
		
	}
	
	
	
	SPEvilShift(oPC);
	SPSetSchool();
}

int GetTotalAssociateHD(object oPC)
{
	int nHDControlled;
	int nAssociate = 1;
	object oAssociate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nAssociate)
	
	while(GetIsObjectValid(oAssociate))
	{
		nHDControlled += GetHitDice(oAssociate)
		
		//increment nAssociate
		nAssociate++;
		
		oAssocitate = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, nAssociate)
	}
	return nHDControlled;
}
	
	