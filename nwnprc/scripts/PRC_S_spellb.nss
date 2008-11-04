//:://////////////////////////////////////////////
//:: PRC New Spellbooks use conversation
//:: prc_s_spellb
//:://////////////////////////////////////////////
/** @file
    @todo Primo: Could you write a blurb on what
                 this does and TLKify it?


    @author Primogenitor
    @date   Created  - yyyy.mm.dd
	
last changed by motu99, April 29, 2008:

Conversation script for setting up spells to be memorized by prepared casters

This conversation script sets up a persistent array of the spells to be memorized
(at the end of the next rest) for any newspellbook prepared caster class.

It uses the persistent array name prefix "Spellbook", then appends the spell level
(converted to a string) to the prefix and lastly appends the class-nr (converted to a string)

The thus appended prefix is a persistent array name, in which the nSpellbookIDs of the
spells to be memorized at the end of the next rest are stored

the conversation is called by activating the prc_spellbook feat (#1999 in feats.2da)
which fires the spellscript prc_spellbook (#1792 in spells.2da), which then calls this
conversation script
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


// persistant storage format on hide
/**
MEMORIZED SPELLS FOR PREP CASTERS:
All spell levels are all stored in one single array (motu99: very unfortunate, should be changed):
	sArrayName = "NewSpellbookMem_"+IntToString(nClass)
The array is indexed by the spellbookID; the value is the number of spells with that spellbookID still in memory:
	nNrOfSpellsStillInMemory = sArrayName[nSpellbookID]

SPELLS TO BE MEMORIZED BY PREP CASTERS
They are stored in up to ten arrays, one array for each spell level (or rather spell slot level)
	sArrayName = "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nClass)
The array is indexed by the slot number, starting at #0; the value contains the nSpelllbookID of the spell to be memorized
	nSpellbookID = sArrayName[nSlotNr]
 
SPELLS KNOWN BY PREP CASTERS:
so far prep NSB casters know all spells in their class spellbook; they need not learn spells
motu99: This might change, if for instance wizards use the NSB system to gain higher spell slot levels (10+)

SPELLS KNOWN BY SPONT CASTERS:
The spells known are stored in one single array (the array contains only the non-metamagic versions and only master spells)
	sArrayName = "Spellbook" + IntToString(nClass);
The array is indexed by a counter (the i-th spell learned); the value contains the nSpellbookID of the (non-metamagic master) spell known
	nSpellbookID = sArrayName[i]

AVAILABLE SPELL SLOTS FOR SPONT CASTERS:
The nr of still available spell slots for a prep caster are all stored in one single array
	sArrayName =  "NewSpellbookMem_" + IntToString(nClass)
The array is indexed by the spell (slot) level, the value contains the nr of still available slots at that spell (slot) level
	nNrOfSpellSlotsAvailable = sArrayName[nSpellSlotLevel]
*/

// spells in the class spellbook of nClass (a spont caster generally will not know all of these spells)
/**
SPELLS IN THE CLASS SPELLBOOK OF PREP OR SPONT CASTERS:
The spells that are potentially learnable by nClass are stored on the prc cache object in up to 10 different tokens.
The class spell book ONLY stores the masterspells and ONLY the non-metamagicked version!

There is one storage token for every spell level (and class); it has the tag name:
	sTag = "SpellLvl_"+IntToString(nClass)+"_Level_"+IntToString(nSpellLevel);
The spells are stored on the token object oToken (defined by the unique sTag) in an array with name sArrayName
	oToken = GetObjectByTag(sTag)
	sArrayName = "Lkup"
The array is indexed by a counter (the i-th spell of a given level in the class spellbook); the value is the spellbookID
	nSpellbookID = sArrayName[i]
*/

#include "x2_inc_spellhook"
#include "inc_dynconv"
#include "inc_sp_gain_mem"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_CLASS       = 0;
const int STAGE_SELECT_SPELL_LEVEL = 1;
const int STAGE_SELECT_SPELL_SLOT  = 2;
const int STAGE_SELECT_METAMAGIC   = 3;
const int STAGE_SELECT_SPELL       = 4;


const string CONV_SPELLB_CLASS = "SpellClass";
const string CONV_SPELLB_LEVEL = "SpellLevel";
const string CONV_SPELLB_META = "MetaMagic";
const string CONV_SPELLB_SLOT = "SpellSlot";

const int DYNCONV_NEXT_STAGE = -4;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

const string SPELLS_MEMORIZED_CACHE = "SMCCCache";

void DeleteSpellsMemorizedCache(object oPC)
{
	DeleteLocalInt(oPC, SPELLS_MEMORIZED_CACHE);
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "0");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "1");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "2");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "3");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "4");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "5");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "6");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "7");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "8");
	DeleteLocalString(oPC, SPELLS_MEMORIZED_CACHE + "9");
}

// creates a string with a list of memorized spells of the given nClass and nSpellSlotLevel
// each spell has an extra line, which denotes the spell's name 
string ListMemorizedSpells(int nClass, int nSpellSlotLevel, object oPC)
{
	// try to get the list from cache; but only if cache is for the correct nClass
	if (GetLocalInt(oPC, SPELLS_MEMORIZED_CACHE) == nClass)
	{
		return GetLocalString(oPC, SPELLS_MEMORIZED_CACHE + IntToString(nSpellSlotLevel));
	}

	// now build the cache
	
	// get the object on the hide of oPC where the persistant data are stored
	object oToken = GetHideToken(oPC);
	string sSpellsMemorized = GetSpellsMemorized_Array(nClass);

	string sMessage;
	// get the highest nSpellbookID in the spells memorized array
	int nSpellbookID_max = array_get_size(oToken, sSpellsMemorized);
	
	// if the persistant array with the remaining memorized spells does not exist, abort
	if(nSpellbookID_max < 0)
	{
		sMessage = "Error: " +sSpellsMemorized+ " array does not exist";
		if(DEBUG) DoDebug(sMessage);
		return sMessage;
	}

	string sFile = GetNSBDefinitionFileName(nClass);

	string sMessage0, sMessage1, sMessage2, sMessage3, sMessage4, sMessage5, sMessage6, sMessage7, sMessage8, sMessage9;
	
	// go through all nSpellbookIDs (motu99: what a waste of CPU time - prone to TMI)
	int nSpellbookID;
	for(nSpellbookID = 1; nSpellbookID < nSpellbookID_max; nSpellbookID++)
	{
		// get the nr of spells in memory for nSpellbookID (mostly this will be zero)
		int nCount = array_get_int(oToken, sSpellsMemorized, nSpellbookID);
		if(nCount)
		{
			// get metamagic and real SpellID
			int nSpellID = StringToInt(Get2DACache(sFile, "RealSpellID", nSpellbookID));
			int nMetaMagicFeat = StringToInt(Get2DACache(sFile, "ReqFeat", nSpellbookID));
			int nMetaMagic = GetMetaMagicFromFeat(nMetaMagicFeat);

			// determine spell name from spellID by reference
			sMessage = PRC_TEXT_WHITE + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
			// add the metamagic [ext emp] and the nr of spells still in memory
			if (nMetaMagic)	sMessage += " - " +GetMetaMagicString(nMetaMagic);
			// add the nr of spells in memory
			sMessage += PRC_TEXT_BLUE + " [" +IntToString(nCount)+ "]\n";


			// add the information to the string of the correct spell level
			int nLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID)) + GetMetaMagicSpellLevelAdjustment(nMetaMagic);
			switch (nLevel)
			{
				case 0:	sMessage0 += sMessage; break;
				case 1:	sMessage1 += sMessage; break;
				case 2:	sMessage2 += sMessage; break;
				case 3:	sMessage3 += sMessage; break;
				case 4:	sMessage4 += sMessage; break;
				case 5:	sMessage5 += sMessage; break;
				case 6:	sMessage6 += sMessage; break;
				case 7:	sMessage7 += sMessage; break;
				case 8:	sMessage8 += sMessage; break;
				case 9:	sMessage9 += sMessage; break;				
			}
		}
	}
	
	// now store the values for later retrieval
	// remember the class (because this might change during the conversation)
	SetLocalInt(oPC, SPELLS_MEMORIZED_CACHE, nClass);
	if (sMessage0 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "0", sMessage0);
	if (sMessage1 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "1", sMessage1);
	if (sMessage2 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "2", sMessage2);
	if (sMessage3 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "3", sMessage3);
	if (sMessage4 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "4", sMessage4);
	if (sMessage5 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "5", sMessage5);
	if (sMessage6 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "6", sMessage6);
	if (sMessage7 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "7", sMessage7);
	if (sMessage8 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "8", sMessage8);
	if (sMessage9 != "")	SetLocalString(oPC, SPELLS_MEMORIZED_CACHE + "9", sMessage9);
	
	// we delete the cached values on exit from the conversation, so no need to do it now
	// DelayCommand(6.0, DeleteSpellsMemorizedCache(oPC));
	
	return GetLocalString(oPC, SPELLS_MEMORIZED_CACHE + IntToString(nSpellSlotLevel));
}


//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
	object oPC = GetPCSpeaker();
	/* Get the value of the local variable set by the conversation script calling
	 * this script. Values:
	 * DYNCONV_ABORTED     Conversation aborted
	 * DYNCONV_EXITED      Conversation exited via the exit node
	 * DYNCONV_SETUP_STAGE System's reply turn
	 * 0                   Error - something else called the script
	 * Other               The user made a choice
	 */
	int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
	// The stage is used to determine the active conversation node.
	// 0 is the entry node.
	int nStage = GetStage(oPC);

	// Check which of the conversation scripts called the scripts
	if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
		return;

	if(nValue == DYNCONV_SETUP_STAGE)
	{
		// Check if this stage is marked as already set up
		// This stops list duplication when scrolling
		if(!GetIsStageSetUp(nStage, oPC))
		{
			if(nStage == STAGE_SELECT_CLASS)
			{
				//select spell class
				SetHeader("Select a spell book:");
				int i;
				for (i=1; i <= MAX_CLASSES; i++)
				{
					int nClass = GetClassByPosition(i, oPC);
					if (nClass == CLASS_TYPE_INVALID)	break;

					if(	GetIsNSBClass(nClass) && // must be a new spellbook class
						GetSpellbookTypeForClass(nClass) == SPELLBOOK_TYPE_PREPARED) // must be a prepared caster
					{
						// must have levels in the prepared class and at least level 1 spell slots
						int nClassLevel = GetLevelByPosition(i, oPC);
						if (nClassLevel > 0
							&& GetSlotCount(nClassLevel, 1, GetAbilityScoreForClass(nClass, oPC), nClass))
						{
							string sClassName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
							AddChoice(sClassName, nClass, oPC);
						}
					}
				}
				SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				MarkStageSetUp(nStage, oPC);
			}
			else if(nStage == STAGE_SELECT_SPELL_LEVEL)
			{
				int nClass = GetLocalInt(oPC, CONV_SPELLB_CLASS);
				int nCasterLevel = GetCasterLevelByClass(nClass, oPC);

				int nMaxSpellSlotLevel = GetMaxSpellLevelForCasterLevel(nClass, nCasterLevel);
				int nMinSpellSlotLevel = GetMinSpellLevelForCasterLevel(nClass, nCasterLevel);

				int nChoiceAdded = FALSE;
				
				if (nMaxSpellSlotLevel >= nMinSpellSlotLevel)
				{
					string sChoiceSpellLevel = "Spell slot level ";
					int nAbilityScore = GetAbilityScoreForClass(nClass, oPC);

					// List all spell slot levels available to the caster for this class
					int nSpellSlotLevel;
					for(nSpellSlotLevel = nMinSpellSlotLevel; nSpellSlotLevel <= nMaxSpellSlotLevel; nSpellSlotLevel++)
					{
						// for every spell level, determine the slot count, and if it is non-zero add a choice
						// we do not break out of the loop on an empty slot count, because of bonus slot counts from items there might be gaps
						if(GetSlotCount(nCasterLevel, nSpellSlotLevel, nAbilityScore, nClass))
						{
							AddChoice(sChoiceSpellLevel +IntToString(nSpellSlotLevel), nSpellSlotLevel, oPC);
							nChoiceAdded = TRUE;
						}
					}
				}
				
				if (nChoiceAdded)
					SetHeader("Select a spell slot level:");
				else
					SetHeader("You cannot memorize any spells at the moment - check your ability score");

				SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				MarkStageSetUp(nStage, oPC);
			}
			else if(nStage == STAGE_SELECT_SPELL_SLOT)
			{
				int nClass = GetLocalInt(oPC, CONV_SPELLB_CLASS);
				int nSpellSlotLevel = GetLocalInt(oPC, CONV_SPELLB_LEVEL);
				int nCasterLevel = GetCasterLevelByClass(nClass, oPC);

				int nAbilityScore = GetAbilityScoreForClass(nClass, oPC);

				// get the object on the hide of oPC where the persistant data are stored
				object oToken = GetHideToken(oPC);

				// determine the name of the persistant array that holds the spells to be memorized for the given nClass and nSpellLevel
				// (the index to the array is the nr of the slot of the given nClass and nSpellLevel)
				string sSpellsToBeMemorized = GetSpellsToBeMemorized_Array(nClass, nSpellSlotLevel);
				// unfortunatly, the spellsMemorized list has a different format (all spell levels in one huge sparse array, indexed by nSpellbookID)
				string sSpellsMemorized = GetSpellsMemorized_Array(nClass);

				// now check if the arrays "spells to be memorized" and "spells memorized" exist at the given spell slot level and create them, if not
				if (array_get_size(oToken, sSpellsToBeMemorized) < 0)	array_create(oToken, sSpellsToBeMemorized);
				if (array_get_size(oToken, sSpellsMemorized) < 0)		array_create(oToken, sSpellsMemorized);

                string sHeader = "You have remaining:\n";
				sHeader += ListMemorizedSpells(nClass, nSpellSlotLevel, oPC) + "\n";

				// get the nr of spell slots for the given nClass and nSpellLevel
				// (should be non-zero, because we only allow the PC to select spell slot levels with non-zero slot count)
				int nSlots = GetSlotCount(nCasterLevel, nSpellSlotLevel, nAbilityScore, nClass, oPC);
				if (nSlots > 0)
				{
					sHeader += "Select a spell slot:\n"+ PRC_TEXT_WHITE + "spell to be memorized " + PRC_TEXT_BLUE + "[# still in memory]";
						
					// set the array size of "spells to be memorized" and "spells memorized" to the nr of slots
					array_set_size(oToken, sSpellsToBeMemorized, nSlots);

					string sFile = GetNSBDefinitionFileName(nClass);
					string sChoice;
					string sNameToBeMemorized;
					// add a choice for every slot; show what is currently in the slot (if nothing, show "empty")
					int nSlotNr;
					for(nSlotNr = 0; nSlotNr < nSlots; nSlotNr++)
					{
						// get the spell associated with the i-th slot
						int nSpellbookID = array_get_int(oToken, sSpellsToBeMemorized, nSlotNr);
						int nMetaMagic = 0;
						// nothing "to be memorized" for this slot?
						if (nSpellbookID == 0)
						{
							sNameToBeMemorized = "Empty";
						}
						else
						{
							// get the spell name "to be memorized", including metamagic
							// int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
							// sNameToBeMemorized = GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nIPFeatID)));
							int nSpellID = StringToInt(Get2DACache(sFile, "RealSpellID", nSpellbookID));
							sNameToBeMemorized = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));

							nMetaMagic = GetMetaMagicFromFeat(StringToInt(Get2DACache(sFile, "ReqFeat", nSpellbookID)));
							if (nMetaMagic)	sNameToBeMemorized += " - " + GetMetaMagicString(nMetaMagic);
						}

						//first we show what spell will "be memorized" at next rest from the given slot (this is in white)
						sChoice = PRC_TEXT_WHITE + sNameToBeMemorized;

						// now check if there are spells still in memory that are equal to the spell "to be memorized" at the given slot
						if (nSpellbookID)
						{
							int nNrOfSpells_Mem = array_get_int(oToken, sSpellsMemorized, nSpellbookID);
							// show in blue and in brackets
							sChoice += PRC_TEXT_BLUE + " [" +IntToString(nNrOfSpells_Mem)+ "]";
						}
						
						// add the slot nr as choice 
						AddChoice(sChoice, nSlotNr, oPC);
					}
				}
				else
				{
					sHeader += PRC_TEXT_WHITE + "there aren't any slots available at the chosen level - check your ability score";
				}
				SetHeader(sHeader);
				SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				MarkStageSetUp(nStage, oPC);
			}
			else if (nStage == STAGE_SELECT_METAMAGIC)
			{
				// get the metamagic feats oPC possesses
				int nMetaMagicCaster = GetMetaMagicOfCaster(oPC);
				int bChoiceAdded;
				// only need to do this, if the caster has at least one metamagic feat
				if (nMetaMagicCaster)
				{
					// get the currently selected spell slot level
					int nSpellSlotLevel = GetLocalInt(oPC, CONV_SPELLB_LEVEL);					
					int nClass = GetLocalInt(oPC, CONV_SPELLB_CLASS);
					int nCasterLevel = GetCasterLevelByClass(nClass, oPC);
					int nMinSpellSlotLevel = GetMinSpellLevelForCasterLevel(nClass, nCasterLevel);

					// metamagics only for slot levels higher than the lowest slot level
					if (nSpellSlotLevel > nMinSpellSlotLevel)
					{
						// calculate the maximum metamagic adjustment that is possible at the given spell slot level
						// note that the metamagic adjustment will generally result in spells to choose from, that are
						// lower in level than the spell slot level. But we cannot reduce the level below the minimum spell level of the class
						int nMaxMetaMagicAdj = nSpellSlotLevel - nMinSpellSlotLevel;

						// go through all possible metamagics by shifting 1 to the left
						// this will result in checking for some metamagics that are not implemented
						// but the check against the metamagic feats possessed be oPC will get rid of all non-implemented
						int nMetaMagic;
						for (nMetaMagic = 1; nMetaMagic < 0x40; nMetaMagic <<= 1)
						{
							if ((nMetaMagicCaster & nMetaMagic) // caster must have the metamagic feat
								// and the combined levels of the already chosen metamagic with the metamagic to choose must be
								// less or equal than the max metamagic adjustment allowed for nClass at the given nSpellSlotLevel
								&& GetMetaMagicSpellLevelAdjustment(nMetaMagic) <= nMaxMetaMagicAdj)
							{
								AddChoice(GetMetaMagicString(nMetaMagic), nMetaMagic, oPC);
								bChoiceAdded = TRUE;
							}
						}
						
						if (bChoiceAdded)
						{
							SetHeader("Select a metamagic adjustment:");
							AddChoice("No metamagic", 0, oPC);
							SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
						}
					}
				}
				
				// no metamagics available at the spell slot level?
				if (!bChoiceAdded)
				{
					// then advance to next stage and clear metamagic
					SetStage(++nStage, oPC);
					DeleteLocalInt(oPC, CONV_SPELLB_META);
				}

				MarkStageSetUp(STAGE_SELECT_METAMAGIC, oPC);				
			}
			
			// if-clause is intentional; DONT change to else-if
			if(nStage == STAGE_SELECT_SPELL)
			{
				int nClass = GetLocalInt(oPC, CONV_SPELLB_CLASS);
				int nMetaMagic = GetLocalInt(oPC, CONV_SPELLB_META);
				int nSpellSlotLevel = GetLocalInt(oPC, CONV_SPELLB_LEVEL);
				int nSpellLevel = nSpellSlotLevel - GetMetaMagicSpellLevelAdjustment(nMetaMagic);
				
				// determine from where to get the spells known (for nClass at the given level)
				// so far this is the class spellbook, eg. all spells are available (divine casters)
				object oToken = GetSpellsOfClass_Token(nClass, nSpellLevel);
				string sSpellBook = GetSpellsOfClass_Array();
				string sFile = GetNSBDefinitionFileName(nClass);

				// go through all spells that oPC has in his spellbook at the given nSpellLevel ( for divine casters this might be all) 
				// motu99: This array does NOT include the metamagicked versions of the spells or subradial versions!
				int nSpellsKnown = array_get_size(oToken, sSpellBook);
				int bSpellSelected = FALSE;
				int i;
				for(i = 0; i < nSpellsKnown; i++)
				{
					// this is the cls_spell_* row nr for the UNMETAMAGICKED version of the spell
					int nSpellbookID = array_get_int(oToken, sSpellBook, i);
					
					// get the real spellID
					int nSpellID = StringToInt(Get2DACache(sFile, "RealSpellID", nSpellbookID));
					
					// if we choose a metamagic, find the nSpellbookID for the metamagic version of the spell
					// all metamagic versions of the master spell lie in a consecutive block after the non-metamagic version
					if (nMetaMagic)
					{
						// get the next row in cls_spell_* and test if it belongs to the same real spellID
						while (StringToInt(Get2DACache(sFile, "RealSpellID", ++nSpellbookID)) == nSpellID)
						{
							// do the metamagics match?
							if (nMetaMagic == GetMetaMagicFromFeat(StringToInt(Get2DACache(sFile, "ReqFeat", nSpellbookID))))
							{
								// indicate success by negative nr
								nSpellbookID = -nSpellbookID;
								break;
							}
						}
						
						// success? then redo the negation
						if (nSpellbookID < 0)
							nSpellbookID = -nSpellbookID;
						// otherwise indicate failure by setting nSpellbookID to zero
						else
							nSpellbookID = 0;
					}

					// did we find an appropriate spellbook ID for the given spell slot evel and metamagic?
					// then add it to the list
					if (nSpellbookID)
					{
						// int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
						// string sName = GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nIPFeatID)));
						string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
						if (nMetaMagic)	sName + " - " +GetMetaMagicString(nMetaMagic);

						AddChoice(sName, nSpellbookID, oPC);
						bSpellSelected = TRUE;
					}
				}
				
				if (bSpellSelected)
					SetHeader("Select a spell:");
				else
					SetHeader("No spells to select at spell level " + IntToString (nSpellLevel));
						
				SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				MarkStageSetUp(nStage, oPC);
			}
		}

		// Do token setup
		SetupTokens();
	}
	else if(nValue == DYNCONV_EXITED ||
			nValue == DYNCONV_ABORTED )
	{
		//end of conversation cleanup
		DeleteLocalInt(oPC, CONV_SPELLB_CLASS);
		DeleteLocalInt(oPC, CONV_SPELLB_LEVEL);
		DeleteLocalInt(oPC, CONV_SPELLB_SLOT);
		DeleteLocalInt(oPC, CONV_SPELLB_META);

		DeleteSpellsMemorizedCache(oPC);
	}
	else
	{
		int nChoice = GetChoice(oPC);
		if(nStage == STAGE_SELECT_CLASS)
		{
		   //store nClass and proceed to slot level selection
			SetLocalInt(oPC, CONV_SPELLB_CLASS, nChoice);			
			nStage = STAGE_SELECT_SPELL_LEVEL;
			MarkStageNotSetUp(nStage, oPC);
		}
		else if(nStage == STAGE_SELECT_SPELL_LEVEL)
		{
			//store slot level and proceed to spell slot selection
			SetLocalInt(oPC, CONV_SPELLB_LEVEL, nChoice);			
			nStage = STAGE_SELECT_SPELL_SLOT;
			MarkStageNotSetUp(nStage, oPC);
		}
		else if(nStage == STAGE_SELECT_SPELL_SLOT)
		{
			// store the spell slot nr and go to metamagic selection phase
			SetLocalInt(oPC, CONV_SPELLB_SLOT, nChoice);
			nStage = STAGE_SELECT_METAMAGIC;
			MarkStageNotSetUp(nStage, oPC);
		}
		else if(nStage == STAGE_SELECT_METAMAGIC)
		{
			// store the metamagic and proceed to spell selection phase
			SetLocalInt(oPC, CONV_SPELLB_META, nChoice);
			nStage = STAGE_SELECT_SPELL;
			MarkStageNotSetUp(nStage, oPC);
		}
		else if(nStage == STAGE_SELECT_SPELL)
		{
			// our choice is the nSpellbookID
			
			// get the other vital information
			int nSpellSlot = GetLocalInt(oPC, CONV_SPELLB_SLOT);
			int nSpellSlotLevel = GetLocalInt(oPC, CONV_SPELLB_LEVEL);
			int nClass = GetLocalInt(oPC, CONV_SPELLB_CLASS);
			int nMetaMagic = GetLocalInt(oPC, CONV_SPELLB_META);
			
			// get the object on the hide of oPC where the persistant data are stored
			object oToken = GetHideToken(oPC);
			// determine the name of the persistant array that holds the spells to be memorized for the given nClass and nSpellLevel
			// (the index to the array is the nr of the slot of the given nClass and nSpellLevel)
			string sSpellsToBeMemorized = GetSpellsToBeMemorized_Array(nClass, nSpellSlotLevel);

			// store the chosen nSpellbookID (row nr in the newspellbook file cls_spells_*) in the spells to be memorized array
			array_set_int(oToken, sSpellsToBeMemorized, nSpellSlot, nChoice);

			// let oPC select a new spell (starting with the spell level)
			nStage = STAGE_SELECT_SPELL_LEVEL;
			MarkStageNotSetUp(nStage, oPC);
		}

		// Store the stage value. If it has been changed, this clears out the choices
		SetStage(nStage, oPC);
	}
}

