// ginc_crafting
/*
	Crafting related functions
*/
// ChazM 12/15/05
// ChazM 1/31/06 Moved lots of functions out to their appropriate include files.
// ChazM 1/31/06 Updated/fixed prototypes
// ChazM 2/1/06 Added Alchemy and Distillation.  Renamed and reorganized numerous functions.
// ChazM 2/1/06 Added Wondrous Items
// ChazM 2/2/06 Added various 2DA support
// ChazM 2/2/06 Added ability to use either 2DA or variables depending on if VAR_REC_SET is set.  Reorganized functions.
// ChazM 3/23/06 Added ExecuteDistillation()
// ChazM 3/23/06 Changed Mold suffix to be a mold prefix to match the current data set
// ChazM 3/28/06 Updated crafting to require various feats and skills
// ChazM 3/29/06 Added CasterLevel to Magical/Wondrous Crafting, addded additional error codes 
// ChazM 3/30/06 Added SuccessNotify(), updated Error codes - string refs with real values
// ChazM 4/8/06 Added bIdentify param to CreateListOfItemsInInventory()
// ChazM 4/11/06 Added MakeRepeatedItemList()
// ChazM 4/18/06 Modified CreateMagicalRecipe(), GetTargetItem(), and DoMagicCrafting() to support using item category (instead of tag suffix list)
// ChazM 5/5/06 Changed GetRecipeElement() to GetRecipeIntElement() and GetRecipeStringElement()
// ChazM 5/30/06 Added SetEnchantedItemName() - used in DoMagicCrafting()
// ChazM 5/31/06 Modified SetEnchantedItemName()
// ChazM 5/31/06 added strrefs to SetEnchantedItemName()
// ChazM 7/14/06 Modified DoMagicCrafting() -  Renaming Item only applies to Magic weapons and armor
// ChazM 7/29/06 Fix error in DoMundaneCrafting()
// ChazM 8/1/06 Max item properties set to 3. Masterwork weapons can be renamed on each enchanting, everything else only on the first enchanting
// ChazM 8/11/06 Updated str refs in SetEnchantedItemName()
// ChazM 8/11/06 updated CreateDistillationRecipe() - correction
// ChazM 8/14/06 added GetExpandedTags(), updated GetSortedItemList() - fix for stacks of items
// ChazM 8/16/06 added various workbench identification functions
// ChazM 8/27/06 added temp crafting VFX
// PKM 08.28.06 put in final VFX

#include "x0_i0_stringlib"
#include "ginc_vars"
#include "ginc_item"
#include "ginc_debug"	
#include "ginc_param_const"

// ************************
// *** Constants
// ************************
const string VAR_REC_SET = "RecipiesSet"; // Global Var

const string MAGICAL_RECIPE_PREFIX 		= "MAG";
const string MUNDANE_RECIPE_PREFIX		= "MUN";
const string ALCHEMY_RECIPE_PREFIX		= "ALC";
const string ALCHEMY_RECIPE_SUFFIX		= "ALC"; 
const string DISTILLATION_RECIPE_PREFIX	= "DIS";
const string DISTILLATION_RECIPE_SUFFIX = "DIS";

														// Used by:
const string VAR_RECIPE_COUNT   		= "_COUNT_";	// magical/wondrous, mundane, alchemy, distillation, 
//const string VAR_RECIPE_REAGENTS   		= "_LIST_";		// magical/wondrous, mundane, alchemy, distillation, 
//const string VAR_RECIPE_TAGS       		= "_TAGS_";		// magical only
//const string VAR_RECIPE_EFFECTS    		= "_EFFECT_";	// magical only
//const string VAR_RECIPE_OUTPUT			= "_OUT_";		// wondrous, mundane, alchemy, distillation
//const string VAR_RECIPE_CRAFT_SKILL		= "_SKILL_";	// mundane only
//const string VAR_RECIPE_SKILL_LEVEL		= "_LEVEL_";	// mundane, alchemy, distillation

// apparently this has changed to a suffix.
//const string MOLD_SUFFIX				= "_mld";		// tag of weapon/armor molds must always have this suffix.
const string MOLD_PREFIX				= "n2_crft_mold";		// tag of weapon/armor molds must always have this suffix.

const string VAR_RECIPE_SPELLID_LIST	= "RECIPE_SPELLID_LIST";	// list of SpellID indexes
const string VAR_RECIPE_RESREF_LIST		= "RECIPE_RESREF_LIST";		// list of mold resref inexes

const string VAR_ROW_NUMBER 			= "ROW_NUMBER";				// 2DA Row Number
const string VAR_RECIPE_2DA_INDEXES		= "RECIPE_2DA_INDEXES";		// List of info for index 2DA

const string CRAFTING_2DA 				= "crafting";
const string COL_CRAFTING_CATEGORY 		= "CATEGORY";	// magical/wondrous, mundane, alchemy, distillation, 
const string COL_CRAFTING_REAGENTS 		= "REAGENTS";	// magical/wondrous, mundane, alchemy, distillation, 
const string COL_CRAFTING_TAGS     		= "TAGS";		// magical only
const string COL_CRAFTING_EFFECTS  		= "EFFECTS";	// magical only
const string COL_CRAFTING_OUTPUT		= "OUTPUT";		// wondrous, mundane, alchemy, distillation
const string COL_CRAFTING_CRAFT_SKILL	= "SKILL";		// mundane only
const string COL_CRAFTING_SKILL_LEVEL	= "LEVEL";		// magical/wondrous, mundane, alchemy, distillation

	
const string CRAFTING_INDEX_2DA 		= "crafting_index";
//const string COL_CRAFTING_CATEGORY 	= "CATEGORY";	// this col in both 2DA's
const string COL_CRAFTING_START_ROW		= "START_ROW";

// TODO: these need to be updated to the real string refs
// Error codes - string refs
const int ERROR_ITEM_NOT_DISTILLABLE                = 174285; //"No match found for this item"        
const int ERROR_MISSING_REQUIRED_MOLD               = 174286; //"No mold found"    
const int ERROR_RECIPE_NOT_FOUND                    = 174287; //"No match found for this spell/reagent combo" 
const int ERROR_TARGET_NOT_FOUND_FOR_RECIPE         = 174288; //"couldn't find object for effect to be put on."
const int ERROR_INSUFFICIENT_CASTER_LEVEL           = 174289; //"Not high enough level of spell caster to use this magical recipe"
const int ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL	= 174290;
const int ERROR_INSUFFICIENT_CRAFT_ARMOR_SKILL      = 174291;
const int ERROR_INSUFFICIENT_CRAFT_WEAPON_SKILL     = 174293;
const int ERROR_NO_CRAFT_WONDROUS_FEAT              = 174294;
const int ERROR_NO_CRAFT_MAGICAL_FEAT               = 174295;
const int OK_CRAFTING_SUCCESS                 		= 174296;
const int ERROR_TARGET_HAS_MAX_ENCHANTMENTS			= 182996; // “Item can not be further enchanted.”

const int ERROR_UNRECOGNIZED_MORTAR_USAGE 			= 183206 ; // The mortar & pestle must be used on an alchemist's workbench or on an item.
const int ERROR_UNRECOGNIZED_HAMMER_USAGE 			= 183205 ; // "The smith hammer must be used on a blacksmith's workbench."		

// this variable is stored on the owned character so that script "gui_name_enchanted_item" can retrieve a reference to the item.
const string VAR_ENCHANTED_ITEM_OBJECT 	= "EnchantedItemObject";

// Standard Workbench Tag Prefixes
const string TAG_WORKBENCH_PREFIX1 = "PLC_MC_WBENCH";
const string TAG_WORKBENCH_PREFIX2 = "PLC_MC_CBENCH";

// Alchemy Workbench tags
const string TAG_ALCHEMY_BENCH1 	= "alchemy_bench";
const string TAG_ALCHEMY_BENCH2 	= "PLC_MC_CBENCH01";
const string TAG_ALCHEMY_BENCH3 	= "alchemy";

const string VAR_ALCHEMY			= "WB_alchemy";

// Blacksmith Workbench tags
const string TAG_WORKBENCH1 		= "workbench";
const string TAG_WORKBENCH2 		= "PLC_MC_CBENCH02";
const string TAG_WORKBENCH3 		= "blacksmith";

const string VAR_BLACKSMITH 		= "WB_blacksmith";

						
// just like vector, but with ints
struct IntVector
{
    int x;
 	int y;
	int z;
};

// ************************
// *** Prototypes
// ************************
	
// data functions	
string GetMagicalRecipeVar(string sRecipeVar, int iSpellID);
string GetMundaneRecipeVar(string sRecipeVar, string sMoldResRef);
string GetAlchemyRecipeVar(string sRecipeVar);
string GetDistillationRecipeVar(string sRecipeVar);
string GetRecipeVar(string sRecipeType, string sRecipeVar, string sCategory);
string GetCraftingStringData(string sRecipeType, string sCategory, string sColumn, int iCount);
int GetCraftingIntData(string sRecipeType, string sCategory, string sColumn, int iCount);

// useful functions (may be moved elsewhere)
string MakeList(string sReagent1, string sReagent2="", string sReagent3="", string sReagent4="", string sReagent5="",
            	string sReagent6="", string sReagent7="", string sReagent8="", string sReagent9="", string sReagent10="");
string MakeRepeatedItemList(string sListElement, int iCount);	
string MakeEncodedEffect(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0);
void ApplyEncodedEffectToItem(string sEncodedEffect, object oItem);
void CreateListOfItemsInInventory(string sItemTemplateList, object oTarget, int bIdentify=TRUE);
void DestroyItemsInInventory(int iIncludeCategories = ITEM_CATEGORY_ALL, object oTarget=OBJECT_SELF);
int Search2DA(string s2DA, string sColumn, string sMatchElement, int iStartRow, int iEndRow);
string PadString(int iMinSize, string sValue);

// functions for creating recipes
void CreateMagicalRecipe(int iSpellId, string sEffect, int iItemCategory, string sReagentList, int iCasterLevel=1);
//void CreateMagicalRecipe(int iSpellId, string sEffect, string sTagSuffixList, string sReagentList, int iCasterLevel=1);
void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef, int iCasterLevel=1);
void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef);
void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef);
void CreateDistillationRecipe(int iSkillLevel, string sReagent, string sOutputResRefList);

// **** 2da output related functions
struct IntVector GetRowIndexes(string sCategory);
string GetRecipeStringElement(string sRecipeType, string sRecipeVar, string sCategory, int iCount);
int GetRecipeIntElement(string sRecipeType, string sRecipeVar, string sCategory, int iCount);
string FormatHeaderRow();
string FormatRecipeRow(string sRecipePrefix, string sCategory, int iCount);
int OutputRecipeSet(string sRecipePrefix, string sIndex);
int OutputRecipeType(string sRecipePrefix, string sIndexList);
int OutputRecipes();
string FormatIndexHeaderRow();
string FormatIndexRecipeRow(int iRow, string sCategory, string sRowIndex);
int OutputRecipeIndex();

// private (helper) functions for using recipes
string GetSortedItemList(int iIncludeCategories = ITEM_CATEGORY_ALL, object oTarget=OBJECT_SELF);
int GetInventoryRecipeMatch(string sRecipePrefix, string sIndex, int iIncludeCategories = ITEM_CATEGORY_ALL);
int GetRecipeMatch(string sSortedItemList, string sRecipePrefix, string sIndex);
struct IntVector GetRowIndexes(string sCategory);
int GetCrafting2DARecipeMatch(string sSortedItemList, string sRecipePrefix, string sCategory);
object GetTargetItem(int iItemCategory, object oTarget=OBJECT_SELF);
string FindMundaneIndexTag(string sTagSuffix, object oObject=OBJECT_SELF);

// functions for using recipes
void DoMagicCrafting(int iSpellID, object oPC);
void DoMundaneCrafting(object oPC);
void DoAlchemyCrafting(object oPC);
void DoDistillation(object oItem, object oPC);
void ExecuteDistillation(int iSkillReq, object oItem, object oPC, string sItemTemplateList);
void SuccessNotify(object oPC, int iStrRef=OK_CRAFTING_SUCCESS);
void ErrorNotify(object oPC, int iErrorStrRef);
void SetEnchantedItemName(object oPC, object oItem);

// is workbench functions
int IsWorkbench(object oTarget);
int IsSmithWorkbench(object oTarget);
int IsAlchemyWorkbench(object oTarget);


// ************************
// *** Functions
// ************************

// workbenches should all have 1 of 2 standard prefixes
int IsWorkbench(object oTarget)
{
	int iObjType = GetObjectType(oTarget);
	if (iObjType != OBJECT_TYPE_PLACEABLE) // smith workbench must be a placeable
		return FALSE;

	string sTargetTag = GetTag(oTarget);
	string sTargetTagPrefix = GetStringLeft(sTargetTag, GetStringLength(TAG_WORKBENCH_PREFIX1));
	if ((sTargetTagPrefix == TAG_WORKBENCH_PREFIX1) || (sTargetTagPrefix == TAG_WORKBENCH_PREFIX2))
		return TRUE;
		
	return FALSE;		
}

// Needed by Smith Hammer which works on Smith Workbench
int IsSmithWorkbench(object oTarget)
{
	int iObjType = GetObjectType(oTarget);
	if (iObjType != OBJECT_TYPE_PLACEABLE) // smith workbench must be a placeable
		return FALSE;

	// smith workbench can be identified by it's tag or by a local variable		
	string sTargetTag = GetTag(oTarget);
	if ((sTargetTag == TAG_WORKBENCH1) || (sTargetTag == TAG_WORKBENCH2) || (sTargetTag == TAG_WORKBENCH3))
		return TRUE;
		
	if (GetLocalInt(oTarget, VAR_BLACKSMITH) == TRUE)
		return TRUE;
		
	return FALSE;		
}


// Needed by Mortar & Pestle which only works on Alchemy Workbench
int IsAlchemyWorkbench(object oTarget)
{
	int iObjType = GetObjectType(oTarget);
	if (iObjType != OBJECT_TYPE_PLACEABLE) // alchemy workbench must be a placeable
		return FALSE;

	// alchemy workbench can be identified by it's tag or by a local variable		
	string sTargetTag = GetTag(oTarget);
	if ((sTargetTag == TAG_ALCHEMY_BENCH1) || (sTargetTag == TAG_ALCHEMY_BENCH2) || (sTargetTag == TAG_ALCHEMY_BENCH3))
		return TRUE;
		
	if (GetLocalInt(oTarget, VAR_ALCHEMY) == TRUE)
		return TRUE;
		
	return FALSE;		
}


void output(string sText, object oTarget = OBJECT_SELF)
{
	PrettyMessage(sText);
    //PrintString(sText);
    //AssignCommand(oTarget, SpeakString(sText));
}

	

// ===========================================
// Data Functions
// ===========================================

// Recipe info is stored in globals with the following format:
// MAG_[LIST/TAGS/EFFECT]_<SpellID>_X - where X is the index
string GetMagicalRecipeVar(string sRecipeVar, int iSpellID)
{
	string sVarName = GetRecipeVar(MAGICAL_RECIPE_PREFIX, sRecipeVar, IntToString(iSpellID));
    return (sVarName);
}

// Recipe info is stored in globals with the following format:
// MUN_[LIST/...]_<MoldResRef>_X
string GetMundaneRecipeVar(string sRecipeVar, string sMoldResRef)
{
	string sVarName = GetRecipeVar(MUNDANE_RECIPE_PREFIX, sRecipeVar, sMoldResRef);
    return (sVarName);
}

// Recipe info is stored in globals with the following format:
// ALC_[LIST/...]_ALC_X
string GetAlchemyRecipeVar(string sRecipeVar)
{
	string sVarName = GetRecipeVar(ALCHEMY_RECIPE_PREFIX, sRecipeVar, ALCHEMY_RECIPE_SUFFIX);
    return (sVarName);
}

string GetDistillationRecipeVar(string sRecipeVar)
{
	string sVarName = GetRecipeVar(DISTILLATION_RECIPE_PREFIX, sRecipeVar, DISTILLATION_RECIPE_SUFFIX);
    return (sVarName);
}

	
// Get Recipe Variable Name (used w/ SetGlobalArray*())
string GetRecipeVar(string sRecipeType, string sRecipeVar, string sCategory)
{
    string sVarName = sRecipeType + sRecipeVar + sCategory + "_";
	// tbd: should probably do a check to ensure string length not to long.
    return (sVarName);
}

// Get Specific RecipeElement from global var
string GetRecipeStringElement(string sRecipeType, string sRecipeVar, string sCategory, int iCount)
{
    string sVarRecipeList = GetRecipeVar(sRecipeType, sRecipeVar, sCategory);
    return (GetGlobalArrayString(sVarRecipeList, iCount));
}

// Get Specific RecipeElement from global var
int GetRecipeIntElement(string sRecipeType, string sRecipeVar, string sCategory, int iCount)
{
    string sVarRecipeList = GetRecipeVar(sRecipeType, sRecipeVar, sCategory);
    return (GetGlobalArrayInt(sVarRecipeList, iCount));
}

int UsingVariables()
{	
	return (GetGlobalInt(VAR_REC_SET));
}

// unified crafting data retrieval from global variables or 2da files.
// If globals variables are set then we use global vars.
// sRecipeType 	- var	- magical, mundane, etc - used as prefix of var name
// sCategory	- var	- spell id or other info used to determine var name 
// sColumn		- var/2da 	- the column of data we want (reagents, effects, etc.)
// iCount		- var/2da	- the count for var name -or- the index into the crafting.2da
string GetCraftingStringData(string sRecipeType, string sCategory, string sColumn, int iCount)
{
	string sStringData;
	if (UsingVariables())
	{
    	//string sGlobalArrayVar = GetRecipeVar(sRecipeType, sColumn, sCategory);
    	//sStringData = GetGlobalArrayString(sGlobalArrayVar, iCount);
		sStringData = GetRecipeStringElement(sRecipeType, sColumn, sCategory, iCount);
		
	}
	else // 2da version:
		sStringData = Get2DAString(CRAFTING_2DA, sColumn, iCount);

	return(sStringData);
}

int GetCraftingIntData(string sRecipeType, string sCategory, string sColumn, int iCount)
{
	int iIntData;		
	if (UsingVariables())
		iIntData = GetRecipeIntElement(sRecipeType, sColumn, sCategory, iCount);
	else // 2da version:
		iIntData = StringToInt(Get2DAString(CRAFTING_2DA, sColumn, iCount));

	return(iIntData);
	
	// return (StringToInt(GetCraftingStringData(sRecipeType, sCategory, sColumn, iCount)));
}

// ===========================================
// Useful funcs
// ===========================================

// Set up a list with up to 10 elements
// this list is simply a comma delimited string
// First element is required.
string MakeList(string sReagent1, string sReagent2="", string sReagent3="", string sReagent4="", string sReagent5="",
             	string sReagent6="", string sReagent7="", string sReagent8="", string sReagent9="", string sReagent10="")
{
    string sReagentList;

    sReagentList = sReagent1;
    sReagentList += FormListElement(sReagent2);
    sReagentList += FormListElement(sReagent3);
    sReagentList += FormListElement(sReagent4);
    sReagentList += FormListElement(sReagent5);
    sReagentList += FormListElement(sReagent6);
    sReagentList += FormListElement(sReagent7);
    sReagentList += FormListElement(sReagent8);
    sReagentList += FormListElement(sReagent9);
    sReagentList += FormListElement(sReagent10);

    return (sReagentList);
}

// will create a repeated list of items.
string MakeRepeatedItemList(string sListElement, int iCount)	
{
    string sList;
	int i;
	
	if (iCount >= 1)		
		sList = sListElement;

	for (i=2; i<=iCount; i++)		
    	sList += FormListElement(sListElement);
	

   	return (sList);
}


	
// Property ID required.  See function IPSafeAddItemProperty() in x2_inc_itemprop for supported props and params
// Creates a list containing the property and params for the effect to apply.
string MakeEncodedEffect(int nPropID, int nParam1 = 0, int nParam2 = 0, int nParam3 = 0, int nParam4 = 0)
{
    string sRecipeEffect;

    sRecipeEffect = IntToString(nPropID);
    sRecipeEffect += FormListElement(IntToString(nParam1));
    sRecipeEffect += FormListElement(IntToString(nParam2));
    sRecipeEffect += FormListElement(IntToString(nParam3));
    sRecipeEffect += FormListElement(IntToString(nParam4));

    return (sRecipeEffect);
}



// Apply an encoded effect to an item (created w/ MakeEncodedEffect())
void ApplyEncodedEffectToItem(string sEncodedEffect, object oItem)
{
    output ("applying sEncodedEffect " + sEncodedEffect);

    int nPropID = GetIntParam(sEncodedEffect, 0);
    int nParam1 = GetIntParam(sEncodedEffect, 1);
    int nParam2 = GetIntParam(sEncodedEffect, 2);
    int nParam3 = GetIntParam(sEncodedEffect, 3);
    int nParam4 = GetIntParam(sEncodedEffect, 4);

    itemproperty ip = IPGetItemPropertyByID(nPropID, nParam1, nParam2, nParam3, nParam4);
    IPSafeAddItemProperty(oItem, ip, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

// create a comma delimited list of items in the inventory of oTarget
// bIdentify: -1 leave as default, FALSE (0) - set as not identified, TRUE (1) - set as identified.
void CreateListOfItemsInInventory(string sItemTemplateList, object oTarget, int bIdentify=TRUE)
{
	int nPos = 0;
	string sItemTemplate = GetStringParam(sItemTemplateList, nPos);
	object oCreatedObject;
	while (sItemTemplate != "")
	{
		output ("creating :" + sItemTemplate);
		oCreatedObject = CreateItemOnObject(sItemTemplate, oTarget);
		// 
		if (bIdentify != -1)
			SetIdentified(oCreatedObject, bIdentify);
		nPos++;
 		sItemTemplate = GetStringParam(sItemTemplateList, nPos);
	}
}


// Destroy all items that are not base type armor or weapon
void DestroyItemsInInventory(int iIncludeCategories = ITEM_CATEGORY_ALL, object oTarget=OBJECT_SELF)
{
    object oItem =  GetFirstItemInInventory(oTarget);

    while (GetIsObjectValid(oItem))
    {
        if (GetIsItemCategory(oItem, iIncludeCategories))
        {
            DestroyObject(oItem, 0.2f);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
}

// returns row number of match or -1 if not found.
// searches from start row to endrow
// search stops if empty string is returned (may be due to file, column, or row is not found or entry is "****"
int Search2DA(string s2DA, string sColumn, string sMatchElement, int iStartRow, int iEndRow)
{
	int i;
	string sEntry;
	for (i = iStartRow; i <= iEndRow; i++)
	{
		sEntry = Get2DAString(s2DA, sColumn, i);
		if (sEntry == sMatchElement)
			return i;
		if (sEntry == "")
			return -1;
	}
	return -1;
}


//                                          1         2         3         4         5         6         7         8         9         0   
//            				       1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
const string BLANK_SPACE_100 	= "                                                                                                    ";

// pad string w/ space to MinSize
string PadString(int iMinSize, string sValue)
{
	if (sValue == "" )
		sValue = "****";

	sValue += " ";
	int iLength = GetStringLength(sValue);
	int iNumSpaces = iMinSize - iLength;
	sValue += GetStringLeft(BLANK_SPACE_100, iNumSpaces);
	return (sValue);
}


// ===========================================
// functions for creating recipes
// ===========================================

// Magical recipes always require a spellID which is used as an index to improve search speed
// MAG_COUNT_<SPELL>_ = array count
// MAG_LIST_<SPELL>_X = recipe reagents
// MAG_TAGS_<SPELL>_X = recipe Tag Suffix List
// MAG_EFFECT_<SPELL>_X = recipe Effect
// MAG_LEVEL_<SPELL>_X = caster level required
void CreateMagicalRecipe(int iSpellId, string sEffect, int iItemCategory, string sReagentList, int iCasterLevel=1)
{
	string sNewList = AppendGlobalList(VAR_RECIPE_SPELLID_LIST, IntToString(iSpellId), TRUE);
	//output("new spellid list:" + sNewList);
    string sVarRecipeCount = GetMagicalRecipeVar(VAR_RECIPE_COUNT, iSpellId);
	int iCount = ModifyGlobalInt(sVarRecipeCount, 1);

    string sVarRecipeReagents   = GetMagicalRecipeVar(COL_CRAFTING_REAGENTS, iSpellId);
    string sVarRecipeTags       = GetMagicalRecipeVar(COL_CRAFTING_TAGS, iSpellId);
    string sVarRecipeEffect     = GetMagicalRecipeVar(COL_CRAFTING_EFFECTS, iSpellId);
   	string sVarRecipeCasterLevel= GetMagicalRecipeVar(COL_CRAFTING_SKILL_LEVEL, iSpellId);

    sReagentList = Sort(sReagentList);
	//output("CreateMagicalRecipe: Add " + sReagentList);

    SetGlobalArrayString(sVarRecipeReagents, iCount, sReagentList);
    SetGlobalArrayInt(sVarRecipeTags, iCount, iItemCategory);
    SetGlobalArrayString(sVarRecipeEffect, iCount, sEffect);
    SetGlobalArrayInt(sVarRecipeCasterLevel, iCount, iCasterLevel);
	
//    output ("sVarRecipeEffect = " + sVarRecipeEffect);
//    output ("sEffect = " + sEffect);
}

// Wonderous recipes always require a spellID which is used as an index to improve search speed
// These recipes are stored together with magical weapon/armor recipes.
// MAG_COUNT_<SPELL>_ = array count
// MAG_LIST_<SPELL>_X = recipe reagents
// MAG_OUT_<SPELL>_X = output
// MAG_LEVEL_<SPELL>_X = caster level required
void CreateWondrousRecipe(int iSpellId, string sReagentList, string sOutputResRef, int iCasterLevel=1)
{
	string sNewList = AppendGlobalList(VAR_RECIPE_SPELLID_LIST, IntToString(iSpellId), TRUE);
	//output("new spellid list:" + sNewList);
    string sVarRecipeCount = GetMagicalRecipeVar(VAR_RECIPE_COUNT, iSpellId);
	int iCount = ModifyGlobalInt(sVarRecipeCount, 1);

    string sVarRecipeReagents   = GetMagicalRecipeVar(COL_CRAFTING_REAGENTS, iSpellId);
    string sVarRecipeOutput   	= GetMagicalRecipeVar(COL_CRAFTING_OUTPUT, iSpellId);
   	string sVarRecipeCasterLevel= GetMagicalRecipeVar(COL_CRAFTING_SKILL_LEVEL, iSpellId);

    sReagentList = Sort(sReagentList);
	//output("CreateWondrousRecipe: Add " + sReagentList);

    SetGlobalArrayString(sVarRecipeReagents, iCount, sReagentList);
    SetGlobalArrayString(sVarRecipeOutput, iCount, sOutputResRef);
    SetGlobalArrayInt(sVarRecipeCasterLevel, iCount, iCasterLevel);
}


// Mundane recipes always require a mold which is used as an index to improve search speed
// MUN_COUNT_<MOLD>_ = array count
// MUN_LIST_<MOLD>_X = recipe reagents
// MUN_OUT_<MOLD>_X = output
// MUN_SKILL_<MOLD>_X = skill to be used (int)
// MUN_LEVEL_<MOLD>_X = Level of skill required
void CreateMundaneRecipe(string sMoldTag, int iCraftSkill, int iSkillLevel, string sReagentList, string sOutputResRef)
{
	string sNewList = AppendGlobalList(VAR_RECIPE_RESREF_LIST, sMoldTag, TRUE);
	//output("new resref list:" + sNewList);
	//output("new resref list:" + AppendGlobalList(VAR_RECIPE_RESREF_LIST, sMoldTag, TRUE));
    string sVarRecipeCount = GetMundaneRecipeVar(VAR_RECIPE_COUNT, sMoldTag);
	int iCount = ModifyGlobalInt(sVarRecipeCount, 1);

    string sVarRecipeReagents   = GetMundaneRecipeVar(COL_CRAFTING_REAGENTS, sMoldTag);
    string sVarRecipeOutput   	= GetMundaneRecipeVar(COL_CRAFTING_OUTPUT, sMoldTag);
    string sVarRecipeCraftSkill = GetMundaneRecipeVar(COL_CRAFTING_CRAFT_SKILL, sMoldTag);
    string sVarRecipeSkillLevel	= GetMundaneRecipeVar(COL_CRAFTING_SKILL_LEVEL, sMoldTag);

	sReagentList += FormListElement(sMoldTag); // add mold Res Ref to the list of reagents
    sReagentList = Sort(sReagentList);
	//output("CreateMundaneRecipe: Add recipe [" + IntToString(iCount) + "] - " + sReagentList);

    SetGlobalArrayString(sVarRecipeReagents, iCount, sReagentList);
    SetGlobalArrayString(sVarRecipeOutput, iCount, sOutputResRef);
    SetGlobalArrayInt(sVarRecipeCraftSkill, iCount, iCraftSkill);
    SetGlobalArrayInt(sVarRecipeSkillLevel, iCount, iSkillLevel);
}


// Alchemy recipes have no index.  Note that this means searches will get slower as more and more 
// recipes are added, so it should be kept to less than 50 or so.
void CreateAlchemyRecipe(int iSkillLevel, string sReagentList, string sOutputResRef)
{
    string sVarRecipeCount = GetAlchemyRecipeVar(VAR_RECIPE_COUNT);
	int iCount = ModifyGlobalInt(sVarRecipeCount, 1);

    string sVarRecipeReagents   = GetAlchemyRecipeVar(COL_CRAFTING_REAGENTS);
    string sVarRecipeOutput   	= GetAlchemyRecipeVar(COL_CRAFTING_OUTPUT);
    string sVarRecipeSkillLevel	= GetAlchemyRecipeVar(COL_CRAFTING_SKILL_LEVEL);

    sReagentList = Sort(sReagentList);

    SetGlobalArrayString(sVarRecipeReagents, iCount, sReagentList);
    SetGlobalArrayString(sVarRecipeOutput, iCount, sOutputResRef);
    SetGlobalArrayInt(sVarRecipeSkillLevel, iCount, iSkillLevel);
}


// Distillation recipes have no index.
void CreateDistillationRecipe(int iSkillLevel, string sReagent, string sOutputResRefList)
{
    string sVarRecipeCount = GetDistillationRecipeVar(VAR_RECIPE_COUNT);
	int iCount = ModifyGlobalInt(sVarRecipeCount, 1);

    string sVarRecipeReagents   = GetDistillationRecipeVar(COL_CRAFTING_REAGENTS);
    string sVarRecipeOutput   	= GetDistillationRecipeVar(COL_CRAFTING_OUTPUT);
    string sVarRecipeSkillLevel	= GetDistillationRecipeVar(COL_CRAFTING_SKILL_LEVEL);

    SetGlobalArrayString(sVarRecipeReagents, iCount, sReagent);
    SetGlobalArrayString(sVarRecipeOutput, iCount, sOutputResRefList);
    SetGlobalArrayInt(sVarRecipeSkillLevel, iCount, iSkillLevel);
}

// ====================================================================================
// Output to 2DA
// ====================================================================================

// generate a row of info representing a recipe
string FormatHeaderRow()
{
	PrintString("2DA V2.0");
	PrintString(" ");
	SetGlobalInt(VAR_ROW_NUMBER, -1);

	string sOut = "";
	sOut += PadString(5, " ");   
	sOut += PadString(15, COL_CRAFTING_CATEGORY);   
	sOut += PadString(100,COL_CRAFTING_REAGENTS);   
	sOut += PadString(20, COL_CRAFTING_TAGS);
	sOut += PadString(20, COL_CRAFTING_EFFECTS);
	sOut += PadString(50, COL_CRAFTING_OUTPUT);
	sOut += PadString(10, COL_CRAFTING_CRAFT_SKILL);
	sOut += PadString(10, COL_CRAFTING_SKILL_LEVEL);
	PrintString(sOut);
	return(sOut);
}


// generate a row of info representing a recipe
string FormatRecipeRow(string sRecipePrefix, string sCategory, int iCount)
{
	//output ("*** *** FormatRecipeRow: sRecipePrefix: " + sRecipePrefix + " sCategory:" + sCategory + " iCount:" + IntToString(iCount));
	int iRow = ModifyGlobalInt(VAR_ROW_NUMBER, 1);
	string sOut = "";
	sOut += PadString(5, IntToString(iRow));   
	sOut += PadString(15, sCategory);   
	sOut += PadString(100, GetRecipeStringElement(sRecipePrefix, COL_CRAFTING_REAGENTS	, sCategory, iCount));   
	sOut += PadString(20, IntToString(GetRecipeIntElement(sRecipePrefix, COL_CRAFTING_TAGS    	, sCategory, iCount)));
	sOut += PadString(20, GetRecipeStringElement(sRecipePrefix, COL_CRAFTING_EFFECTS    , sCategory, iCount));
	sOut += PadString(50, GetRecipeStringElement(sRecipePrefix, COL_CRAFTING_OUTPUT		, sCategory, iCount));
	sOut += PadString(10, IntToString(GetRecipeIntElement(sRecipePrefix, COL_CRAFTING_CRAFT_SKILL, sCategory, iCount)));
	sOut += PadString(10, IntToString(GetRecipeIntElement(sRecipePrefix, COL_CRAFTING_SKILL_LEVEL, sCategory, iCount)));
	PrintString(sOut);
	return(sOut);
}


// output all recipes for sRecipePrefix of a specific sIndex
int OutputRecipeSet(string sRecipePrefix, string sIndex)
{
	//AppendGlobalList(VAR_RECIPE_2DA_INDEXES, IntToString(GetGlobalInt(VAR_ROW_NUMBER)));
	AppendGlobalList(VAR_RECIPE_2DA_INDEXES, sIndex);
	AppendGlobalList(VAR_RECIPE_2DA_INDEXES, IntToString(1+GetGlobalInt(VAR_ROW_NUMBER)));

	//output ("*** OutputRecipeSet: sRecipePrefix: " + sRecipePrefix + " sIndex:" + sIndex);
    int iCount = 1;
    string sVarRecipeList = GetRecipeVar(sRecipePrefix, COL_CRAFTING_REAGENTS, sIndex);
    string sRecipeList;
    int bMatch = FALSE;

    sRecipeList = GetGlobalArrayString(sVarRecipeList, iCount);
    //output ("sRecipeList[" + IntToString(iCount) + "] = " + sRecipeList);

    while (sRecipeList != "") 
    {
		FormatRecipeRow(sRecipePrefix, sIndex, iCount);
		iCount++;
		sRecipeList = GetGlobalArrayString(sVarRecipeList, iCount);
		//output ("sRecipeList[" + IntToString(iCount) + "] = " + sRecipeList);
    }
    return (iCount);
}

// output all recipes of specific type, using the list of indexes to find them all
int OutputRecipeType(string sRecipePrefix, string sIndexList)
{
	//output ("OutputRecipeType: sRecipePrefix: " + sRecipePrefix + " sIndexList:" + sIndexList);
	string sIndex;
    struct sStringTokenizer stTok = GetStringTokenizer(sIndexList, ",");
	// loop through recipe index list
    while (HasMoreTokens(stTok)) {
        stTok = AdvanceToNextToken(stTok);
        sIndex = GetNextToken(stTok);
		OutputRecipeSet(sRecipePrefix, sIndex);
    }
	return TRUE;
}


// Output all recipes
int OutputRecipes()
{
	PrintString("Save the following as 'crafting.2da'");
	PrintString("===================================================");

	FormatHeaderRow();
	OutputRecipeType(MAGICAL_RECIPE_PREFIX, GetGlobalString(VAR_RECIPE_SPELLID_LIST));  	
	OutputRecipeType(MUNDANE_RECIPE_PREFIX, GetGlobalString(VAR_RECIPE_RESREF_LIST));	
	OutputRecipeType(ALCHEMY_RECIPE_PREFIX, ALCHEMY_RECIPE_SUFFIX);
	OutputRecipeType(DISTILLATION_RECIPE_PREFIX, DISTILLATION_RECIPE_SUFFIX);

	PrintString("===================================================");
	return TRUE;
}

// generate a row of info representing a recipe
string FormatIndexHeaderRow()
{
	PrintString("2DA V2.0");
	PrintString(" ");

	string sOut = "";
	sOut += PadString(5, " ");   
	sOut += PadString(15, "CATEGORY");   
	sOut += PadString(10, "START_ROW");   
	PrintString(sOut);
	return(sOut);
}

// generate a row of info representing a recipe
string FormatIndexRecipeRow(int iRow, string sCategory, string sRowIndex)
{
	//output ("*** *** FormatRecipeRow: sRecipePrefix: " + sRecipePrefix + " sCategory:" + sCategory + " iCount:" + IntToString(iCount));
	string sOut = "";
	sOut += PadString(5, IntToString(iRow));   
	sOut += PadString(15, sCategory);   
	sOut += PadString(5, sRowIndex);   
	PrintString(sOut);
	return(sOut);
}


// Output all recipes
int OutputRecipeIndex()
{
	int iRow = 0;
	PrintString("Save the following as 'crafting_index.2da'");
	PrintString("===================================================");

	FormatIndexHeaderRow();
	string s2DAIndexList = GetGlobalString(VAR_RECIPE_2DA_INDEXES);
	string sCategory, sRowIndex;
    struct sStringTokenizer stTok = GetStringTokenizer(s2DAIndexList, ",");
	// loop through recipe index list
    while (HasMoreTokens(stTok)) {
        stTok = AdvanceToNextToken(stTok);
        sCategory = GetNextToken(stTok);

        stTok = AdvanceToNextToken(stTok);
        sRowIndex = GetNextToken(stTok);
		FormatIndexRecipeRow(iRow, sCategory, sRowIndex);
		iRow++;
    }
	
	PrintString("===================================================");
	return TRUE;
}


// ====================================================================================
// Helper Functions for Using Recipes
// ====================================================================================

// return a list of tags to represent a stack of items
// never starts or ends w/ a seperator, so can be use just like a single tag for list making
string GetExpandedTags(object oItem)
{
	string sTag = GetTag(oItem);
	int iStackSize = GetItemStackSize(oItem);
	
	if (iStackSize < 1)
		iStackSize = 1; // just in case...
		
	string sRet = MakeRepeatedItemList (sTag, iStackSize);
	return (sRet);
}
	
// get all items in specified categories and sort the tags into an alphabetical list
string GetSortedItemList(int iIncludeCategories = ITEM_CATEGORY_ALL, object oTarget=OBJECT_SELF)
{
    object oItem =  GetFirstItemInInventory(oTarget);
    string sItemList = "";

    while (GetIsObjectValid(oItem))
    {
        if (GetIsItemCategory(oItem, iIncludeCategories))
        {
            if (sItemList == "")
                sItemList += GetExpandedTags(oItem);
            else
                sItemList += FormListElement(GetExpandedTags(oItem));
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    sItemList = Sort(sItemList);
    return (sItemList);
}

// Creates a sorted list from an inventory, including only iIncludeCategories
// return index of the sorted list for this sRecipePrefix and sIndex, -1 if not found
int GetInventoryRecipeMatch(string sRecipePrefix, string sIndex, int iIncludeCategories = ITEM_CATEGORY_ALL)
{
    // list of reagent items in forge
    string sSortedItemList = GetSortedItemList(iIncludeCategories);
	int iRecipeMatch;

	iRecipeMatch = GetRecipeMatch(sSortedItemList, sRecipePrefix, sIndex);
	
	return (iRecipeMatch);
}

// return index of sSortedItemList for this sRecipePrefix and sIndex, -1 if not found
int GetRecipeMatch(string sSortedItemList, string sRecipePrefix, string sIndex)
{
    output ("sSortedItemList = " + sSortedItemList);
    int iCount = 1;

	// do 2da look up instead if not using variables.
	if (!UsingVariables())
	{
		iCount = GetCrafting2DARecipeMatch(sSortedItemList, sRecipePrefix, sIndex);
		return (iCount);
	}

    string sVarRecipeList = GetRecipeVar(sRecipePrefix, COL_CRAFTING_REAGENTS, sIndex);
    string sRecipeList;
    int bMatch = FALSE;

    sRecipeList = GetGlobalArrayString(sVarRecipeList, iCount);
    output ("sRecipeList[" + IntToString(iCount) + "] = " + sRecipeList);

    while ((sRecipeList != "") && (bMatch == FALSE))
    {
        if (sSortedItemList == sRecipeList)
            bMatch = TRUE;
        else
        {
            iCount++;
            sRecipeList = GetGlobalArrayString(sVarRecipeList, iCount);
            output ("sRecipeList[" + IntToString(iCount) + "] = " + sRecipeList);
        }
    }
    if (bMatch == FALSE)
        iCount = -1;

    return (iCount);
}


// returns the start and end index rows for this category
struct IntVector GetRowIndexes(string sCategory)
{
	int iRow = -1;
	struct IntVector iv;
	iv.x = -1;
	iv.y = -1;
	
	int iIndexRow = Search2DA(CRAFTING_INDEX_2DA, COL_CRAFTING_CATEGORY, sCategory, 0, 100);
	if (iIndexRow == -1)
	{
		output ("index not found.");
	}
	else
	{
		iv.x = StringToInt(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_START_ROW, iIndexRow));
 		// ending row is 1 less than the value of the next start row
		iv.y = StringToInt(Get2DAString(CRAFTING_INDEX_2DA, COL_CRAFTING_START_ROW, iIndexRow+1))-1;
		if (iv.y == -1)
			iv.y = 10000; // go to the end.
	}
	return (iv);
}

// return index of sSortedItemList for this sRecipePrefix and sIndex, -1 if not found
int GetCrafting2DARecipeMatch(string sSortedItemList, string sRecipePrefix, string sCategory)
{
    output ("sSortedItemList = " + sSortedItemList);
	int iCrafting2DARow = -1;

	struct IntVector iv = GetRowIndexes(sCategory);
	if (iv.x != -1)	
		iCrafting2DARow = Search2DA(CRAFTING_2DA, COL_CRAFTING_REAGENTS, sSortedItemList, iv.x, iv.y);
	
    return (iCrafting2DARow);
}


// todo - actually use taglist to verify object
// 
object GetTargetItem(int iItemCategory, object oTarget=OBJECT_SELF)
{
    object oItem = OBJECT_INVALID;
    //string sVarTagList = GetMagicalRecipeVar(COL_CRAFTING_TAGS, iSpellId);
    //string sTagList = GetGlobalArrayString(sVarTagList, iCount);

    oItem =  GetFirstItemInInventory(oTarget);
    //string sItemList = "";

    while (GetIsObjectValid(oItem))
    {
        if (GetItemCategory(oItem) == iItemCategory)
            break;
        oItem = GetNextItemInInventory(oTarget);
    }

    return oItem;
}

// looks for first object in inventory with sTagSuffix and returns full tag.
string FindMundaneIndexTag(string sTagPrefix, object oObject=OBJECT_SELF)
{
    object oItem = GetFirstItemInInventory(oObject);
	int iItemCount=0;
	int bFound = FALSE;
	string sRet = "";
	int iPrefixSize = GetStringLength(sTagPrefix);

    while (GetIsObjectValid(oItem) && !bFound)
    {
       	if (GetStringLeft(GetTag(oItem), iPrefixSize) == sTagPrefix)
       	{
			bFound = TRUE;
			sRet = GetTag(oItem);
       	}
		else
       		oItem =  GetNextItemInInventory(oObject);
    }
    return sRet;
}

// Count the number of item properties
int GetNumberItemProperties(object oItem)
{
	int iItemPropCount = 0;
	//Get the first itemproperty
	itemproperty ipLoop=GetFirstItemProperty(oItem);
	
	while (GetIsItemPropertyValid(ipLoop))
	{
		iItemPropCount++;
	   	ipLoop=GetNextItemProperty(oItem);
	}
	return (iItemPropCount);
}


// ====================================================================================
// Functions for Using Recipes
// ====================================================================================

// Spell cast at workstation
// Notes: 
// This covers two types of crafting:
// 1. Magic Crafting requires a set of reagents, an item to work on, and a spell to activate it.	
// 2. Wondrous Crafting, requires a set of reagents and creates a new item.	
//	
// Reagents can not be weapons, armor, or shields.  These are ignored when looking at reagent components
// if more than 1 weapon and/or armor and/or shield is included with the reagents, the one that will be inspected/affected is not defined	
void DoMagicCrafting(int iSpellID, object oPC)
{
	string sIndexTag =  IntToString(iSpellID);
    // is there a match for this spell/reagent combo?
    int iRecipeMatch = GetInventoryRecipeMatch(MAGICAL_RECIPE_PREFIX, sIndexTag, ITEM_CATEGORY_OTHER);
    //output("iRecipeMatch = " + IntToString(iRecipeMatch));
    if (iRecipeMatch == -1)
    {
		ErrorNotify(oPC, ERROR_RECIPE_NOT_FOUND);
         return;
    }

	int bWondrousCrafting = TRUE;
	object oItem;
	    //string sItemTemplate = GetGlobalArrayString(GetMagicalRecipeVar(COL_CRAFTING_OUTPUT, iSpellID), iRecipeMatch);
		// 2da version:
		//string sItemTemplate = Get2DAString(CRAFTING_2DA, COL_CRAFTING_OUTPUT, iRecipeMatch);
	string sItemTemplateList 	= GetCraftingStringData(MAGICAL_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_OUTPUT, iRecipeMatch);
	int iReqCasterLevel 		= GetCraftingIntData(MAGICAL_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch);
	int iItemCategory 			= GetCraftingIntData(MAGICAL_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_TAGS, iRecipeMatch);

	//output ("DoMagicCrafting() sItemTemplate = " + sItemTemplate);
	if (sItemTemplateList == "")	// only wondrous items have output
		bWondrousCrafting = FALSE;

	
	int iReqFeat;
	int iError;
	int iItemPropCount;
	
	// check additional criteria if doing Magical Arms Crafting
	if (bWondrousCrafting)
	{	// wondrous items
		iReqFeat 	= FEAT_CRAFT_WONDROUS_ITEMS;
		iError		= ERROR_NO_CRAFT_WONDROUS_FEAT;
	}
	else
	{	// magical items
		iReqFeat 	= FEAT_CRAFT_MAGIC_ARMS_AND_ARMOR;
		iError		= ERROR_NO_CRAFT_MAGICAL_FEAT;

	    // does the tag match requirements?
	    oItem = GetTargetItem(iItemCategory);
	    //output("oItem = " + GetName(oItem));
	
	    if (!GetIsObjectValid(oItem))
	    {
	        ErrorNotify(oPC, ERROR_TARGET_NOT_FOUND_FOR_RECIPE);
	        return;
	    }
		// examine target
		iItemPropCount = GetNumberItemProperties(oItem);
		if (iItemPropCount >= 3)
	    {
	        ErrorNotify(oPC, ERROR_TARGET_HAS_MAX_ENCHANTMENTS);
	        return;
	    }
	}

    // check caster has feat
    if(!GetHasFeat(iReqFeat,oPC))
	{		
  		ErrorNotify(oPC, iError);
		return;
	}

	// check we are caster of sufficient level
    if(GetCasterLevel(oPC) < iReqCasterLevel)
	{		
  		ErrorNotify(oPC, ERROR_INSUFFICIENT_CASTER_LEVEL);
		return;
	}
		
	// all criteria good to go, do effects
    DestroyItemsInInventory(ITEM_CATEGORY_OTHER);

	if (bWondrousCrafting)
	{	
		CreateListOfItemsInInventory(sItemTemplateList, OBJECT_SELF); // this could be sucked up by RemoveReagents() so must be done after!
	}
	else
	{
		string sEncodedEffect = GetCraftingStringData(MAGICAL_RECIPE_PREFIX, IntToString(iSpellID), COL_CRAFTING_EFFECTS, iRecipeMatch);
		ApplyEncodedEffectToItem(sEncodedEffect, oItem);
	}

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_MAGIC), OBJECT_SELF); // was GetLastSpellCaster()	// Charles, the parameter passed to EffectVisualEffect needs to be changed at your leisure
	SuccessNotify(oPC);
	
	// masterwork weapons can be renamed on each enchanting
	// everything else, only on the first enchanting
	// Renaming Item only applies to Magic weapons and armor
	if (!bWondrousCrafting && 
		( (iItemPropCount <= 0) || (GetStringLeft(GetTag(oItem), 3) == "mst")) )
		SetEnchantedItemName(oPC, oItem);
}



// Smith Hammer used at workstation
// Notes: 
// Mundane crafting requires a set of reagents, a specific skill level, and a smith hammer to activate it. 
// Reagents can be of any item type.
void DoMundaneCrafting(object oPC)
{
    // is there a match for this recipe?
	string sIndexTag = FindMundaneIndexTag(MOLD_PREFIX);
    output("Index (Mold) is:" + sIndexTag);
	
	if (sIndexTag == "")
    {
  		ErrorNotify(oPC, ERROR_MISSING_REQUIRED_MOLD);
        return;
    }

    int iRecipeMatch = GetInventoryRecipeMatch(MUNDANE_RECIPE_PREFIX, sIndexTag, ITEM_CATEGORY_ALL);
    output("iRecipeMatch = " + IntToString(iRecipeMatch));
    if (iRecipeMatch == -1)
    {
  		ErrorNotify(oPC, ERROR_RECIPE_NOT_FOUND);
        return;
    }

    // meet required crafting skill?
	int iSkill 		= GetCraftingIntData(MUNDANE_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_CRAFT_SKILL, iRecipeMatch);
	int iSkillReq 	= GetCraftingIntData(MUNDANE_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch);
	
	int iPCSkill = GetSkillRank(iSkill, oPC);		
	if (iPCSkill < iSkillReq)
	{	// has insufficient skill
		int iError = ERROR_INSUFFICIENT_CRAFT_WEAPON_SKILL;
		if (iSkill == SKILL_CRAFT_ARMOR) {
			iError = ERROR_INSUFFICIENT_CRAFT_ARMOR_SKILL;
		}
   		ErrorNotify(oPC, iError);
		return;
	}

    DestroyItemsInInventory(ITEM_CATEGORY_ALL);

	//CreateOutput(iRecipeMatch, OBJECT_SELF);
	string sItemTemplateList = GetCraftingStringData(MUNDANE_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_OUTPUT, iRecipeMatch);
	CreateListOfItemsInInventory(sItemTemplateList, OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_BLACKSMITH), OBJECT_SELF);	// Charles, the parameter passed to EffectVisualEffect needs to be changed at your leisure
	SuccessNotify(oPC);
}


// Mortar and Pestle used at Alchemy workstation
// Notes: 
// Alchemy crafting requires a set of reagents, a specific skill level in Alchemy, and a Mortar & Pestle to activate it. 
// Reagents can be of any item type.
void DoAlchemyCrafting(object oPC)
{
    // is there a match for this recipe?
	string sIndexTag = ALCHEMY_RECIPE_SUFFIX; // alchemy has no index

    int iRecipeMatch = GetInventoryRecipeMatch(ALCHEMY_RECIPE_PREFIX, sIndexTag, ITEM_CATEGORY_ALL);
    output("iRecipeMatch = " + IntToString(iRecipeMatch));
    if (iRecipeMatch == -1)
    {
   		ErrorNotify(oPC, ERROR_RECIPE_NOT_FOUND);
        return;
    }

    // meet required crafting skill?
	int iSkillReq = GetCraftingIntData(DISTILLATION_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch);
	int iPCSkill = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);		
	if (iPCSkill < iSkillReq)
	{	// has insufficient skill
   		ErrorNotify(oPC, ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL);
		return;
	}
	
    DestroyItemsInInventory(ITEM_CATEGORY_ALL);

	//CreateOutput(iRecipeMatch, OBJECT_SELF);
	string sItemTemplateList = GetCraftingStringData(ALCHEMY_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_OUTPUT, iRecipeMatch);
	CreateListOfItemsInInventory(sItemTemplateList, OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_ALCHEMY), OBJECT_SELF);	// Charles, the parameter passed to EffectVisualEffect needs to be changed at your leisure
	SuccessNotify(oPC);
}

// Mortar and Pestle used on an item
// Notes: 
// Distillation requires an acted upon item (reagent), a specific skill level in Alchemy, and a Mortar & Pestle to activate it. 
// Reagent can be of any item type.
void DoDistillation(object oItem, object oPC)
{
    // is there a match for this recipe?
	string sItemTag = GetTag(oItem);
	string sIndexTag = DISTILLATION_RECIPE_SUFFIX; // distillation has no index

    int iRecipeMatch = GetRecipeMatch(sItemTag, DISTILLATION_RECIPE_PREFIX, sIndexTag);
    output("iRecipeMatch = " + IntToString(iRecipeMatch));
    if (iRecipeMatch == -1)
    {
   		ErrorNotify(oPC, ERROR_ITEM_NOT_DISTILLABLE);
        // output("No match found for this item");
        return;
    }

	// lookup skill req
	int iSkillReq = GetCraftingIntData(DISTILLATION_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_SKILL_LEVEL, iRecipeMatch);

	string sItemTemplateList = GetCraftingStringData(DISTILLATION_RECIPE_PREFIX, sIndexTag, COL_CRAFTING_OUTPUT, iRecipeMatch);
	ExecuteDistillation(iSkillReq, oItem, oPC, sItemTemplateList);
}
	
void ExecuteDistillation(int iSkillReq, object oItem, object oPC, string sItemTemplateList)
{
    // TODO: meet required crafting skill?
	int iPCSkill = GetSkillRank(SKILL_CRAFT_ALCHEMY, oPC);		
	if (iPCSkill < iSkillReq)
	{	// has insufficient skill
   		ErrorNotify(oPC, ERROR_INSUFFICIENT_CRAFT_ALCHEMY_SKILL);
		return;
	}
		
	DestroyObject(oItem);
	CreateListOfItemsInInventory(sItemTemplateList, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_CRAFT_SELF), oPC);	// Charles, the parameter passed to EffectVisualEffect needs to be changed at your leisure
	SuccessNotify(oPC);
}	

void SuccessNotify(object oPC, int iStrRef=OK_CRAFTING_SUCCESS)
{
	SendMessageToPCByStrRef(oPC, iStrRef);
}

void ErrorNotify(object oPC, int iErrorStrRef)
{
	SendMessageToPCByStrRef(oPC, iErrorStrRef);
}	


//PEH-OEI 05/24/06
//This script function displays a text input box popup on the client of the
//player passed in as the first parameter.
//////
// oPC           - The player object of the player to show this message box to
// nMessageStrRef- The STRREF for the Message Box message. 
// sMessage      - The text to display in the message box. Overrides anything 
//               - indicated by the nMessageStrRef
// sOkCB         - The callback script to call if the user clicks OK, defaults
//               - to none. The script name MUST start with 'gui'
// sCancelCB     - The callback script to call if the user clicks Cancel, defaults
//               - to none. The script name MUST start with 'gui'
// bShowCancel   - If TRUE, Cancel Button will appear on the message box.
// sScreenName   - The GUI SCREEN NAME to use in place of the default message box.
//               - The default is SCREEN_STRINGINPUT_MESSAGEBOX 
// nOkStrRef     - The STRREF to display in the OK button, defaults to OK
// sOkString     - The string to show in the OK button. Overrides anything that
//               - nOkStrRef indicates if it is not an empty string
// nCancelStrRef - The STRREF to dispaly in the Cancel button, defaults to Cancel.
// sCancelString - The string to display in the Cancel button. Overrides anything
//				 - that nCancelStrRef indicates if it is anything besides empty string
// sDefaultString- The text that gets copied into the input area,
//				 - used as a default answer
/*
void DisplayInputBox( object oPC, int nMessageStrRef,
						string sMessage, string sOkCB="", 
                        string sCancelCB="", int bShowCancel=FALSE, 
                        string sScreenName="",
                        int nOkStrRef=0, string sOkString="",
                        int nCancelStrRef=0, string sCancelString="",
                        string sDefaultString="", string sVariableString="" );
*/

// oPC = creator of the enchanted item.
// oItem = the enchanted item			
void SetEnchantedItemName(object oPC, object oItem)
{
	int nMessageStrRef 		= 181743;
	string sMessage 		= ""; // "Please rename the item.";
	string sOkCB			= "gui_name_enchanted_item";
	string sCancelCB		= "";
	int bShowCancel			= FALSE; 
	string sScreenName		= "";
	int nOkStrRef			= 181744;
	string sOkString		= "";
	int nCancelStrRef		= 181745;
	string sCancelString	= "";
	string sDefaultString 	= GetFirstName(oItem);
	string sVariableString	= "";
	

	object oObj = oPC; //GetOwnedCharacter(oPC);
	SetLocalObject(oObj, VAR_ENCHANTED_ITEM_OBJECT, oItem);

	DisplayInputBox( oPC, nMessageStrRef, sMessage, sOkCB, sCancelCB, bShowCancel, 
                     sScreenName, nOkStrRef, sOkString, nCancelStrRef, sCancelString,
                     sDefaultString, sVariableString);
}

//void main() {}
		