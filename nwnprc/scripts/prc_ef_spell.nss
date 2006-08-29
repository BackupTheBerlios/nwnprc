//:://////////////////////////////////////////////
//:: Spell selection for enleightened fist's  arcane fist/rejuvenation abilities
//:: prc_ef_spell.nss
//:://////////////////////////////////////////////
/** @file
    Spell selection for enleightened fist's  arcane fist/rejuvenation abilities
    Handles the dynamic convo *and* the quickselects

    @author HackyKid
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_spell_const"
#include "prc_alterations"
#include "inc_2dacache"

/* Constant defintions                          */
const int STAGE_ENTRY = 0;
const int STAGE_SLOT  = 1;
const int STAGE_LVL0  = 10;
const int STAGE_LVL9  = 20;


/* Aid functions                                */
void PopulateListNewSpellBook(object oPC, int iClass, int nLevel, int nStart, int nStep, int nChoice)
{
	if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
      	return;

	int i = nStart;

	SendMessageToPC(oPC, "*Tick* *New* *" + IntToString(i) + "* *" + IntToString(iClass) + "*");

	int MaxValue = 0;
	int nClass = PRCGetClassByPosition(iClass);
	if (GetLevelByClass(nClass, oPC) > 0)
	{
		string sFile = GetFileForClass(nClass);
		MaxValue = persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass));
		while (i < MaxValue && i < nStart + nStep)
		{
			int nNewSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nClass), i);
			if (nLevel == StringToInt(Get2DACache(sFile, "Level", nNewSpellbookID)))
			{
				int nSpell = StringToInt(Get2DACache(sFile, "SpellID", nNewSpellbookID));

				string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell)));
				AddChoice(sName, nChoice, oPC);
				SetLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice), nSpell);
				nChoice++;	
			}
			i++;
		}
	}

	if (i >= MaxValue)
	{
		if (iClass == 3) 
		{
			SetDefaultTokens();
			DeleteLocalInt(oPC, "DynConv_Waiting");
			FloatingTextStringOnCreature("*Done*", oPC, FALSE);
			return;
		}
		DelayCommand(0.01, PopulateListNewSpellBook(oPC, iClass + 1, nLevel, 0, nStep, nChoice));
		return;
	}
	DelayCommand(0.01, PopulateListNewSpellBook(oPC, iClass, nLevel, i, nStep, nChoice));
}

void PopulateListBioSpellBook(object oPC, int MaxValue, int nLevel, int nStart, int nStep, int nChoice)
{
	if(GetLocalInt(oPC, "DynConv_Waiting") == FALSE)
      	return;

	int i = nStart;

	SendMessageToPC(oPC, "*Tick* *Bio* *" + IntToString(i) + "*");

	while (i <= MaxValue && i < nStart + nStep)
	{
		if ( Get2DACache("spells", "UserType", i) == "1"
		  && GetHasSpell(i, oPC)
		  && PRCGetSpellLevel(oPC, i) == nLevel
		   )
		{
			string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", i)));
			AddChoice(sName, nChoice, oPC);
			SetLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice), i);
			nChoice++;
		}
		i++;
	}

	if (i > MaxValue)
	{
		DelayCommand(0.01, PopulateListNewSpellBook(oPC, 1, nLevel, 0, 25, nChoice));
	}
	else
	{
		DelayCommand(0.01, PopulateListBioSpellBook(oPC, MaxValue, nLevel, i, nStep, nChoice));
	}
}

void PopulateList(object oPC, int nLevel)
{
	if (!UseNewSpellBook(oPC))
	{
		DelayCommand(0.10, PopulateListBioSpellBook(oPC, 9000, nLevel, 0, 250, 1));
	}
	else
	{
		DelayCommand(0.10, PopulateListNewSpellBook(oPC, 1, nLevel, 0, 25, 1));
	}
}

void main()
{
	int nID = GetSpellId();
	int nValue = GetLocalInt(GetPCSpeaker(), DYNCONV_VARIABLE);


	SendMessageToPC(OBJECT_SELF, "prc_ef_spell:" + IntToString(nID) + " nVal:"+ IntToString(nValue));
	if (nValue != 0) {
		// do conversation
		object oPC = GetPCSpeaker();
		/* Get the value of the local variable set by the conversation script calling
		 * this script. Values:
		 * DYNCONV_ABORTED     Conversation aborted
		 * DYNCONV_EXITED      Conversation exited via the exit node
		 * DYNCONV_SETUP_STAGE System's reply turn
		 * 0                   Error - something else called the script
		 * Other               The user made a choice
		 */
		// The stage is used to determine the active conversation node.
		// 0 is the entry node.
		int nStage = GetStage(oPC);

		if(nValue == DYNCONV_SETUP_STAGE)
		{
			// Check if this stage is marked as already set up
			// This stops list duplication when scrolling
			if(!GetIsStageSetUp(nStage, oPC))
			{
				// variable named nStage determines the current conversation node
				// Function SetHeader to set the text displayed to the PC
				// Function AddChoice to add a response option for the PC. The responses are show in order added
				if(nStage == STAGE_ENTRY)
				{
					SetHeader("Select Spell Level:");
					AddChoice("Level 0", 1, oPC);
					AddChoice("Level 1", 2, oPC);
					AddChoice("Level 2", 3, oPC);
					AddChoice("Level 3", 4, oPC);
					AddChoice("Level 4", 5, oPC);
					AddChoice("Level 5", 6, oPC);
					AddChoice("Level 6", 7, oPC);
					AddChoice("Level 7", 8, oPC);
					AddChoice("Level 8", 9, oPC);
					AddChoice("Level 9", 10, oPC);
					MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
					SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				}
				else if (nStage >= STAGE_LVL0 && nStage <= STAGE_LVL9)
				{
					// Set the header
					SetHeader("Select Spell:");
					int nLevel = nStage - STAGE_LVL0;
					SetLocalInt(oPC, "DynConv_Waiting", TRUE); 

					PopulateList(oPC, nLevel);

					MarkStageSetUp(nStage, oPC);
				}
				else if (nStage = STAGE_SLOT)
				{
					SetHeader("Select QuickSlot:");
					AddChoice("Slot 1", 1, oPC);
					AddChoice("Slot 2", 2, oPC);
					AddChoice("Slot 3", 3, oPC);
					AddChoice("Slot 4", 4, oPC);
					MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
					SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
				}
 
			//add more stages for more nodes with Else If clauses
			}

			// Do token setup
			SetupTokens();
		}
		// End of conversation cleanup
		else if(nValue == DYNCONV_EXITED)
		{
			int nChoice = 1;
			while (GetLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice)))
			{
				DeleteLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice));
				nChoice++;
			}
			DeleteLocalInt(oPC, "EF_SPELL_ID");
		}
		// Abort conversation cleanup.
		// NOTE: This section is only run when the conversation is aborted
		// while aborting is allowed. When it isn't, the dynconvo infrastructure
		// handles restoring the conversation in a transparent manner
		else if(nValue == DYNCONV_ABORTED)
		{
			int nChoice = 1;
			while (GetLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice)))
			{
				DeleteLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice));
				nChoice++;
			}
			DeleteLocalInt(oPC, "EF_SPELL_ID");
		}
		// Handle PC responses
		else
		{
			// variable named nChoice is the value of the player's choice as stored when building the choice list
			// variable named nStage determines the current conversation node
			int nChoice = GetChoice(oPC);
			if(nStage == STAGE_ENTRY)
			{
				nStage = STAGE_LVL0 + nChoice - 1;
				// Move to another stage based on response, for example
				//nStage = STAGE_QUUX;
			} 
			else if (nStage >= STAGE_LVL0 && nStage <= STAGE_LVL9)
			{	
				MarkStageNotSetUp(nStage, oPC);
				int nSpell = GetLocalInt(oPC, "EF_SPELL_CHOICE_" + IntToString(nChoice));

				SetLocalInt(oPC, "EF_SPELL_ID", nSpell);

				nStage = STAGE_SLOT;
			}
			else if (nStage = STAGE_SLOT)
			{
				int nSpell = GetLocalInt(oPC, "EF_SPELL_ID"); 

				SetLocalInt(oPC, "EF_SPELL_QUICK" + IntToString(nChoice), nSpell);
				nStage = STAGE_ENTRY;
			}
			// Store the stage value. If it has been changed, this clears out the choices
			SetStage(nStage, oPC);
		}
	}
	else if (nID == SPELL_EF_SPELL_SELECT_CONVO)
	{
		DelayCommand(1.5, StartDynamicConversation("prc_ef_spell", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF));
	}
	else if (nID == SPELL_EF_SPELL_SELECT_QUICK1)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "EF_SPELL_QUICK1");
		SetLocalInt(oPC, "EF_SPELL_CURRENT", nSpell);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
	}
	else if (nID == SPELL_EF_SPELL_SELECT_QUICK2)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "EF_SPELL_QUICK2");
		SetLocalInt(oPC, "EF_SPELL_CURRENT", nSpell);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
	}
	else if (nID == SPELL_EF_SPELL_SELECT_QUICK3)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "EF_SPELL_QUICK3");
		SetLocalInt(oPC, "EF_SPELL_CURRENT", nSpell);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
	}
	else if (nID == SPELL_EF_SPELL_SELECT_QUICK4)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "EF_SPELL_QUICK4");
		SetLocalInt(oPC, "EF_SPELL_CURRENT", nSpell);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
	}
}
