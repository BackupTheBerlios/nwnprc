//::///////////////////////////////////////////////
//:: Astral Construct manifestation include
//:: psi_inc_ac_const
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 23.01.2005
//:://////////////////////////////////////////////

#include "spinc_common"
#include "psi_inc_psifunc"
#include "psi_inc_ac_const"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int TEMP_HENCH_COUNT = 150;


//////////////////////////////////////////////////
/* Structure definitions                        */
//////////////////////////////////////////////////

// A structure containing appearance references
struct ac_forms{
	int Appearance1, Appearance1Alt;
	int Appearance2, Appearance2Alt;
	int Appearance3, Appearance3Alt;
	int Appearance4, Appearance4Alt;
};

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

void DoAstralConstructCreation(object oManifester, location locTarget, int nMetaPsi, int nACLevel,
                               int nOptionFlags, int nResElemFlags, int nETchElemFlags, int nEBltElemFlags);
void DoDespawn(object oConstruct);

struct ac_forms GetAppearancessForLevel(int nLevel);
int GetAppearanceForConstruct(int nACLevel, int nOptionFlags, int nCheck);
int GetUseAltAppearances(int nOptionFlags);
string GetResRefForConstruct(int nACLevel, int nOptionFlags);
int GetHighestCraftSkillValue(object oCreature);


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////


// Summons the specified Astral Construct at the given location
// Handling of the flags (other than the Buff series) is done
// in the creature's OnSpawn eventscript
void DoAstralConstructCreation(object oManifester, location locTarget, int nMetaPsi, int nACLevel,
                               int nOptionFlags, int nResElemFlags, int nETchElemFlags, int nEBltElemFlags)
{
	// We need to make sure that we can add the new construct as henchman
	int nMaxHenchmen = GetMaxHenchmen();
	SetMaxHenchmen(TEMP_HENCH_COUNT);
	
	string sResRef = GetResRefForConstruct(nACLevel, nOptionFlags);
	object oConstruct = CreateObject(OBJECT_TYPE_CREATURE, sResRef, locTarget);
	AddHenchman(oManifester, oConstruct);
	
	// And set the max henchmen count back to original, so we won't mess up the module
	SetMaxHenchmen(nMaxHenchmen);
	
	// Set the timer on it. 1 round / level. Metapsionic Extend can be applied.
	float fDur = 6.0 * GetManifesterLevel(oManifester);
	      fDur = nMetaPsi == 2 && GetLocalInt(oManifester, "PsiMetaExtend") ? fDur * 2 : fDur;
	
	DelayCommand(fDur, DoDespawn(oConstruct));
	
	// Add the locals to the construct
	SetLocalInt(oConstruct, ASTRAL_CONSTRUCT_LEVEL,              nACLevel);
	SetLocalInt(oConstruct, ASTRAL_CONSTRUCT_OPTION_FLAGS,       nOptionFlags);
	SetLocalInt(oConstruct, ASTRAL_CONSTRUCT_RESISTANCE_FLAGS,   nResElemFlags);
	SetLocalInt(oConstruct, ASTRAL_CONSTRUCT_ENERGY_TOUCH_FLAGS, nETchElemFlags);
	SetLocalInt(oConstruct, ASTRAL_CONSTRUCT_ENERGY_BOLT_FLAGS,  nEBltElemFlags);
	
	
	// Do appearance switching
	int nCraft = GetHighestCraftSkillValue(oManifester);
	int nCheck = d20() + nCraft;
	
	int nAppearance = GetAppearanceForConstruct(nACLevel, nOptionFlags, nCheck);
	SetCreatureAppearanceType(oConstruct, nAppearance);
	
	// Do VFX
}


// A function to handle the AC's duration running out
// Some paranoia present to make sure nothing could accidentally
// make it permanent
void DoDespawn(object oConstruct)
{
	SetPlotFlag(oConstruct, FALSE);
	SetImmortal(oConstruct, FALSE);
	AssignCommand(oConstruct, SetIsDestroyable(TRUE, FALSE, FALSE));
	DelayCommand(0.1, DestroyObject(oConstruct));
}


struct ac_forms GetAppearancesForLevel(int nLevel)
{
	struct ac_forms toReturn;
	
	switch(nLevel)
	{
		case 1:
			toReturn.Appearance1     = APPEARANCE_TYPE_RAT;
			toReturn.Appearance1Alt  = 387; //Dire Rat
			
			toReturn.Appearance2     = APPEARANCE_TYPE_INTELLECT_DEVOURER;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_WAR_DEVOURER;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_PSEUDODRAGON;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_PSEUDODRAGON;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_FAERIE_DRAGON;
			toReturn.Appearance4Alt  = APPEARANCE_TYPE_FAERIE_DRAGON;
			
			return toReturn;
		case 2:
			toReturn.Appearance1     = APPEARANCE_TYPE_GARGOYLE;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_GARGOYLE;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_BAT_HORROR;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_HELMED_HORROR;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_ASABI_WARRIOR;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_LIZARDFOLK_WARRIOR_B;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_WERECAT;
			toReturn.Appearance4Alt  = APPEARANCE_TYPE_WERECAT;
			
			return toReturn;
		case 3:
			toReturn.Appearance1     = APPEARANCE_TYPE_FORMIAN_WORKER;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_FORMIAN_WORKER;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_FORMIAN_WARRIOR;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_FORMIAN_WARRIOR;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_FORMIAN_MYRMARCH;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_FORMIAN_MYRMARCH;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_FORMIAN_QUEEN;
			toReturn.Appearance4Alt  = APPEARANCE_TYPE_FORMIAN_QUEEN;
			
			return toReturn;
		case 4:
			toReturn.Appearance1     = 416; // Deep Rothe
			toReturn.Appearance1Alt  = 416;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_MANTICORE;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_MANTICORE;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_BASILISK;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_GORGON;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_DEVIL;
			toReturn.Appearance4Alt  = 468; // Golem, Demonflesh
			
			return toReturn;
		case 5:
			toReturn.Appearance1     = APPEARANCE_TYPE_GOLEM_FLESH;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_GOLEM_FLESH;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_GOLEM_STONE;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_GOLEM_STONE;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_GOLEM_CLAY;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_GOLEM_CLAY;
			
			toReturn.Appearance4     = 420; // Golem, Mithril
			toReturn.Appearance4Alt  = 420;
			
			return toReturn;
		case 6:
			toReturn.Appearance1     = APPEARANCE_TYPE_TROLL;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_TROLL;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_ETTERCAP;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_ETTERCAP;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_UMBERHULK;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_UMBERHULK;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_MINOTAUR_SHAMAN;
			toReturn.Appearance4Alt  = APPEARANCE_TYPE_MINOGON;
			
			return toReturn;
		case 7:
			toReturn.Appearance1     = APPEARANCE_TYPE_SPIDER_DIRE;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_SPIDER_DIRE;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_SPIDER_SWORD;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_SPIDER_SWORD;
			
			toReturn.Appearance3     = 446; // Drider, Female
			toReturn.Appearance3Alt  = 446;
			
			toReturn.Appearance4     = 407; // Drider, Chief
			toReturn.Appearance4Alt  = 407;
			
			return toReturn;
		case 8:
			toReturn.Appearance1     = APPEARANCE_TYPE_HOOK_HORROR;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_VROCK;
			
			toReturn.Appearance2     = 427; // Slaad, White
			toReturn.Appearance2Alt  = 427;
			
			toReturn.Appearance3     = APPEARANCE_TYPE_GREY_RENDER;
			toReturn.Appearance3Alt  = APPEARANCE_TYPE_GREY_RENDER;
			
			toReturn.Appearance4     = APPEARANCE_TYPE_GREY_RENDER;
			toReturn.Appearance4Alt  = APPEARANCE_TYPE_GREY_RENDER;
			
			return toReturn;
		case 9:
			toReturn.Appearance1     = APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER;
			toReturn.Appearance1Alt  = APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER;
			
			toReturn.Appearance2     = APPEARANCE_TYPE_GIANT_FROST_FEMALE;
			toReturn.Appearance2Alt  = APPEARANCE_TYPE_GIANT_FROST_FEMALE;
			
			toReturn.Appearance3     = 418; // Dragon, Shadow
			toReturn.Appearance3Alt  = 418;
			
			toReturn.Appearance4     = 471; // Mephisto, Normal
			toReturn.Appearance4Alt  = 471;
			
			return toReturn;
		
		default:
			WriteTimestampedLogEntry("Erroneous value for nLevel in GetAppearancessForLevel");
	}
	
	return toReturn;
}


int GetAppearanceForConstruct(int nACLevel, int nOptionFlags, int nCheck)
{
	int bUse2da = GetLocalInt(GetModule(), "UseAstralConstruct2da") != 0;
	int bUseAlt = GetUseAltAppearances(nOptionFlags);
	int nNum = nCheck < AC_APPEARANCE_CHECK_HIGH ?
	             nCheck < AC_APPEARANCE_CHECK_MEDIUM ?
	               nCheck < AC_APPEARANCE_CHECK_LOW ? 1
	               : 2
	             : 3
	           : 4;
	// If we use 2da, get the data from there
	if(bUse2da)
	{
		nNum += (nACLevel - 1) * 4 - 1;
		
		return StringToInt(Get2DACache("ac_appearances", bUseAlt ? "AltAppearance" : "NormalAppearance", nNum));
	}
	
	// We don't so get it from GetAppearancesForLevel
	
	struct ac_forms appearancelist = GetAppearancesForLevel(nACLevel);
	
	switch(nNum)
	{
		case 1: return bUseAlt ? appearancelist.Appearance1Alt : appearancelist.Appearance1;
		case 2: return bUseAlt ? appearancelist.Appearance2Alt : appearancelist.Appearance2;
		case 3: return bUseAlt ? appearancelist.Appearance3Alt : appearancelist.Appearance3;
		case 4: return bUseAlt ? appearancelist.Appearance4Alt : appearancelist.Appearance4;
		
		default:
			WriteTimestampedLogEntry("Erroneous value for nNum in GetAppearanceForConstruct");
	}
	
	return -1;
}


int GetUseAltAppearances(int nOptionFlags)
{          // Buff series
	return nOptionFlags & ASTRAL_CONSTRUCT_OPTION_BUFF            ||
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_IMP_BUFF        ||
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_EXTRA_BUFF      ||
	       // Deflection series
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_DEFLECTION      ||
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_HEAVY_DEFLECT   ||
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_EXTREME_DEFLECT ||
	       // Damage Reduction Series
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_IMP_DAM_RED     ||
	       nOptionFlags & ASTRAL_CONSTRUCT_OPTION_EXTREME_DAM_RED;
}


string GetResRefForConstruct(int nACLevel, int nOptionFlags)
{
	string sResRef = "psi_astral_con" + IntToString(nACLevel);
	string sSuffix;
	
	// Check whether we need a resref with buff applied
	if(nOptionFlags & ASTRAL_CONSTRUCT_OPTION_BUFF)
		sSuffix += "a";
	else if(nOptionFlags & ASTRAL_CONSTRUCT_OPTION_IMP_BUFF)
		sSuffix += "b";
	else if(nOptionFlags & ASTRAL_CONSTRUCT_OPTION_EXTRA_BUFF)
		sSuffix += "c";
	
	return sResRef + sSuffix;
}


int GetHighestCraftSkillValue(object oCreature)
{
	int nArmor  = GetSkillRank(SKILL_CRAFT_ARMOR, oCreature);
	int nTrap   = GetSkillRank(SKILL_CRAFT_TRAP, oCreature);
	int nWeapon = GetSkillRank(SKILL_CRAFT_WEAPON, oCreature);
	
	return nArmor > nTrap ?
	        nArmor > nWeapon ? nArmor : nWeapon
	        : nTrap > nWeapon ? nTrap : nWeapon;
}