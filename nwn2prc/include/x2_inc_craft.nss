//::///////////////////////////////////////////////
//:: x2_inc_craft
//:: Copyright (c) 2003 Bioare Corp.
//:://////////////////////////////////////////////
/*

    Central include for crafting feat and
    crafting skill system.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-05-09
//:: Last Updated On: 2003-10-14
//:://////////////////////////////////////////////
// ChazM 5/10/06 - Removed XP costs.  Did anyone really like XP costs?
// ChazM 5/23/06 - added AppendSpellToName().  Updated potion and wand creation to use it.
// ChazM 5/24/06 - Updated AppendSpellToName()
// ChazM 11/6/06 - Modified CIGetSpellInnateLevel() to instead get the caster level, Added 
//				MakeItemUseableByClassesWithSpellAccess() and helper functions used in CICraftCraftWand()
// ChazM 11/7/06 - Calculate spell level based on caster class and spells.2da entries, Changed 0 level spells to 
//				cost half of first level spells, reorganized some sections, replaced string refs w/ constants, 
//				fixed SPELLS_WIZ_SORC_LEVEL_COL

//--------------------------------------------------------------------
// Structs
//--------------------------------------------------------------------
struct craft_struct
{
    int    nRow;
    string sResRef;
    int    nDC;
    int    nCost;
    string sLabel;
};

struct craft_receipe_struct
{
    int nMode;
    object oMajor;
    object oMinor;
};

//--------------------------------------------------------------------
// Constants
//--------------------------------------------------------------------
// Item Creation string refs

const int STR_REF_IC_SPELL_TO_HIGH_FOR_WAND 		= 83623;
const int STR_REF_IC_SPELL_TO_HIGH_FOR_POTION 		= 76416;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_POTION	= 83450;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_SCROLL	= 83451;
const int STR_REF_IC_SPELL_RESTRICTED_FOR_WAND		= 83452;
const int STR_REF_IC_MISSING_REQUIRED_FEAT			= 40487;

const int STR_REF_IC_INSUFFICIENT_GOLD				= 3786;
const int STR_REF_IC_INSUFFICIENT_XP				= 3785;

const int STR_REF_IC_SUCCESS						= 8502;
const int STR_REF_IC_FAILED							= 76417;
const int STR_REF_IC_DISABLED						= 83612;
const int STR_REF_IC_ITEM_USE_NOT_ALLOWED			= 83373;


const string  X2_CI_CRAFTSKILL_CONV ="x2_p_craftskills";

// Brew Potion related Constants

const int     X2_CI_BREWPOTION_FEAT_ID        = 944;                    // Brew Potion feat simulation
//const int     X2_CI_BREWPOTION_MAXLEVEL       = 3;                      // Max Level for potions
//const int     X2_CI_BREWPOTION_COSTMODIFIER   = 50;                     // gp Brew Potion XPCost Modifier

const string  X2_CI_BREWPOTION_NEWITEM_RESREF = "x2_it_pcpotion";       // ResRef for new potion item

// Scribe Scroll related constants
const int     X2_CI_SCRIBESCROLL_FEAT_ID        = 945;
//const int     X2_CI_SCRIBESCROLL_COSTMODIFIER   = 25;                 // Scribescroll Cost Modifier
const string  X2_CI_SCRIBESCROLL_NEWITEM_RESREF = "x2_it_pcscroll";   // ResRef for new scroll item

// Craft Wand related constants
const int     X2_CI_CRAFTWAND_FEAT_ID        = 946;
//const int     X2_CI_CRAFTWAND_MAXLEVEL       = 4;
//const int     X2_CI_CRAFTWAND_COSTMODIFIER   = 750;
const string  X2_CI_CRAFTWAND_NEWITEM_RESREF = "x2_it_pcwand";
const int     X2_CI_CRAFTSTAFF_FEAT_ID        = 2928;
const int     X2_CI_CRAFTSTAFF_EPIC_FEAT_ID        = 3491;
//const string  X2_CI_CRAFTSTAFF_NEWITEM_RESREF = "x2_it_pcwand";

// 2da for the craftskills
const string X2_CI_CRAFTING_WP_2DA 		= "des_crft_weapon" ;
const string X2_CI_CRAFTING_AR_2DA 		= "des_crft_armor" ;
const string X2_CI_CRAFTING_MAT_2DA 	= "des_crft_mat";


// spells 2da
const string SPELLS_2DA 				= "spells";			// 2da
const int SPELLS_ROW_COUNT				= 1008; 			// number of rows in the spells table.
const string SPELLS_NAME_COL 			= "Name";			// str ref of spell name
const string SPELLS_DESC_COL 			= "SpellDesc";		// str ref of spell description
const string SPELLS_INNATE_LEVEL_COL 	= "Innate";			// Innate level of spell
const string SPELLS_BARD_LEVEL_COL 		= "Bard";			// Bard spell level
const string SPELLS_CLERIC_LEVEL_COL 	= "Cleric";			// Cleric spell level
const string SPELLS_DRUID_LEVEL_COL 	= "Druid";			// Druid spell level
const string SPELLS_PALADIN_LEVEL_COL 	= "Paladin";		// Paladin spell level
const string SPELLS_RANGER_LEVEL_COL 	= "Ranger";			// Ranger spell level
const string SPELLS_WIZ_SORC_LEVEL_COL 	= "Wiz_Sorc";		// Wizard and Sorceror spell level
const string SPELLS_WARLOCK_LEVEL_COL 	= "Warlock";		// Warlock spell level

// 2da for matching spells to properties
const string X2_CI_CRAFTING_SP_2DA = "des_crft_spells" ;
// Base custom token for item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_CTOKENBASE = 13220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_DC_CTOKENBASE = 14220;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_CRAFTINGSKILL_GP_CTOKENBASE = 14320;

// Base custom token for DC item modification conversations (do not change unless you want to change the conversation too)
const int     X2_CI_MODIFYARMOR_GP_CTOKENBASE = 14420;

//How many items per 2da row in X2_IP_CRAFTING_2DA, do not change>4 until you want to create more conversation condition scripts as well
const int     X2_CI_CRAFTING_ITEMS_PER_ROW = 5;

// name of the scroll 2da
const string  X2_CI_2DA_SCROLLS = "des_crft_scroll";

const int X2_CI_CRAFTMODE_INVALID   = 0;
const int X2_CI_CRAFTMODE_CONTAINER = 1; // no longer used, but left in for the community to reactivate
const int X2_CI_CRAFTMODE_BASE_ITEM  = 2;
const int X2_CI_CRAFTMODE_ASSEMBLE = 3;

const int X2_CI_MAGICTYPE_INVALID = 0;
const int X2_CI_MAGICTYPE_ARCANE  = 1;
const int X2_CI_MAGICTYPE_DIVINE  = 2;

const int X2_CI_MODMODE_INVALID = 0;
const int X2_CI_MODMODE_ARMOR = 1;
const int X2_CI_MODMODE_WEAPON = 2;

// Runecrafting constants
const int PRC_RUNE_BASECOST        = 0;
const int PRC_RUNE_CHARGES         = 1;
const int PRC_RUNE_PERDAY          = 2;
const int PRC_RUNE_MAXCHARGES      = 3;
const int PRC_RUNE_MAXUSESPERDAY   = 4;
//--------------------------------------------------------------------
// Prototypes
//--------------------------------------------------------------------
// *  Returns the innate level of a spell. If bDefaultZeroToOne is given
// *  Level 0 spell will be returned as level 1 spells
int   CIGetSpellInnateLevel(int nSpellID, int bDefaultZeroToOne = FALSE);

string GetClassSpellLevelColumn(int iClass);
int GetSpellLevelForClass(int iSpell, int iClass);
int IsOnSpellList(int iSpell, int iClass);
void MakeItemUseableByClass(int iClassType, object oItem);
void MakeItemUseableByClassesWithSpellAccess(int iSpell, object oItem);

// *  Returns TRUE if an item is a Craft Base Item
// *  to be used in spellscript that can be cast on items - i.e light
int   CIGetIsCraftFeatBaseItem( object oItem );

// *******************************************************
// ** Craft Checks
// *  Checks if the last spell cast was used to brew potion and will do the brewing process.
// *  Returns TRUE if the spell was indeed used to brew a potion (regardless of the actual outcome of the brewing process)
// *  Meant to be used in spellscripts only
int   CICraftCheckBrewPotion(object oSpellTarget, object oCaster);

// *  Checks if the last spell cast was used to scribe a scroll and handles the scribe scroll process
// *  Returns TRUE if the spell was indeed used to scribe a scroll (regardless of the actual outcome)
// *  Meant to be used in spellscripts only
int   CICraftCheckScribeScroll(object oSpellTarget, object oCaster);

int CICraftCheckCraftWand(object oSpellTarget, object oCaster);

// *******************************************************
// ** Craft!
// *   Create a new potion item based on the spell nSpellID  on the creator
object CICraftBrewPotion(object oCreator, int nSpellID );

// *   Create a new scroll item based on the spell nSpellID on the creator
object CICraftScribeScroll(object oCreator, int nSpellID);

// *   Create a new wand item based on the spell nSpellID on the creator
object CICraftCraftWand(object oCreator, int nSpellID );


// *  Checks if the caster intends to use his item creation feats and
// *  calls appropriate item creation subroutine if conditions are met (spell cast on correct item, etc).
// *  Returns TRUE if the spell was used for an item creation feat
int   CIGetSpellWasUsedForItemCreation(object oSpellTarget);

// This function checks whether Inscribe Rune is turned on
// and if so, deducts the appropriate experience and gold
// then creates the rune in the caster's inventory.
// This will also cause the spell to fail if turned on.
int InscribeRune();




// * Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// * If oContainer is specified, the item will be created there.
// * Throwing weapons are created with stack sizes of 10, ammo with 20
// *  oPC       - The player crafting
// *  nSkill    - SKILL_CRAFT_WEAPON or SKILL_CRAFT_ARMOR,
// *  sResRef   - ResRef of the item to be crafted
// *  nDC       - DC to beat to succeed
// *  oContainer - if a container is specified, create item inside
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID);

// *  Returns TRUE if a spell is prevented from being used with one of the crafting feats
int   CIGetIsSpellRestrictedFromCraftFeat(int nSpellID, int nFeatID);

// *  Return craftitemstructdata
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo);

// Appends the spell name to the object's name
void AppendSpellToName(object oObject, int nSpellID);

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "x2_inc_itemprop"
#include "x2_inc_switches"
//#include "inc_utility"
#include "prc_inc_newip"
#include "prc_inc_spells"
#include "ginc_debug"

//////////////////////////////////////////////////
/* Function definitions                         */
//////////////////////////////////////////////////
// *  Returns the innate level of a spell. If bDefaultZeroToOne is given
// *  Level 0 spell will be returned as level 1 spells
int   CIGetSpellInnateLevel(int nSpellID, int bDefaultZeroToOne = FALSE)
{
    //int nRet = StringToInt(Get2DAString(X2_CI_CRAFTING_SP_2DA, "Level", nSpellID));
	// Instead of using innate level (a single level always used for a spell) we now use actual level.
		
	// The level of a spell is dependent on what class casts it.  For example
	// Dominate Person is level 5 when cast by Wizard or Sorceror, but 4th level
	// when cast by a Bard.  The spell can't be cast by any other class.
   	int nRet = GetSpellLevel(nSpellID);
	//int nClass = GetLastSpellCastClass();
   	//int nRet = GetSpellLevelForClass(nSpellID, nClass);
	
	//PrettyDebug ("CIGetSpellInnateLevel: For Spell " + IntToString(nSpellID) + " with last spell clast class of " +
	//			 IntToString(nClass) + " Level is: " + IntToString(nRet));
	
	if (bDefaultZeroToOne == TRUE)
	    if (nRet == 0)
	        nRet =1;

    return nRet;
}


string GetClassSpellLevelColumn(int iClass)
{
	string sCol;
	
	switch (iClass)
	{
		case CLASS_TYPE_BARD: 			sCol = SPELLS_BARD_LEVEL_COL;		break;
		case CLASS_TYPE_CLERIC: 		sCol = SPELLS_CLERIC_LEVEL_COL;		break;
		case CLASS_TYPE_DRUID: 			sCol = SPELLS_DRUID_LEVEL_COL;		break;
		case CLASS_TYPE_PALADIN: 		sCol = SPELLS_PALADIN_LEVEL_COL;	break;
		case CLASS_TYPE_RANGER: 		sCol = SPELLS_RANGER_LEVEL_COL;		break;
		case CLASS_TYPE_WIZARD:	// Wiz & Sorc share same list
		case CLASS_TYPE_SORCERER: 		sCol = SPELLS_WIZ_SORC_LEVEL_COL;	break;
		case CLASS_TYPE_WARLOCK: 		sCol = SPELLS_WARLOCK_LEVEL_COL;	break;
		default:						sCol = SPELLS_INNATE_LEVEL_COL;		break;
	}		
	return (sCol);
}

// spell level for this class, or -1 on error
int GetSpellLevelForClass(int iSpell, int iClass)
{
	int iSpellLevel;
	string sCol = GetClassSpellLevelColumn(iClass);
	string sSpellLevel = Get2DACache(SPELLS_2DA, sCol, iSpell);
	
	if (sSpellLevel == "")
		iSpellLevel = -1;
	else
	 	iSpellLevel = StringToInt(sSpellLevel);
		
	//PrettyDebug ("GetSpellLevelForClass: For Spell " + IntToString(iSpell) + " and class of " +
	//			 IntToString(iClass) + " Level is: " + IntToString(iSpellLevel));
		
	return (iSpellLevel);
}

int IsOnSpellList(int iSpell, int iClass)
{
	return (GetSpellLevelForClass(iSpell, iClass) >= 0);
}


void MakeItemUseableByClass(int iClassType, object oItem)
{
	itemproperty ipLimit = ItemPropertyLimitUseByClass(iClassType);
	AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oItem);
}

void MakeItemUseableByClassesWithSpellAccess(int iSpell, object oItem)
{
	if (IsOnSpellList(iSpell, CLASS_TYPE_BARD))
		MakeItemUseableByClass(CLASS_TYPE_BARD, oItem);
		
	if (IsOnSpellList(iSpell, CLASS_TYPE_CLERIC))
		MakeItemUseableByClass(CLASS_TYPE_CLERIC, oItem);
	
	if (IsOnSpellList(iSpell, CLASS_TYPE_DRUID))
		MakeItemUseableByClass(CLASS_TYPE_DRUID, oItem);
		
	if (IsOnSpellList(iSpell, CLASS_TYPE_PALADIN))
		MakeItemUseableByClass(CLASS_TYPE_PALADIN, oItem);

	if (IsOnSpellList(iSpell, CLASS_TYPE_RANGER))
		MakeItemUseableByClass(CLASS_TYPE_RANGER, oItem);
	
	if (IsOnSpellList(iSpell, CLASS_TYPE_WIZARD))
	{
		MakeItemUseableByClass(CLASS_TYPE_WIZARD, oItem);
		MakeItemUseableByClass(CLASS_TYPE_SORCERER, oItem);
	}
	
	if (IsOnSpellList(iSpell, CLASS_TYPE_WARLOCK))
		MakeItemUseableByClass(CLASS_TYPE_WARLOCK, oItem);
}		
	

// *  Return the type of magic as one of the following constants
// *  const int X2_CI_MAGICTYPE_INVALID = 0;
// *  const int X2_CI_MAGICTYPE_ARCANE  = 1;
// *  const int X2_CI_MAGICTYPE_DIVINE  = 2;
// *  Parameters:
// *    nClass - CLASS_TYPE_* constant
int CI_GetClassMagicType(int nClass)
{
  switch (nClass)
  {
        case CLASS_TYPE_CLERIC:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_DRUID:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_PALADIN:
                return X2_CI_MAGICTYPE_DIVINE; break;
        case CLASS_TYPE_BARD:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_SORCERER:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_WIZARD:
                return X2_CI_MAGICTYPE_ARCANE; break;
        case CLASS_TYPE_RANGER:
                return X2_CI_MAGICTYPE_DIVINE; break;
    }
    return X2_CI_MAGICTYPE_INVALID;
}

string GetMaterialComponentTag(int nPropID)
{
    string sRet = Get2DACache("des_matcomp","comp_tag",nPropID);
    return sRet;
}


// -----------------------------------------------------------------------------
// Return true if oItem is a crafting target item
// -----------------------------------------------------------------------------
int CIGetIsCraftFeatBaseItem(object oItem)
{
    int nBt = GetBaseItemType(oItem);
    // blank scroll, empty potion, wand
    if (nBt == 101 || nBt == 102 || nBt == 103 || nBt == 200 || nBt == 201)
      return TRUE;
    else
      return FALSE;
}

void AppendSpellToName(object oObject, int nSpellID)
{
	int iSpellStringRef = StringToInt(Get2DAString("spells","Name", nSpellID));
	if (iSpellStringRef == 0)
		return;

	string sSpellName = GetStringByStrRef(iSpellStringRef);
	string  sOldName = GetFirstName(oObject);
	PrettyDebug ("First Name = "  + GetFirstName(oObject));
	PrettyDebug ("Last Name = "  +  GetLastName(oObject));
	PrettyDebug ("Name = "  + GetName(oObject));
	string sName = sOldName + " - " + sSpellName;
	SetFirstName(oObject, sName);
	PrettyDebug ("sNewName = "  + sName);
}

// -----------------------------------------------------------------------------
// Wrapper for the crafting cost calculation, returns GP required
// -----------------------------------------------------------------------------
int CIGetCraftGPCost(int nLevel, int nMod, sCasterLevelSwitch)
{
    int nLvlRow =   IPGetIPConstCastSpellFromSpellID(GetSpellId());
    int nCLevel;// = StringToInt(Get2DACache("iprp_spells","CasterLvl",nLvlRow));
    //PRC modification
    if(GetPRCSwitch(sCasterLevelSwitch))
    {
        nCLevel = PRCGetCasterLevel();
    }
    else
    {
        nCLevel = StringToInt(Get2DACache("iprp_spells","CasterLvl",nLvlRow));
    }

	int bZeroLevel = (nLevel == 0);
	if (bZeroLevel)
		nLevel = 1;
		
    // -------------------------------------------------------------------------
    // in case we don't get a valid CLevel, use spell level instead
    // -------------------------------------------------------------------------
    if (nCLevel ==0)
    {
        nCLevel = nLevel;
    }
	int nRet = nCLevel * nLevel * nMod;

	// zero level spells are only half the cost of 1st level spells	
	if (bZeroLevel)
		nRet = nRet/2;

    return nRet;

}


// *******************************************************
// ** Craft!

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create a new playermade potion object with properties matching nSpellID and return it
// -----------------------------------------------------------------------------
object CICraftBrewPotion(object oCreator, int nSpellID )
{

    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);

    object oTarget;
    // * GZ 2003-09-11: If the current spell cast is not acid fog, and
    // *                returned property ID is 0, bail out to prevent
    // *                creation of acid fog items.
    if (nPropID == 0 && nSpellID != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCreator);
        return OBJECT_INVALID;
    }

    if (nPropID != -1)
    {
        itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
        oTarget = CreateItemOnObject(X2_CI_BREWPOTION_NEWITEM_RESREF,oCreator);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oTarget);
		AppendSpellToName(oTarget, nSpellID);	
        if(GetPRCSwitch(PRC_BREW_POTION_CASTER_LEVEL))
        {
            itemproperty ipLevel = ItemPropertyCastSpellCasterLevel(nSpellID, PRCGetCasterLevel());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipLevel,oTarget);
            itemproperty ipMeta = ItemPropertyCastSpellMetamagic(nSpellID, PRCGetMetaMagicFeat());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipMeta,oTarget);
        itemproperty ipDC = ItemPropertyCastSpellDC(nSpellID, PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF));
            AddItemProperty(DURATION_TYPE_PERMANENT,ipDC,oTarget);
        }	
    }
    return oTarget;
}


// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create a new playermade wand object with properties matching nSpellID
// and return it
// -----------------------------------------------------------------------------
object CICraftCraftWand(object oCreator, int nSpellID )
{
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);

    object oTarget;
    // * GZ 2003-09-11: If the current spell cast is not acid fog, and
    // *                returned property ID is 0, bail out to prevent
    // *                creation of acid fog items.
    if (nPropID == 0 && nSpellID != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCreator);
        return OBJECT_INVALID;
    }


    if (nPropID != -1)
    {
        itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
        oTarget = CreateItemOnObject(X2_CI_CRAFTWAND_NEWITEM_RESREF,oCreator);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oTarget);

        if(GetPRCSwitch(PRC_CRAFT_WAND_CASTER_LEVEL))
        {
            itemproperty ipLevel = ItemPropertyCastSpellCasterLevel(nSpellID, PRCGetCasterLevel());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipLevel,oTarget);
            itemproperty ipMeta = ItemPropertyCastSpellMetamagic(nSpellID, PRCGetMetaMagicFeat());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipMeta,oTarget);
        itemproperty ipDC = ItemPropertyCastSpellDC(nSpellID, PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF));
            AddItemProperty(DURATION_TYPE_PERMANENT,ipDC,oTarget);
        }

		MakeItemUseableByClassesWithSpellAccess(nSpellID, oTarget);
		
		/*
        int nType = CI_GetClassMagicType(PRCGetLastSpellCastClass());
        itemproperty ipLimit;

        if (nType == X2_CI_MAGICTYPE_DIVINE)
        {
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_PALADIN);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_RANGER);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_DRUID);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_CLERIC);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
        }
        else if (nType == X2_CI_MAGICTYPE_ARCANE)
        {
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_WIZARD);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_SORCERER);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
             ipLimit = ItemPropertyLimitUseByClass(CLASS_TYPE_BARD);
             AddItemProperty(DURATION_TYPE_PERMANENT,ipLimit,oTarget);
        }
		*/
		AppendSpellToName(oTarget, nSpellID);				

		
		// Wands are now always created w/ 50 charges 
        int nCharges = 50;
		/*		
		nCharges = GetLevelByClass(GetLastSpellCastClass(),OBJECT_SELF) + d20();

        if (nCharges == 0) // stupi cheaters
        {
            nCharges = 10+d20();
        }
        // Hard core rule mode enabled
        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_CRAFT_WAND_50_CHARGES))
        {
            nCharges = 50;
        }
		*/
        SetItemCharges(oTarget,nCharges);

        // TODOL Add use restrictions there when item becomes available
    }
    return oTarget;
}

// -----------------------------------------------------------------------------
// Georg, 2003-06-12
// Create and Return a magic wand with an item property
// matching nSpellID. Charges are set to d20 + casterlevel
// capped at 50 max
// -----------------------------------------------------------------------------
object CICraftScribeScroll(object oCreator, int nSpellID)
{
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);
    object oTarget;
    // Handle optional material components
    string sMat = GetMaterialComponentTag(nPropID);
    if (sMat != "")
    {
        object oMat = GetItemPossessedBy(oCreator,sMat);
        if (oMat== OBJECT_INVALID)
        {
            FloatingTextStrRefOnCreature(83374, oCreator); // Missing material component
            return OBJECT_INVALID;
        }
        else
        {
            DestroyObject (oMat);
        }
     }

    // get scroll resref from scrolls lookup 2da
    int nClass =PRCGetLastSpellCastClass ();
    string sClass = "Wiz_Sorc";
    switch (nClass)
    {
       case CLASS_TYPE_WIZARD:
            sClass = "Wiz_Sorc";
            break;

       case CLASS_TYPE_SORCERER:
            sClass = "Wiz_Sorc";
            break;
       case CLASS_TYPE_CLERIC:
            sClass = "Cleric";
            break;
       case CLASS_TYPE_PALADIN:
            sClass = "Paladin";
            break;
       case CLASS_TYPE_DRUID:
            sClass = "Druid";
            break;
       case CLASS_TYPE_RANGER:
            sClass = "Ranger";
            break;
       case CLASS_TYPE_BARD:
            sClass = "Bard";
            break;
    }

    if (sClass != "")
    {
        string sResRef = Get2DACache(X2_CI_2DA_SCROLLS,sClass,nSpellID);
        if (sResRef != "")
        {
            oTarget = CreateItemOnObject(sResRef,oCreator);
        }

        if(GetPRCSwitch(PRC_SCRIBE_SCROLL_CASTER_LEVEL))
        {
            itemproperty ipLevel = ItemPropertyCastSpellCasterLevel(nSpellID, PRCGetCasterLevel());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipLevel,oTarget);
            itemproperty ipMeta = ItemPropertyCastSpellMetamagic(nSpellID, PRCGetMetaMagicFeat());
            AddItemProperty(DURATION_TYPE_PERMANENT,ipMeta,oTarget);
        itemproperty ipDC = ItemPropertyCastSpellDC(nSpellID, PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF));
            AddItemProperty(DURATION_TYPE_PERMANENT,ipDC,oTarget);
        }

        if (oTarget == OBJECT_INVALID)
        {
           WriteTimestampedLogEntry("x2_inc_craft::CICraftScribeScroll failed - Resref: " + sResRef + " Class: " + sClass + "(" +IntToString(nClass) +") " + " SpellID " + IntToString (nSpellID));
        }
    }
    return oTarget;
}


// *******************************************************
// ** Craft Checks

// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to brew a potion
// -----------------------------------------------------------------------------
int CICraftCheckBrewPotion(object oSpellTarget, object oCaster)
{

    object oSpellTarget = GetSpellTargetObject();
    object oCaster      = OBJECT_SELF;
    int    nID          = PRCGetSpellId();
    int    nLevel       = CIGetSpellInnateLevel(nID,FALSE);
    if(GetPRCSwitch(PRC_BREW_POTION_CASTER_LEVEL))
    {
        int nMetaMagic = PRCGetMetaMagicFeat();
        switch(nMetaMagic)
        {
            case METAMAGIC_EMPOWER:
                nLevel += 2;
                break;
            case METAMAGIC_EXTEND:
                nLevel += 1;
                break;
            case METAMAGIC_MAXIMIZE:
                nLevel += 3;
                break;
/*            case METAMAGIC_QUICKEN:
                nLevel += 1;
                break;
            case METAMAGIC_SILENT:
                nLevel += 5;
                break;
            case METAMAGIC_STILL:
                nLevel += 6;
                break;
These dont work as IPs since they are hardcoded */
        }
    }

    // -------------------------------------------------------------------------
    // check if brew potion feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_BREWPOTION_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE;
    }

    // -------------------------------------------------------------------------
    // check if spell is below maxlevel for brew potions
    // -------------------------------------------------------------------------
    int nPotionMaxLevel = GetPRCSwitch(X2_CI_BREWPOTION_MAXLEVEL);
    if(nPotionMaxLevel == 0)
        nPotionMaxLevel = 3;
    if (nLevel > nPotionMaxLevel)
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_TO_HIGH_FOR_POTION, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Brew Potions
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_BREWPOTION_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_POTION, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int nCostModifier = GetPRCSwitch(X2_CI_BREWPOTION_COSTMODIFIER);
    if(nCostModifier == 0)
        nCostModifier = 50;
    int nCost = CIGetCraftGPCost(nLevel, nCostModifier, PRC_BREW_POTION_CASTER_LEVEL);
    float nExperienceCost = 0.04  * nCost; // xp = 1/25 of gp value
    int nGoldCost = nCost ;

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    //if (GetGold(oCaster) < nGoldCost)
    if(!GetHasGPToSpend(oCaster, nGoldCost))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = FloatToInt(GetXP(oCaster) - nExperienceCost);


    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
    //if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    if (!GetHasXPToSpend(oCaster, FloatToInt(nExperienceCost)))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // Here we brew the new potion
    // -------------------------------------------------------------------------
    object oPotion = CICraftBrewPotion(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oPotion))
    {
        //TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        //SetXP(oCaster, nNewXP);
        SpendXP(oCaster, FloatToInt(nExperienceCost));
        SpendGP(oCaster, nGoldCost);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        //if time is enabled, fast forward
        AdvanceTimeForPlayer(oCaster, HoursToSeconds(24));
        string sName;
        sName = Get2DACache("spells", "Name", nID);
        sName = "Potion of "+GetStringByStrRef(StringToInt(sName));
        SetFirstName(oPotion, sName);
        return TRUE;
     }
     else
     {
         FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

}



// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to create a scroll
// -----------------------------------------------------------------------------
int CICraftCheckScribeScroll(object oSpellTarget, object oCaster)
{
    int  nID = PRCGetSpellId();

    // -------------------------------------------------------------------------
    // check if scribe scroll feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_SCRIBESCROLL_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE;
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Scribe Scroll
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_SCRIBESCROLL_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_SCROLL, oCaster); // can not be used with this feat
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int  nLevel    = CIGetSpellInnateLevel(nID,FALSE);
    int nCostModifier = GetPRCSwitch(X2_CI_SCRIBESCROLL_COSTMODIFIER);
    if(nCostModifier == 0)
        nCostModifier = 25;
    int nCost = CIGetCraftGPCost(nLevel, nCostModifier, PRC_SCRIBE_SCROLL_CASTER_LEVEL);
    float fExperienceCost = 0.04 * nCost;
    int nGoldCost = nCost ;

    if(GetPRCSwitch(PRC_SCRIBE_SCROLL_CASTER_LEVEL))
    {
        int nMetaMagic = PRCGetMetaMagicFeat();
        switch(nMetaMagic)
        {
            case METAMAGIC_EMPOWER:
                nLevel += 2;
                break;
            case METAMAGIC_EXTEND:
                nLevel += 1;
                break;
            case METAMAGIC_MAXIMIZE:
                nLevel += 3;
                break;
/*            case METAMAGIC_QUICKEN:
                nLevel += 1;
                break;
            case METAMAGIC_SILENT:
                nLevel += 5;
                break;
            case METAMAGIC_STILL:
                nLevel += 6;
                break;
These dont work as IPs since they are hardcoded */
        }
    }

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    if(!GetHasGPToSpend(oCaster, nGoldCost))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = FloatToInt(GetXP(oCaster) - fExperienceCost);

    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
    //if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    if (!GetHasXPToSpend(oCaster, FloatToInt(fExperienceCost)))
    {
         FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
         return TRUE;
    }

    // -------------------------------------------------------------------------
    // Here we scribe the scroll
    // -------------------------------------------------------------------------
    object oScroll = CICraftScribeScroll(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oScroll))
    {
        //----------------------------------------------------------------------
        // Some scrollsare ar not identified ... fix that here
        //----------------------------------------------------------------------
        SetIdentified(oScroll,TRUE);
        ActionPlayAnimation (ANIMATION_FIREFORGET_READ,1.0);
        SpendXP(oCaster, FloatToInt(fExperienceCost));
        SpendGP(oCaster, nGoldCost);
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        return TRUE;
     }
     else
     {
        FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

    return FALSE;
}


// -----------------------------------------------------------------------------
// Returns TRUE if the player used the last spell to craft a wand
// -----------------------------------------------------------------------------
int CICraftCheckCraftWand(object oSpellTarget, object oCaster)
{

    int nID = PRCGetSpellId();

    // -------------------------------------------------------------------------
    // check if craft wand feat is there
    // -------------------------------------------------------------------------
    if (GetHasFeat(X2_CI_CRAFTWAND_FEAT_ID, oCaster) != TRUE)
    {
      FloatingTextStrRefOnCreature(STR_REF_IC_MISSING_REQUIRED_FEAT, oCaster); // Item Creation Failed - Don't know how to create that type of item
      return TRUE; // tried item creation but do not know how to do it
    }

    // -------------------------------------------------------------------------
    // Check if the spell is allowed to be used with Craft Wand
    // -------------------------------------------------------------------------
    if (CIGetIsSpellRestrictedFromCraftFeat(nID, X2_CI_CRAFTWAND_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_RESTRICTED_FOR_WAND, oCaster); // can not be used with this feat
        return TRUE;
    }

	// now returns the actual spell level the spell was cast with.
    int nLevel = CIGetSpellInnateLevel(nID,FALSE);
    if(GetPRCSwitch(PRC_CRAFT_WAND_CASTER_LEVEL))
    {
        int nMetaMagic = PRCGetMetaMagicFeat();
        switch(nMetaMagic)
        {
            case METAMAGIC_EMPOWER:
                nLevel += 2;
                break;
            case METAMAGIC_EXTEND:
                nLevel += 1;
                break;
            case METAMAGIC_MAXIMIZE:
                nLevel += 3;
                break;
/*            case METAMAGIC_QUICKEN:
                nLevel += 1;
                break;
            case METAMAGIC_SILENT:
                nLevel += 5;
                break;
            case METAMAGIC_STILL:
                nLevel += 6;
                break;
These dont work as IPs since they are hardcoded */
        }
    }

    // -------------------------------------------------------------------------
    // check if spell is below maxlevel for craft wand
    // -------------------------------------------------------------------------
    int nMaxLevel = GetPRCSwitch(X2_CI_CRAFTWAND_MAXLEVEL);
    if(nMaxLevel == 0)
        nMaxLevel = 4;
    if (nLevel > nMaxLevel)
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_SPELL_TO_HIGH_FOR_WAND, oCaster);
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // XP/GP Cost Calculation
    // -------------------------------------------------------------------------
    int nCostMod = GetPRCSwitch(X2_CI_CRAFTWAND_COSTMODIFIER);
    if(nCostMod == 0)
        nCostMod = 750;
    int nCost = CIGetCraftGPCost(nLevel, nCostMod, PRC_CRAFT_WAND_CASTER_LEVEL);
    float nExperienceCost = 0.04 * nCost;
    int nGoldCost = nCost;

    // -------------------------------------------------------------------------
    // Does Player have enough gold?
    // -------------------------------------------------------------------------
    if(!GetHasGPToSpend(oCaster, nGoldCost))
    {
        FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_GOLD, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }

    // more calculations on XP cost
    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = FloatToInt(GetXP(oCaster) - nExperienceCost);

    // -------------------------------------------------------------------------
    // check for sufficient XP to cast spell
    // -------------------------------------------------------------------------
     if (!GetHasXPToSpend(oCaster, FloatToInt(nExperienceCost)))
    {
         FloatingTextStrRefOnCreature(STR_REF_IC_INSUFFICIENT_XP, oCaster); // Item Creation Failed - Not enough XP
         return TRUE;
    }

    // -------------------------------------------------------------------------
    // Here we craft the wand
    // -------------------------------------------------------------------------
    object oWand = CICraftCraftWand(oCaster, nID);

    // -------------------------------------------------------------------------
    // Verify Results
    // -------------------------------------------------------------------------
    if (GetIsObjectValid(oWand))
    {
        SpendXP(oCaster, FloatToInt(nExperienceCost));
        SpendGP(oCaster, nGoldCost); 
        DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(STR_REF_IC_SUCCESS, oCaster); // Item Creation successful
        //if time is enabled, fast forward
        //1 day per 1000GP base cost, min 1
        int nDays = nGoldCost/500;
        // Maester class cuts crafting time in half.
        if (GetLevelByClass(CLASS_TYPE_MAESTER, oCaster)) nDays /= 2;
        if(!nDays) nDays = 1;
        AdvanceTimeForPlayer(oCaster, HoursToSeconds(nDays*24));
        string sName;
        sName = Get2DACache("spells", "Name", nID);
        sName = "Wand of "+GetStringByStrRef(StringToInt(sName));
        SetFirstName(oWand, sName);
        return TRUE;
     }
     else
     {
        FloatingTextStrRefOnCreature(STR_REF_IC_FAILED, oCaster); // Item Creation Failed
        return TRUE;
     }

    return FALSE;
}
int CICraftCheckCraftStaff(object oSpellTarget, object oCaster)
{
    int nSpellID = PRCGetSpellId();
    int bSuccess = TRUE;
    int nCount = 0;
    itemproperty ip = GetFirstItemProperty(oSpellTarget);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL)
            nCount++;
        ip = GetNextItemProperty(oSpellTarget);
    }
    if(nCount >= 8)
    {
        FloatingTextStringOnCreature("* Failure  - Too many castspell itemproperties *", oCaster);
        return TRUE;
    }
    if(!GetHasFeat(X2_CI_CRAFTSTAFF_FEAT_ID, oCaster))
    {
        FloatingTextStrRefOnCreature(40487, oCaster); // Item Creation Failed - Don't know how to create that type of item
        return TRUE; // tried item creation but do not know how to do it
    }
    int nMetaMagic = PRCGetMetaMagicFeat();
    if(nMetaMagic && !GetHasFeat(X2_CI_CRAFTSTAFF_EPIC_FEAT_ID, oCaster))
    {
        FloatingTextStringOnCreature("* Failure  - You must be able to craft epic staffs to apply metamagic *", oCaster);
        return TRUE; // tried item creation but do not know how to do it
    }
    if(CIGetIsSpellRestrictedFromCraftFeat(nSpellID, X2_CI_CRAFTSTAFF_FEAT_ID))
    {
        FloatingTextStrRefOnCreature(16829169, oCaster); // can not be used with this feat
        return TRUE;
    }
    int nLevel = CIGetSpellInnateLevel(nSpellID,TRUE);
    if(GetPRCSwitch(PRC_CRAFT_STAFF_CASTER_LEVEL))
    {
        switch(nMetaMagic)
        {
            case METAMAGIC_EMPOWER:
                nLevel += 2;
                break;
            case METAMAGIC_EXTEND:
                nLevel += 1;
                break;
            case METAMAGIC_MAXIMIZE:
                nLevel += 3;
                break;
/*            case METAMAGIC_QUICKEN:
                nLevel += 1;
                break;
            case METAMAGIC_SILENT:
                nLevel += 5;
                break;
            case METAMAGIC_STILL:
                nLevel += 6;
                break;
These dont work as IPs since they are hardcoded */
        }
    }
    int nCostMod = GetPRCSwitch(X2_CI_CRAFTSTAFF_COSTMODIFIER);
    if(!nCostMod) nCostMod = 750;
    int nLvlRow = IPGetIPConstCastSpellFromSpellID(nSpellID);
    int nCLevel = StringToInt(Get2DACache("iprp_spells","CasterLvl",nLvlRow));
    int nCost = CIGetCraftGPCost(nLevel, nCostMod, PRC_CRAFT_STAFF_CASTER_LEVEL);
    //discount for second or 3+ spells
    if(nCount+1 == 2)
        nCost = (nCost*3)/4;
    else if(nCount+1 >= 3)
        nCost = nCost/2;
        
    int nXP = nCost / 25;
    int nGoldCost = nCost / 2;
    if(nGoldCost < 1) nXP = 1;
    if(nXP < 1) nXP = 1;
    //if(GetGold(oCaster) < nGoldCost)  //  enough gold?
    if (!GetHasGPToSpend(oCaster, nGoldCost))
    {
        FloatingTextStrRefOnCreature(3786, oCaster); // Item Creation Failed - not enough gold!
        return TRUE;
    }
    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = (nHD * (nHD - 1)) * 500;
    int nNewXP = GetXP(oCaster) - nXP;
    //if (nMinXPForLevel > nNewXP || nNewXP == 0 )
    if (!GetHasXPToSpend(oCaster, nXP))
    {
         FloatingTextStrRefOnCreature(3785, oCaster); // Item Creation Failed - Not enough XP
         return TRUE;
    }
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpellID);
    if (nPropID == 0 && nSpellID != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCaster);
        return TRUE;
    }
    if (nPropID != -1)
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE),oSpellTarget);

        if(GetPRCSwitch(PRC_CRAFT_STAFF_CASTER_LEVEL))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpellCasterLevel(nSpellID, PRCGetCasterLevel()),oSpellTarget);
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpellMetamagic(nSpellID, PRCGetMetaMagicFeat()),oSpellTarget);
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyCastSpellDC(nSpellID, PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF)),oSpellTarget);
        }
    }
    else
        bSuccess = FALSE;

    if(bSuccess)
    {
        //TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        //SetXP(oCaster, nNewXP);
        SpendXP(oCaster, nXP);
        SpendGP(oCaster, nGoldCost); 
        //DestroyObject (oSpellTarget);
        FloatingTextStrRefOnCreature(8502, oCaster); // Item Creation successful
        //if time is enabled, fast forward
        //1 day per 1000GP base cost, min 1
        int nDays = nCost/1000;
        // Maester class cuts crafting time in half.
        if (GetLevelByClass(CLASS_TYPE_MAESTER, oCaster)) nDays /= 2;
        if(!nDays) nDays = 1;
        AdvanceTimeForPlayer(oCaster, HoursToSeconds(nDays*24));
        string sName;
        sName = GetName(oCaster)+"'s Magic Staff";
        //sName = Get2DACache("spells", "Name", nID);
        //sName = "Wand of "+GetStringByStrRef(StringToInt(sName));
        SetFirstName(oSpellTarget, sName);
        return TRUE;
    }
    else
    {
        FloatingTextStrRefOnCreature(76417, oCaster); // Item Creation Failed
        return TRUE;
    }
    return TRUE;
}

int InscribeRune()
{
    object oCaster = OBJECT_SELF;
    // Get the item used to cast the spell
    object oItem = GetSpellCastItem();
    if (GetResRef(oItem) == "prc_rune_1")
    {
        string sName = GetName(GetItemPossessor(oItem));
        if (DEBUG) FloatingTextStringOnCreature(sName + " has just cast a rune spell", oCaster, FALSE);

        DoDebug("Checking for One Use runes");
        // This check is used to clear up the one use runes
        itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_CAST_SPELL)
            {
                DoDebug("Rune can cast spells");
                if (GetItemPropertyCostTableValue(ip) == 5) // Only one use runes have 2 charges per use
                {
                    DoDebug("Rune has 2 charges a use, marking it a one use rune");
                    // Give it enough time for the spell to finish casting
                    DestroyObject(oItem, 1.0);
                    DoDebug("Rune destroyed.");
                }
            }

    ip = GetNextItemProperty(oItem);
        }
    }

    // If Inscribing is turned off, the spell functions as normal
    if(!GetLocalInt(oCaster, "InscribeRune")) return TRUE;

    // No point being in here if you don't have runes.
    if (!GetHasFeat(FEAT_INSCRIBE_RUNE, oCaster)) return TRUE;

        // No point scribing runes from items, and its not allowed.
        if (oItem != OBJECT_INVALID)
        {
            FloatingTextStringOnCreature("You cannot scribe a rune from an item.", oCaster, FALSE);
            return TRUE;
        }

    object oTarget = PRCGetSpellTargetObject();
    int nCaster = PRCGetCasterLevel(oCaster);
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    int nSpell = PRCGetSpellId();
    int nSpellLevel;
    int nClass = GetLevelByClass(CLASS_TYPE_RUNECASTER, oCaster);

    // This accounts for the fact that there is no bonus to runecraft at level 10
    // Also adjusts it to fit the epic progression, which starts at 13
    if (nClass >= 10) nClass -= 3;
    // Bonus to Runecrafting checks from the Runecaster class
    int nRuneCraft = (nClass + 2)/3;
    // Runecraft local int that counts uses/charges
    int nCount = GetLocalInt(oCaster, "RuneCounter");

    if (PRCGetLastSpellCastClass() == CLASS_TYPE_CLERIC) nSpellLevel = StringToInt(lookup_spell_cleric_level(nSpell));
    else if (PRCGetLastSpellCastClass() == CLASS_TYPE_DRUID) nSpellLevel = StringToInt(lookup_spell_druid_level(nSpell));
    else if (PRCGetLastSpellCastClass() == CLASS_TYPE_WIZARD || PRCGetLastSpellCastClass() == CLASS_TYPE_SORCERER) nSpellLevel = StringToInt(lookup_spell_level(nSpell));
    // If none of these work, check the innate level of the spell
    if (nSpellLevel == 0) nSpellLevel = StringToInt(lookup_spell_innate(nSpell));
    // Minimum level.
    if (nSpellLevel == 0) nSpellLevel = 1;

    // This will be modified with Runecaster code later.
    int nCharges = 1;
    if (GetLocalInt(oCaster, "RuneCharges")) nCharges = nCount;
    if (GetLocalInt(oCaster, "RuneUsesPerDay"))
    {
        // 5 is the max uses per day
        if (nCount > 5) nCount = 5;
        int nMaxUses = StringToInt(Get2DACache("prc_rune_craft", "Cost", PRC_RUNE_MAXUSESPERDAY));
        if (nCount > nMaxUses) nCount = nMaxUses;
        nCharges = nCount;
    }
    // Can't have no charges
    if (nCharges == 0) nCharges = 1;
    int nMaxCharges = StringToInt(Get2DACache("prc_rune_craft", "Cost", PRC_RUNE_MAXCHARGES));
    if (nCount > nMaxCharges) nCharges = nMaxCharges;

    FloatingTextStringOnCreature("Spell Level: " + IntToString(nSpellLevel), OBJECT_SELF, FALSE);
    FloatingTextStringOnCreature("Caster Level: " + IntToString(nCaster), OBJECT_SELF, FALSE);
    FloatingTextStringOnCreature("Number of Charges: " + IntToString(nCharges), OBJECT_SELF, FALSE);

    // Gold cost multipler, varies depending on the ability used to craft
    int nMultiplier = StringToInt(Get2DACache("prc_rune_craft", "Cost", PRC_RUNE_BASECOST));
    if (nClass > 0) nMultiplier /= 2;
    if (GetLocalInt(oCaster, "RuneCharges")) nMultiplier = StringToInt(Get2DACache("prc_rune_craft", "Cost", PRC_RUNE_CHARGES));
    if (GetLocalInt(oCaster, "RuneUsesPerDay")) nMultiplier = StringToInt(Get2DACache("prc_rune_craft", "Cost", PRC_RUNE_PERDAY));

    // Cost of the rune in gold and XP
    int nGoldCost = nSpellLevel * nCaster * nCharges * nMultiplier;
    int nXPCost = nGoldCost/25;

    FloatingTextStringOnCreature("Gold Cost: " + IntToString(nGoldCost), OBJECT_SELF, FALSE);
    FloatingTextStringOnCreature("XP Cost: " + IntToString(nXPCost), OBJECT_SELF, FALSE);

    // See if the caster has enough gold and XP to scribe a rune, and that he passes the skill check.
    int nHD = GetHitDice(oCaster);
    int nMinXPForLevel = ((nHD * (nHD - 1)) / 2) * 1000;
    int nNewXP = GetXP(oCaster) - nXPCost;
    int nGold = GetGold(oCaster);
    int nNewGold = nGold - nGoldCost;
    int nCheck = FALSE;
    // Does the PC have Maximize Rune turned on?
    int nMaximize = 0;
    if (GetLocalInt(oCaster, "MaximizeRune")) nMaximize = 5;
    // The check does not use GetIsSkillSuccessful so it doesn't show on the PC
    if ((GetSkillRank(SKILL_CRAFT_ARMOR, oCaster) + d20() + nRuneCraft) >= (20 + nSpellLevel + nMaximize)) nCheck = TRUE;


    if (!GetHasGPToSpend(oCaster, nGoldCost))
    {
        FloatingTextStringOnCreature("You do not have enough gold to scribe this rune.", oCaster, FALSE);
        // Since they don't have enough, the spell casts normally
        return TRUE;
    }
    if (!GetHasXPToSpend(oCaster, nXPCost) )
    {
        FloatingTextStringOnCreature("You do not have enough experience to scribe this rune.", oCaster, FALSE);
        // Since they don't have enough, the spell casts normally
        return TRUE;
    }
    if (!nCheck)
    {
        FloatingTextStringOnCreature("You have failed the craft check to scribe this rune.", oCaster, FALSE);
        // Since they don't have enough, the spell casts normally
        return TRUE;
    }

    // Steal all the code from craft wand.
    // The reason craft wand is used is because it is possible to create runes with charges using the Runecaster class.
    int nPropID = IPGetIPConstCastSpellFromSpellID(nSpell);

    // * GZ 2003-09-11: If the current spell cast is not acid fog, and
    // *                returned property ID is 0, bail out to prevent
    // *                creation of acid fog items.
    if (nPropID == 0 && nSpell != 0)
    {
        FloatingTextStrRefOnCreature(84544,oCaster);
        return TRUE;
    }

    // Since we know they can now pay for it, create the rune stone
    object oRune = CreateItemOnObject("prc_rune_1", oCaster);

    if (nPropID != -1)
    {
        // This part is always done
        int nRuneChant = 0;
        // If they have this active, the bonuses are already added, so skip
        // If they don't, add the bonuses down below
        if(!GetHasSpellEffect(SPELL_RUNE_CHANT))
        {
            if (nClass >= 30)        nRuneChant = 10;
            else if (nClass >= 27)   nRuneChant = 9;
            else if (nClass >= 24)   nRuneChant = 8;
            else if (nClass >= 21)   nRuneChant = 7;
            else if (nClass >= 18)   nRuneChant = 6;
            else if (nClass >= 15)   nRuneChant = 5;
            else if (nClass >= 12)   nRuneChant = 4;
            else if (nClass >= 9)    nRuneChant = 3;
            else if (nClass >= 5)    nRuneChant = 2;
            else if (nClass >= 2)    nRuneChant = 1;
        }
        itemproperty ipLevel = ItemPropertyCastSpellCasterLevel(nSpell, PRCGetCasterLevel());
        AddItemProperty(DURATION_TYPE_PERMANENT,ipLevel,oRune);
        itemproperty ipMeta = ItemPropertyCastSpellMetamagic(nSpell, PRCGetMetaMagicFeat());
        AddItemProperty(DURATION_TYPE_PERMANENT,ipMeta,oRune);
        itemproperty ipDC = ItemPropertyCastSpellDC(nSpell, PRCGetSaveDC(PRCGetSpellTargetObject(), OBJECT_SELF) + nRuneChant);
        AddItemProperty(DURATION_TYPE_PERMANENT,ipDC,oRune);
        // If Maximize Rune is turned on and we pass the check, add the Maximize IProp
        if (GetLocalInt(oCaster, "MaximizeRune"))
        {
            itemproperty ipMax = ItemPropertyCastSpellMetamagic(nSpell, METAMAGIC_MAXIMIZE);
            AddItemProperty(DURATION_TYPE_PERMANENT,ipMax,oRune);
        }

        // If its uses per day instead of charges, we do some different stuff here
        if (GetLocalInt(oCaster, "RuneUsesPerDay"))
        {
            int nIPUses;
            if (nCount == 1) nIPUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
            else if (nCount == 2) nIPUses = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
            else if (nCount == 3) nIPUses = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
            else if (nCount == 4) nIPUses = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
            // Caps out at 5 per day
            else if (nCount >= 5) nIPUses = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;

            itemproperty ipProp = ItemPropertyCastSpell(nPropID,nIPUses);
            AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oRune);
        }
        else if (nCharges == 1) // This is to handle one use runes so the spellhooking works
        {
            itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE);
            AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oRune);
            // This is done so the item exists when it is used for the game to read data off of
        nCharges = 3;
        }
        else // Do the normal charges
        {
            itemproperty ipProp = ItemPropertyCastSpell(nPropID,IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE);
            AddItemProperty(DURATION_TYPE_PERMANENT,ipProp,oRune);
        }
        SetItemCharges(oRune,nCharges);
        SetXP(oCaster,nNewXP);
        TakeGoldFromCreature(nGoldCost, oCaster, TRUE);
        //if time is enabled, fast forward
        //1 day per 1000GP base cost, min 1
        int nDays = nGoldCost/1000;
        // Maester class cuts crafting time in half.
        if (GetLevelByClass(CLASS_TYPE_MAESTER, oCaster)) nDays /= 2;
        if(!nDays) nDays = 1;
        AdvanceTimeForPlayer(oCaster, HoursToSeconds(nDays*24));
        string sName;
        sName = Get2DACache("spells", "Name", nSpell);
        sName = "Rune of "+GetStringByStrRef(StringToInt(sName));
        if(GetLocalInt(oCaster, "MaximizeRune"))
            sName = "Maximized "+sName;
        SetFirstName(oRune, sName);
    }

    // If we have made it this far, they have crafted the rune and the spell has been used up, so it returns false.
    return FALSE;
}


// -----------------------------------------------------------------------------
// Georg, July 2003
// Checks if the caster intends to use his item creation feats and
// calls appropriate item creation subroutine if conditions are met
// (spell cast on correct item, etc).
// Returns TRUE if the spell was used for an item creation feat
// -----------------------------------------------------------------------------
int CIGetSpellWasUsedForItemCreation(object oSpellTarget)
{
    object oCaster = OBJECT_SELF;

    // -------------------------------------------------------------------------
    // Spell cast on crafting base item (blank scroll, etc) ?
    // -------------------------------------------------------------------------
    if (!CIGetIsCraftFeatBaseItem(oSpellTarget))
    {
       return FALSE; // not blank scroll baseitem
    }
    else
    {
        // ---------------------------------------------------------------------
        // Check Item Creation Feats were disabled through x2_inc_switches
        // ---------------------------------------------------------------------
        if (GetModuleSwitchValue(MODULE_SWITCH_DISABLE_ITEM_CREATION_FEATS) == TRUE)
        {
            FloatingTextStrRefOnCreature(STR_REF_IC_DISABLED, oCaster); // * Item creation feats are not enabled in this module *
            return FALSE;
        }
        if (GetLocalInt(GetArea(oCaster), PRC_AREA_DISABLE_CRAFTING))
        {
            FloatingTextStrRefOnCreature(16832014, oCaster); // * Item creation feats are not enabled in this area *
            return FALSE;
        }

        // ---------------------------------------------------------------------
        // Ensure that item creation does not work one item was cast on another
        // ---------------------------------------------------------------------
        if (GetSpellCastItem() != OBJECT_INVALID)
        {
            FloatingTextStrRefOnCreature(STR_REF_IC_ITEM_USE_NOT_ALLOWED, oCaster); // can not use one item to enchant another
            return TRUE;
        }

        // ---------------------------------------------------------------------
        // Ok, what kind of feat the user wants to use by examining the base itm
        // ---------------------------------------------------------------------
        int nBt = GetBaseItemType(oSpellTarget);
        int nRet = FALSE;
        switch (nBt)
        {
                case 101 :
                            // -------------------------------------------------
                            // Brew Potion
                            // -------------------------------------------------
                           nRet = CICraftCheckBrewPotion(oSpellTarget,oCaster);
                           break;


                case 102 :
                            // -------------------------------------------------
                            // Scribe Scroll
                            // -------------------------------------------------
                           nRet = CICraftCheckScribeScroll(oSpellTarget,oCaster);
                           break;


                case 103 :
                            // -------------------------------------------------
                            // Craft Wand
                            // -------------------------------------------------
                           nRet = CICraftCheckCraftWand(oSpellTarget,oCaster);
                           break;

                case 200 :
                            // -------------------------------------------------
                            // Craft Rod
                            // -------------------------------------------------
                           //nRet = CICraftCheckCraftWand(oSpellTarget,oCaster);
                           break;

                case 201 :
                            // -------------------------------------------------
                            // Craft Staff
                            // -------------------------------------------------
                           nRet = CICraftCheckCraftStaff(oSpellTarget,oCaster);
                           break;

                // you could add more crafting basetypes here....
        }

        return nRet;

    }

}

// -----------------------------------------------------------------------------
// Makes oPC do a Craft check using nSkill to create the item supplied in sResRe
// If oContainer is specified, the item will be created there.
// Throwing weapons are created with stack sizes of 10, ammo with 20
// -----------------------------------------------------------------------------
object CIUseCraftItemSkill(object oPC, int nSkill, string sResRef, int nDC, object oContainer = OBJECT_INVALID)
{
    int bSuccess = GetIsSkillSuccessful(oPC, nSkill, nDC);
    object oNew;
    if (bSuccess)
    {
        // actual item creation
        // if a crafting container was specified, create inside
        int bFix;
        if (oContainer == OBJECT_INVALID)
        {
            //------------------------------------------------------------------
            // We create the item in the work container to get rid of the
            // stackable item problems that happen when we create the item
            // directly on the player
            //------------------------------------------------------------------
            oNew =CreateItemOnObject(sResRef,IPGetIPWorkContainer(oPC));
            bFix = TRUE;
        }
        else
        {
            oNew =CreateItemOnObject(sResRef,oContainer);
        }

        int nBase = GetBaseItemType(oNew);
        if (nBase ==  BASE_ITEM_BOLT || nBase ==  BASE_ITEM_ARROW || nBase ==  BASE_ITEM_BULLET)
        {
            SetItemStackSize(oNew, 20);
        }
        else if (nBase ==  BASE_ITEM_THROWINGAXE || nBase ==  BASE_ITEM_SHURIKEN || nBase ==  BASE_ITEM_DART)
        {
            SetItemStackSize(oNew, 10);
        }

        //----------------------------------------------------------------------
        // Get around the whole stackable item mess...
        //----------------------------------------------------------------------
        if (bFix)
        {
            object oRet = CopyObject(oNew,GetLocation(oPC),oPC);
            DestroyObject(oNew);
            oNew = oRet;
        }


    }
    else
    {
        oNew = OBJECT_INVALID;
    }

    return oNew;
}


// -----------------------------------------------------------------------------
// georg, 2003-06-13 (
// Craft an item. This is only to be called from the crafting conversation
// spawned by x2_s2_crafting!!!
// -----------------------------------------------------------------------------
int CIDoCraftItemFromConversation(int nNumber)
{
  string    sNumber     = IntToString(nNumber);
  object    oPC         = GetPCSpeaker();
  //object    oMaterial   = GetLocalObject(oPC,"X2_CI_CRAFT_MATERIAL");
  object    oMajor       = GetLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
  object    oMinor       = GetLocalObject(oPC,"X2_CI_CRAFT_MINOR");
  int       nSkill      =  GetLocalInt(oPC,"X2_CI_CRAFT_SKILL");
  int       nMode       =  GetLocalInt(oPC,"X2_CI_CRAFT_MODE");
  string    sResult;
  string    s2DA;
  int       nDC;


    DeleteLocalObject(oPC,"X2_CI_CRAFT_MAJOR");
    DeleteLocalObject(oPC,"X2_CI_CRAFT_MINOR");

    if (!GetIsObjectValid(oMajor))
    {
          FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          return FALSE;
    }
    else
    {
          if (GetItemPossessor(oMajor) != oPC)
          {
               FloatingTextStrRefOnCreature(83354,oPC);     //"Invalid target"
               DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
               return FALSE;
          }
    }

    // If we are in container mode,
    if (nMode == X2_CI_CRAFTMODE_CONTAINER)
    {
        if (!GetIsObjectValid(oMinor))
        {
              FloatingTextStrRefOnCreature(83374,oPC);    //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
        }
        else if (GetItemPossessor(oMinor) != oPC)
         {
              FloatingTextStrRefOnCreature(83354,oPC);   //"Invalid target"
              DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
              return FALSE;
         }
   }


  if (nSkill == 26) // craft weapon
  {
        s2DA = X2_CI_CRAFTING_WP_2DA;
  }
  else if (nSkill == 25)
  {
        s2DA = X2_CI_CRAFTING_AR_2DA;
  }

  int nRow = GetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW");
  struct craft_struct stItem =  CIGetCraftItemStructFrom2DA(s2DA,nRow,nNumber);
  object oContainer = OBJECT_INVALID;

  // ---------------------------------------------------------------------------
  // We once used a crafting container, but found it too complicated. Code is still
  // left in here for the community
  // ---------------------------------------------------------------------------
  if (nMode == X2_CI_CRAFTMODE_CONTAINER)
  {
        oContainer = GetItemPossessedBy(oPC,"x2_it_craftcont");
  }

  // Do the crafting...
  object oRet = CIUseCraftItemSkill( oPC, nSkill, stItem.sResRef, stItem.nDC, oContainer) ;

  // * If you made an item, it should always be identified;
  SetIdentified(oRet,TRUE);

  if (GetIsObjectValid(oRet))
  {
      // -----------------------------------------------------------------------
      // Copy all item properties from the major object on the resulting item
      // Through we problably won't use this, its a neat thing to have for the
      // community
      // to enable magic item creation from the crafting system
      // -----------------------------------------------------------------------
       //if (GetGold(oPC)<stItem.nCost)
       if (!GetHasGPToSpend(oPC, stItem.nCost))
       {
          DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
          FloatingTextStrRefOnCreature(86675,oPC);
          DestroyObject(oRet);
          return FALSE;
       }
       else
       {
          //TakeGoldFromCreature(stItem.nCost, oPC,TRUE);
          SpendGP(oPC, stItem.nCost);
          IPCopyItemProperties(oMajor,oRet);
        }
      // set success variable for conversation
      SetLocalInt(oPC,"X2_CRAFT_SUCCESS",TRUE);
  }
  else
  {
      //TakeGoldFromCreature(stItem.nCost / 4, oPC,TRUE);
      SpendGP(oPC, stItem.nCost/4);
      // make sure there is no success
      DeleteLocalInt(oPC,"X2_CRAFT_SUCCESS");
  }

  // Destroy first material component
  DestroyObject (oMajor);

  // if we are running in a container, destroy the second material component as well
  if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE)
  {
      DestroyObject (oMinor);
  }
  int nRet = (oRet != OBJECT_INVALID);
  return nRet;
}

// -----------------------------------------------------------------------------
// Retrieve craft information on a certain item
// -----------------------------------------------------------------------------
struct craft_struct CIGetCraftItemStructFrom2DA(string s2DA, int nRow, int nItemNo)
{
   struct craft_struct stRet;
   string sNumber = IntToString(nItemNo);

   stRet.nRow    =  nRow;
   string sLabel = Get2DACache(s2DA,"Label"+ sNumber, nRow);
   if (sLabel == "")
   {
      return stRet;  // empty, no need to read further
   }
   int nStrRef = StringToInt(sLabel);
   if (nStrRef != 0)  // Handle bioware StrRefs
   {
      sLabel = GetStringByStrRef(nStrRef);
   }
   stRet.sLabel  = sLabel;
   stRet.nDC     =  StringToInt(Get2DACache(s2DA,"DC"+ sNumber, nRow));
   stRet.nCost   =  StringToInt(Get2DACache(s2DA,"CostGP"+ sNumber, nRow));
   stRet.sResRef =  Get2DACache(s2DA,"ResRef"+ sNumber, nRow);

   return stRet;
}

// -----------------------------------------------------------------------------
// Return the cost
// -----------------------------------------------------------------------------
int CIGetItemPartModificationCost(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DACache(X2_IP_ARMORPARTS_2DA,"CraftCost",nPart));
    nRet = (GetGoldPieceValue(oOldItem) / 100 * nRet);

    // minimum cost for modification is 1 gp
    if (nRet == 0)
    {
        nRet =1;
    }
    return nRet;
}

// -----------------------------------------------------------------------------
// Return the DC for modifying a certain armor part on oOldItem
// -----------------------------------------------------------------------------
int CIGetItemPartModificationDC(object oOldItem, int nPart)
{
    int nRet = StringToInt(Get2DACache(X2_IP_ARMORPARTS_2DA,"CraftDC",nPart));
    // minimum cost for modification is 1 gp
    return nRet;
}

// -----------------------------------------------------------------------------
// returns the dc
// dc to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nTotal+= CIGetItemPartModificationCost(oOldItem,nPart);
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}

// -----------------------------------------------------------------------------
// returns the cost in gold piece that it would
// cost to modify oOlditem to look like oNewItem
// -----------------------------------------------------------------------------
int CIGetArmorModificationDC(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   int nDC =0;
   for (nPart = 0; nPart<ITEM_APPR_ARMOR_NUM_MODELS; nPart++)
   {

        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_ARMOR_MODEL, nPart))
        {
            nDC = CIGetItemPartModificationDC(oOldItem,nPart);
            if (nDC>nTotal)
            {
                nTotal = nDC;
            }
        }
   }

   nTotal = GetItemACValue(oOldItem) + nTotal + 5;

   return nTotal;
}

// -----------------------------------------------------------------------------
// returns TRUE if the spell matching nSpellID is prevented from being used
// with the CraftFeat matching nFeatID
// This is controlled in des_crft_spells.2da
// -----------------------------------------------------------------------------
int CIGetIsSpellRestrictedFromCraftFeat(int nSpellID, int nFeatID)
{
    string sCol;
    switch(nFeatID)
    {
        case X2_CI_BREWPOTION_FEAT_ID: sCol = "NoPotion"; break;
        case X2_CI_SCRIBESCROLL_FEAT_ID: sCol = "NoScroll"; break;
        case X2_CI_CRAFTWAND_FEAT_ID:
        case X2_CI_CRAFTSTAFF_FEAT_ID: sCol = "NoWand"; break;
    }
    return !!StringToInt(Get2DACache(X2_CI_CRAFTING_SP_2DA,sCol,nSpellID));
    /*
    if (nFeatID == X2_CI_BREWPOTION_FEAT_ID)
    {
        sCol ="NoPotion";
    }
    else if (nFeatID == X2_CI_SCRIBESCROLL_FEAT_ID)
    {
        sCol = "NoScroll";
    }
    else if (nFeatID == X2_CI_CRAFTWAND_FEAT_ID)
    {
         sCol = "NoWand";
    }

    string sRet = Get2DACache(X2_CI_CRAFTING_SP_2DA,sCol,nSpellID);
    int nRet = (sRet == "1") ;
    return nRet;
    */
}

// -----------------------------------------------------------------------------
// Retrieve the row in des_crft_bmat too look up receipe
// -----------------------------------------------------------------------------
int CIGetCraftingReceipeRow(int nMode, object oMajor, object oMinor, int nSkill)
{
    if (nMode == X2_CI_CRAFTMODE_CONTAINER || nMode == X2_CI_CRAFTMODE_ASSEMBLE )
    {
        int nMinorId = StringToInt(Get2DACache("des_crft_amat",GetTag(oMinor),1));
        int nMajorId = StringToInt(Get2DACache("des_crft_bmat",GetTag(oMajor),nMinorId));
        return nMajorId;
    }
    else if (nMode == X2_CI_CRAFTMODE_BASE_ITEM)
    {
       int nLookUpRow;
       string sTag = GetTag(oMajor);
       switch (nSkill)
       {
            case 26: nLookUpRow =1 ; break;
            case 25: nLookUpRow= 2 ; break;
       }
       int nRet = StringToInt(Get2DACache(X2_CI_CRAFTING_MAT_2DA,sTag,nLookUpRow));
       return nRet;
    }
    else
    {
        return 0; // error
    }
}

// -----------------------------------------------------------------------------
// used to set all variable required for the crafting conversation
// (Used materials, number of choises, 2da row, skill and mode)
// -----------------------------------------------------------------------------
void CISetupCraftingConversation(object oPC, int nNumber, int nSkill, int nReceipe, object oMajor, object oMinor, int nMode)
{

  SetLocalObject(oPC,"X2_CI_CRAFT_MAJOR",oMajor);
  if (nMode == X2_CI_CRAFTMODE_CONTAINER ||  nMode == X2_CI_CRAFTMODE_ASSEMBLE )
  {
      SetLocalObject(oPC,"X2_CI_CRAFT_MINOR", oMinor);
  }
  SetLocalInt(oPC,"X2_CI_CRAFT_NOOFITEMS",nNumber);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_SKILL",nSkill);          // skill used (craft armor or craft waeapon)
  SetLocalInt(oPC,"X2_CI_CRAFT_RESULTROW",nReceipe);    // number of crafting choises for this material
  SetLocalInt(oPC,"X2_CI_CRAFT_MODE",nMode);
}

// -----------------------------------------------------------------------------
// oItem - The item used for crafting
// -----------------------------------------------------------------------------
struct craft_receipe_struct CIGetCraftingModeFromTarget(object oPC,object oTarget, object oItem = OBJECT_INVALID)
{
  struct craft_receipe_struct stStruct;


  if (GetBaseItemType(oItem) == 112 ) // small
  {
       stStruct.oMajor = oItem;
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       return stStruct;
  }

  if (!GetIsObjectValid(oTarget))
  {
     stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
     return stStruct;
  }


  // A small craftitem was used on a large one
  if (GetBaseItemType(oItem) == 110 ) // small
  {
        if (GetBaseItemType(oTarget) == 109)  // large
        {
            stStruct.nMode = X2_CI_CRAFTMODE_ASSEMBLE; // Mode is ASSEMBLE
            stStruct.oMajor = oTarget;
            stStruct.oMinor = oItem;
            return stStruct;
        }
        else
        {
            FloatingTextStrRefOnCreature(84201,oPC);
        }

  }

  // -----------------------------------------------------------------------------
  // *** CONTAINER IS NO LONGER USED IN OFFICIAL CAMPAIGN
  //     BUT CODE LEFT IN FOR COMMUNITY.
  //     THE FOLLOWING CONDITION IS NEVER TRUE FOR THE OC (no crafting container)
  //     To reactivate, create a container with tag x2_it_craftcont
  int bCraftCont = (GetTag(oTarget) == "x2_it_craftcont");


  if (bCraftCont == TRUE)
  {
    // First item in container is baseitem  .. mode = baseitem
    if ( GetBaseItemType(GetFirstItemInInventory(oTarget)) == 112)
    {
        stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
        stStruct.oMajor = GetFirstItemInInventory(oTarget);
        return stStruct;
    }
    else
    {
        object oTest = GetFirstItemInInventory(oTarget);
        int nCount =1;
        int bMajor = FALSE;
        int bMinor = FALSE;
        // No item in inventory ... mode = fail
        if (!GetIsObjectValid(oTest))
        {
            FloatingTextStrRefOnCreature(84200,oPC);
            stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
            return stStruct;
        }
        else
        {
            while (GetIsObjectValid(oTest) && nCount <3)
            {
                if (GetBaseItemType(oTest) == 109)
                {
                    stStruct.oMajor = oTest;
                    bMajor = TRUE;
                }
                else if (GetBaseItemType(oTest) == 110)
                {
                    stStruct.oMinor = oTest;
                    bMinor = TRUE;
                }
                else if ( GetBaseItemType(oTest) == 112)
                {
                    stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
                    stStruct.oMajor = oTest;
                    return stStruct;
                }
                oTest = GetNextItemInInventory(oTarget);
                if (GetIsObjectValid(oTest))
                {
                    nCount ++;
                }
            }

            if (nCount >2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }
            else if (nCount <2)
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

            if (bMajor && bMinor)
            {
                stStruct.nMode =  X2_CI_CRAFTMODE_CONTAINER;
                return stStruct;
            }
            else
            {
                FloatingTextStrRefOnCreature(84356,oPC);
                //FloatingTextStringOnCreature("Temp: Wrong combination of items in the crafting container",oPC);
                stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
                return stStruct;
            }

        }
    }
  }
  else
  {
    // not a container but a baseitem
    if (GetBaseItemType(oTarget) == 112)
    {
       stStruct.nMode = X2_CI_CRAFTMODE_BASE_ITEM;
       stStruct.oMajor = oTarget;
       return stStruct;

    }
    else
    {
          if (GetBaseItemType(oTarget) == 109 || GetBaseItemType(oTarget) == 110)
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;
          }
          else
          {
              FloatingTextStrRefOnCreature(84357,oPC);
              // not a valid item
              stStruct.nMode = X2_CI_CRAFTMODE_INVALID;
              return stStruct;

          }
    }
  }
}

// -----------------------------------------------------------------------------
//                 *** Crafting Conversation Functions ***
// -----------------------------------------------------------------------------
int CIGetInModWeaponOrArmorConv(object oPC)
{
    return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_CONVERSATION");
}


void CISetCurrentModMode(object oPC, int nMode)
{
    if (nMode == X2_CI_MODMODE_INVALID)
    {
        DeleteLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
    }
    else
    {
        SetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE",nMode);
    }
}

int CIGetCurrentModMode(object oPC)
{
  return GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE");
}


object CIGetCurrentModBackup(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP");
}

object CIGetCurrentModItem(object oPC)
{
    return GetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM");
}


void CISetCurrentModBackup(object oPC, object oBackup)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_BACKUP",oBackup);
}

void CISetCurrentModItem(object oPC, object oItem)
{
    SetLocalObject(GetPCSpeaker(),"X2_O_CRAFT_MODIFY_ITEM",oItem);
}


// -----------------------------------------------------------------------------
// * This does multiple things:
//   -  store the part currently modified
//   -  setup the custom token for the conversation
//   -  zoom the camera to that part
// -----------------------------------------------------------------------------
void CISetCurrentModPart(object oPC, int nPart, int nStrRef)
{
    SetLocalInt(oPC,"X2_TAILOR_CURRENT_PART",nPart);

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {

        // * Make the camera float near the PC
        float fFacing  = GetFacing(oPC) + 180.0;

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_LHAND || nPart == ITEM_APPR_ARMOR_MODEL_LBICEP)
        {
            fFacing += 80.0;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RFOREARM ||
            nPart == ITEM_APPR_ARMOR_MODEL_RHAND || nPart == ITEM_APPR_ARMOR_MODEL_RBICEP)
        {
            fFacing -= 80.0;
        }

        float fPitch = 75.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }

        float  fDistance = 3.5f;
        if (nPart == ITEM_APPR_ARMOR_MODEL_PELVIS || nPart == ITEM_APPR_ARMOR_MODEL_BELT )
        {
            fDistance = 2.0f;
        }

        if (nPart == ITEM_APPR_ARMOR_MODEL_LSHOULDER || nPart == ITEM_APPR_ARMOR_MODEL_RSHOULDER )
        {
            fPitch = 50.0f;
            fDistance = 3.0f;
        }
        else  if (nPart == ITEM_APPR_ARMOR_MODEL_LFOREARM || nPart == ITEM_APPR_ARMOR_MODEL_LHAND)
        {
            fDistance = 2.0f;
            fPitch = 60.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_NECK)
        {
            fPitch = 90.0f;
        }
        else if (nPart == ITEM_APPR_ARMOR_MODEL_RFOOT || nPart == ITEM_APPR_ARMOR_MODEL_LFOOT  )
        {
            fDistance = 3.5f;
            fPitch = 47.0f;
        }
         else if (nPart == ITEM_APPR_ARMOR_MODEL_LTHIGH || nPart == ITEM_APPR_ARMOR_MODEL_RTHIGH )
        {
            fDistance = 2.5f;
            fPitch = 65.0f;
        }
        else if (        nPart == ITEM_APPR_ARMOR_MODEL_RSHIN || nPart == ITEM_APPR_ARMOR_MODEL_LSHIN    )
        {
            fDistance = 3.5f;
            fPitch = 95.0f;
        }

        if (GetRacialType(oPC)  == RACIAL_TYPE_HALFORC)
        {
            fDistance += 1.0f;
        }

        SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
    }

    int nCost = GetLocalInt(oPC,"X2_TAILOR_CURRENT_COST");
    int nDC = GetLocalInt(oPC,"X2_TAILOR_CURRENT_DC");

    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
    SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));


    SetCustomToken(XP_IP_ITEMMODCONVERSATION_CTOKENBASE,GetStringByStrRef(nStrRef));
}

int CIGetCurrentModPart(object oPC)
{
    return GetLocalInt(oPC,"X2_TAILOR_CURRENT_PART");
}


void CISetDefaultModItemCamera(object oPC)
{
    float fDistance = 3.5f;
    float fPitch =  75.0f;
    float fFacing;

    if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_ARMOR)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }
    else if (CIGetCurrentModMode(oPC) == X2_CI_MODMODE_WEAPON)
    {
        fFacing  = GetFacing(oPC) + 180.0;
        fFacing -= 90.0;
        if (fFacing > 359.0)
        {
            fFacing -=359.0;
        }
    }

    SetCameraFacing(fFacing, fDistance, fPitch,CAMERA_TRANSITION_TYPE_VERY_FAST) ;
}

void CIUpdateModItemCostDC(object oPC, int nDC, int nCost)
{
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_COST", nCost);
        SetLocalInt(oPC,"X2_TAILOR_CURRENT_DC",nDC);
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE,IntToString(nCost));
        SetCustomToken(X2_CI_MODIFYARMOR_GP_CTOKENBASE+1,IntToString(nDC));
}


// dc to modify oOlditem to look like oNewItem
int CIGetWeaponModificationCost(object oOldItem, object oNewItem)
{
   int nTotal = 0;
   int nPart;
   for (nPart = 0; nPart<=2; nPart++)
   {
        if (GetItemAppearance(oOldItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart) !=GetItemAppearance(oNewItem,ITEM_APPR_TYPE_WEAPON_MODEL, nPart))
        {
            nTotal+= (GetGoldPieceValue(oOldItem)/4)+1;
        }
   }

   // Modification Cost should not exceed value of old item +1 GP
   if (nTotal > GetGoldPieceValue(oOldItem))
   {
        nTotal = GetGoldPieceValue(oOldItem)+1;
   }
   return nTotal;
}
