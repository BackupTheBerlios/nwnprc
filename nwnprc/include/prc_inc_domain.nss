//::///////////////////////////////////////////////
//:: PRC Bonus Domains
//:: prc_inc_domain.nss
//:://////////////////////////////////////////////
//:: Handles all of the code for bonus domains.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.
//:: Created On: August 31st, 2005
//:://////////////////////////////////////////////


// Function returns the domain in the input slot. 
// A person can have a maximum of 5 bonus domains.
int GetBonusDomain(object oPC, int nSlot);

// Function will add a bonus domain to the stored list on the character.
void AddBonusDomain(object oPC, int nDomain);

// Uses the slot and level to find the appropriate spell, then casts it using ActionCastSpell
// It will also decrement a spell from that level
// If the domain does not have an appropriate spell for that level, an error message appears and nothing happens
void CastDomainSpell(object oPC, int nSlot, int nLevel);

// Takes the domain and spell level and uses it to find the appropriate spell.
// Right now it uses 2da reads on the domains.2da, although it could be scripted if desired.
int GetDomainSpell(int nDomain, int nLevel, object oPC);

// Takes the spell level, and returns the radial feat for that level.
// Used in case there is no spell of the appropriate level.
int SpellLevelToFeat(int nLevel);

// Will return the domain name as a string
// This is used to tell a PC what domains he has in what slot
string GetDomainName(int nDomain);

// This is the starter function, and fires from Enter and Levelup
// It checks all of the bonus domain feats, and gives the PC the correct domains
void CheckBonusDomains(object oPC);

// Returns the spell to be burned for CastDomainSpell
int GetBurnableSpell(object oPC, int nLevel);

#include "prc_inc_clsfunc"
#include "prc_getbest_inc"

//::///////////////////
//:: DOMAIN CONSTANTS 
//:: These constants are off by 1 to allow 0 to be the FALSE return value.
//::///////////////////

const int DOMAIN_AIR  		= 1;
const int DOMAIN_ANIMAL  	= 2;
const int DOMAIN_DEATH  	= 4;
const int DOMAIN_DESTRUCTION  	= 5;
const int DOMAIN_EARTH  	= 6;
const int DOMAIN_EVIL  		= 7;
const int DOMAIN_FIRE  		= 8;
const int DOMAIN_GOOD  		= 9;
const int DOMAIN_HEALING  	= 10;
const int DOMAIN_KNOWLEDGE  	= 11;
const int DOMAIN_MAGIC  	= 14;
const int DOMAIN_PLANT  	= 15;
const int DOMAIN_PROTECTION  	= 16;
const int DOMAIN_STRENGTH  	= 17;
const int DOMAIN_SUN  		= 18;
const int DOMAIN_TRAVEL  	= 19;
const int DOMAIN_TRICKERY  	= 20;
const int DOMAIN_WAR  		= 21;
const int DOMAIN_WATER  	= 22;
const int DOMAIN_DARKNESS  	= 31;
const int DOMAIN_STORM  	= 32;
const int DOMAIN_METAL  	= 33;
const int DOMAIN_PORTAL  	= 34;
const int DOMAIN_FORCE  	= 35;
const int DOMAIN_SLIME  	= 36;
const int DOMAIN_TYRANNY  	= 37;
const int DOMAIN_DOMINATION  	= 38;
const int DOMAIN_SPIDER  	= 39;
const int DOMAIN_UNDEATH  	= 40;
const int DOMAIN_TIME  		= 41;
const int DOMAIN_DWARF  	= 42;
const int DOMAIN_CHARM  	= 43;
const int DOMAIN_ELF  		= 44;
const int DOMAIN_FAMILY  	= 45;
const int DOMAIN_FATE  		= 46;
const int DOMAIN_GNOME  	= 47;
const int DOMAIN_ILLUSION  	= 48;
const int DOMAIN_HATRED  	= 49;
const int DOMAIN_HALFLING  	= 50;
const int DOMAIN_NOBILITY  	= 51;
const int DOMAIN_OCEAN  	= 52;
const int DOMAIN_ORC  		= 53;
const int DOMAIN_RENEWAL  	= 54;
const int DOMAIN_RETRIBUTION  	= 55;
const int DOMAIN_RUNE  		= 56;
const int DOMAIN_SPELLS  	= 57;
const int DOMAIN_SCALEYKIND 	= 58;
const int DOMAIN_BLIGHTBRINGER  = 59;

int GetBonusDomain(object oPC, int nSlot)
{
	string sName = "PRCBonusDomain" + IntToString(nSlot);
	// Return value in case there is nothing in the slot
	int nDomain = 0;
	nDomain = GetPersistantLocalInt(oPC, sName);
	
	return nDomain;
}


void AddBonusDomain(object oPC, int nDomain)
{
	// Loop through the domain slots to see if there is an open one.
	int nSlot = 1;
	int nTest = GetBonusDomain(oPC, nSlot);
	while (nTest > 0 && 5 >= nSlot)   
	{
		nSlot += 1;
		// If the test domain and the domain to be added are the same
		// shut down the function, since you don't want to add a domain twice.
		if (nTest == nDomain) 
		{
			FloatingTextStringOnCreature("You already have this domain as a bonus domain.", OBJECT_SELF, FALSE);
			return;
		}
		nTest = GetBonusDomain(oPC, nSlot);
	}
	// If you run out of slots, display message and end function
	if (nSlot > 5) 
	{
		FloatingTextStringOnCreature("You have more than 5 bonus domains, your last domain is lost.", OBJECT_SELF, FALSE);
		return;
	}

	// If we're here, we know we have an open slot, so we add the domain into it.
	string sName = "PRCBonusDomain" + IntToString(nSlot);
	SetPersistantLocalInt(oPC, sName, nDomain);
}

void CastDomainSpell(object oPC, int nSlot, int nLevel)
{
	int nDomain = GetBonusDomain(oPC, nSlot);
	int nSpell = GetDomainSpell(nDomain, nLevel, oPC);
	
	// Check to see if you can burn a spell of that slot or if the person has already
	// cast all of their level X spells for the day
	int nBurnSpell = GetBurnableSpell(oPC, nLevel);
	
	if (nBurnSpell == -1) //No spell left to burn? Can't heal! Tell the player that.
	{
	        FloatingTextStringOnCreature("You have no spells left to trade for a domain spell.", oPC, FALSE);
		return;
    	}
	
	// Burn the spell off, then cast the domain spell
	DecrementRemainingSpellUses(oPC, nBurnSpell);
	ActionCastSpell(nSpell);
}

int GetDomainSpell(int nDomain, int nLevel, object oPC)
{
	// The -1 on nDomains is to adjust from a base 1 to a base 0 system.
	string sSpell = Get2DACache("domains", "Level_" + IntToString(nLevel), (nDomain - 1));
	int nSpell;
	if (sSpell == "****")
	{
		FloatingTextStringOnCreature("You do not have a domain spell of that level.", OBJECT_SELF, FALSE);
		int nFeat = SpellLevelToFeat(nLevel);
		IncrementRemainingFeatUses(oPC, nFeat);
	}
	else
	{
		nSpell = StringToInt(sSpell);
	}
	
	return nSpell;
}

int SpellLevelToFeat(int nLevel)
{
	int nFeat;
	if (nLevel == 1) nFeat = FEAT_CAST_DOMAIN_LEVEL_ONE;
	else if (nLevel == 2) nFeat = FEAT_CAST_DOMAIN_LEVEL_TWO;
	else if (nLevel == 3) nFeat = FEAT_CAST_DOMAIN_LEVEL_THREE;
	else if (nLevel == 4) nFeat = FEAT_CAST_DOMAIN_LEVEL_FOUR;
	else if (nLevel == 5) nFeat = FEAT_CAST_DOMAIN_LEVEL_FIVE;
	else if (nLevel == 6) nFeat = FEAT_CAST_DOMAIN_LEVEL_SIX;
	else if (nLevel == 7) nFeat = FEAT_CAST_DOMAIN_LEVEL_SEVEN;
	else if (nLevel == 8) nFeat = FEAT_CAST_DOMAIN_LEVEL_EIGHT;
	else if (nLevel == 9) nFeat = FEAT_CAST_DOMAIN_LEVEL_NINE;
	
	return nFeat;
}

string GetDomainName(int nDomain)
{
	string sName = Get2DACache("domains", "Name", (nDomain - 1));
	sName = GetStringByStrRef(StringToInt(sName));
	
	return sName;
}

void CheckBonusDomains(object oPC)
{
	if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR)) 		AddBonusDomain(oPC, DOMAIN_AIR);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL)) 	AddBonusDomain(oPC, DOMAIN_ANIMAL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH)) 	AddBonusDomain(oPC, DOMAIN_DEATH);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION)) 	AddBonusDomain(oPC, DOMAIN_DESTRUCTION);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH)) 	AddBonusDomain(oPC, DOMAIN_EARTH);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL))		AddBonusDomain(oPC, DOMAIN_EVIL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE))		AddBonusDomain(oPC, DOMAIN_FIRE);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD))		AddBonusDomain(oPC, DOMAIN_GOOD);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING)) 	AddBonusDomain(oPC, DOMAIN_HEALING);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE)) 	AddBonusDomain(oPC, DOMAIN_KNOWLEDGE);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC)) 	AddBonusDomain(oPC, DOMAIN_MAGIC);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT)) 	AddBonusDomain(oPC, DOMAIN_PLANT);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION)) 	AddBonusDomain(oPC, DOMAIN_PROTECTION);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH)) 	AddBonusDomain(oPC, DOMAIN_STRENGTH);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN)) 		AddBonusDomain(oPC, DOMAIN_SUN);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL)) 	AddBonusDomain(oPC, DOMAIN_TRAVEL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY)) 	AddBonusDomain(oPC, DOMAIN_TRICKERY);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR)) 		AddBonusDomain(oPC, DOMAIN_WAR);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER)) 	AddBonusDomain(oPC, DOMAIN_WATER);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS)) 	AddBonusDomain(oPC, DOMAIN_DARKNESS);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM)) 	AddBonusDomain(oPC, DOMAIN_STORM);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL)) 	AddBonusDomain(oPC, DOMAIN_METAL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL)) 	AddBonusDomain(oPC, DOMAIN_PORTAL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE)) 	AddBonusDomain(oPC, DOMAIN_FORCE);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME)) 	AddBonusDomain(oPC, DOMAIN_SLIME);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY)) 	AddBonusDomain(oPC, DOMAIN_TYRANNY);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION)) 	AddBonusDomain(oPC, DOMAIN_DOMINATION);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER)) 	AddBonusDomain(oPC, DOMAIN_SPIDER);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH)) 	AddBonusDomain(oPC, DOMAIN_UNDEATH);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME))		AddBonusDomain(oPC, DOMAIN_TIME);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF)) 	AddBonusDomain(oPC, DOMAIN_DWARF);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM)) 	AddBonusDomain(oPC, DOMAIN_CHARM);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF)) 		AddBonusDomain(oPC, DOMAIN_ELF);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY)) 	AddBonusDomain(oPC, DOMAIN_FAMILY);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE))		AddBonusDomain(oPC, DOMAIN_FATE);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME)) 	AddBonusDomain(oPC, DOMAIN_GNOME);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION)) 	AddBonusDomain(oPC, DOMAIN_ILLUSION);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED)) 	AddBonusDomain(oPC, DOMAIN_HATRED);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING)) 	AddBonusDomain(oPC, DOMAIN_HALFLING);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY)) 	AddBonusDomain(oPC, DOMAIN_NOBILITY);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN)) 	AddBonusDomain(oPC, DOMAIN_OCEAN);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC)) 		AddBonusDomain(oPC, DOMAIN_ORC);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL)) 	AddBonusDomain(oPC, DOMAIN_RENEWAL);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION)) 	AddBonusDomain(oPC, DOMAIN_RETRIBUTION);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE)) 	AddBonusDomain(oPC, DOMAIN_RUNE);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS)) 	AddBonusDomain(oPC, DOMAIN_SPELLS);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND)) 	AddBonusDomain(oPC, DOMAIN_SCALEYKIND);
	if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER)) AddBonusDomain(oPC, DOMAIN_BLIGHTBRINGER);	
}

int GetBurnableSpell(object oPC, int nLevel)
{
	int nBurnableSpell = -1;

	if (nLevel == 1)	nBurnableSpell = GetBestL1Spell(oPC, nBurnableSpell);
	else if (nLevel == 2)	nBurnableSpell = GetBestL2Spell(oPC, nBurnableSpell);
	else if (nLevel == 3)	nBurnableSpell = GetBestL3Spell(oPC, nBurnableSpell);
	else if (nLevel == 4)	nBurnableSpell = GetBestL4Spell(oPC, nBurnableSpell);
	else if (nLevel == 5)	nBurnableSpell = GetBestL5Spell(oPC, nBurnableSpell);
	else if (nLevel == 6)	nBurnableSpell = GetBestL6Spell(oPC, nBurnableSpell);
	else if (nLevel == 7)	nBurnableSpell = GetBestL7Spell(oPC, nBurnableSpell);
	else if (nLevel == 8)	nBurnableSpell = GetBestL8Spell(oPC, nBurnableSpell);
	else if (nLevel == 9)	nBurnableSpell = GetBestL9Spell(oPC, nBurnableSpell);

	return nBurnableSpell;
}