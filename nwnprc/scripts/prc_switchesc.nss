//:://////////////////////////////////////////////
//:: PRC Switch manipulation conversation
//:: prc_switchesc
//:://////////////////////////////////////////////
/** @file
    This conversation is used for changing values
    of the PRC switches ingame.

    @todo Primo: TLKify this

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"
#include "inc_epicspells"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY               = 0;
const int STAGE_SWITCHES            = 1;
const int STAGE_SWITCHES_VALUE      = 2;
const int STAGE_EPIC_SPELLS         = 3;
const int STAGE_EPIC_SPELLS_ADD     = 4;
const int STAGE_EPIC_SPELLS_REMOVE  = 5;
const int STAGE_EPIC_SPELLS_CONTING = 6;
const int STAGE_SHOPS               = 8;
const int STAGE_TEFLAMMAR_SHADOWLORD= 9;
const int STAGE_LEADERSHIP          =10;
const int STAGE_LEADERSHIP_ADD      =11;
const int STAGE_LEADERSHIP_ADD_CONFIRM = 13;
const int STAGE_LEADERSHIP_REMOVE   =12;

const int CHOICE_RETURN_TO_PREVIOUS = 0xFFFFFFFF;


//////////////////////////////////////////////////
/* Aid functions                                */
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
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("What do you want to do?");
                AddChoice("Alter code switches.", 1);
                if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
                    GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
                    AddChoice("Manage Epic Spells.", 2);
                AddChoice("Purchase general items, such as scrolls or crafting materials.", 3);
                AddChoice("Attempt to identify everything in my inventory.", 4);
                if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
                    AddChoice("Join the Shadowlords as a prerequisited for the Teflammar Shadowlord class.", 5);
                AddChoice("Register this character as a cohort.", 6);
                if(GetHasFeat(FEAT_LEADERSHIP, oPC))
                    AddChoice("Manage cohorts.", 6);

                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SWITCHES)
            {
                SetHeader("Select a variable to modify.\n"
                        + "See prc_inc_switches for descriptions.\n"
                        + "In most cases zero is off and any other value is on."
                         );

                // First choice is Back, so people don't have to scroll ten pages to find it
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                // Get the switches container waypoint, and call the builder function if it doesn't exist yet (it should)
                object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                if(!GetIsObjectValid(oWP))
                {
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP did not exist, attempting creation");
                    CreateSwitchNameArray();
                    oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP " + (GetIsObjectValid(oWP) ? "created":"not created"));
                }
                int i;
                for(i = 0; i < array_get_size(oWP, "Switch_Name"); i++)
                {
                    AddChoice(array_get_string(oWP, "Switch_Name", i), i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SWITCHES_VALUE)
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                int nVal = GetPRCSwitch(sVarName);

                SetHeader("CurrentValue is: " + IntToString(nVal) + "\n"
                        + "CurrentVariable is: " + sVarName + "\n"
                        + "Select an ammount to modify the variable by:"
                          );

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                AddChoice("-10", -10);
                AddChoice("-5", -5);
                AddChoice("-4", -4);
                AddChoice("-3", -3);
                AddChoice("-2", -2);
                AddChoice("-1", -1);
                AddChoice("+1", 1);
                AddChoice("+2", 2);
                AddChoice("+3", 3);
                AddChoice("+4", 4);
                AddChoice("+5", 5);
                AddChoice("+10", 10);
            }
            else if(nStage == STAGE_EPIC_SPELLS)
            {
                SetHeader("Make a selection.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                if(GetCastableFeatCount(oPC)>0)
                    AddChoice("Remove an Epic Spell from the radial menu.", 1);
                if(GetCastableFeatCount(oPC)<7)
                    AddChoice("Add an Epic Spell to the radial menu.", 2);
                //AddChoice("Manage any active contingencies.", 3);
                AddChoice("Research an Epic Spell.", 4);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_ADD)
            {
                SetHeader("Choose the spell to add.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nResearchedFeat = StringToInt(Get2DACache("epicspells", "ResFeatID", i));
                    if(GetHasFeat(nResearchedFeat, oPC))
                    {
                        string sName = GetStringByStrRef(
                            StringToInt(Get2DACache("feat", "FEAT", StringToInt(
                                Get2DACache("epicspells", "FeatID", i)))));
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
            {
                SetHeader("Choose the spell to remove.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nFeat = StringToInt(Get2DACache("epicspells", "FeatID", i));
                    if(GetHasFeat(nFeat, oPC))
                    {
                        string sName = GetStringByStrRef(
                            StringToInt(Get2DACache("feat", "FEAT", StringToInt(
                                Get2DACache("epicspells", "FeatID", i)))));
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_CONTING)
            {
                SetHeader("Choose an active contingency to dispel. Dispelling will pre-emptively end the contingency and restore the reserved epic spell slot for your use.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SHOPS)
            {
                SetHeader("Select what type of item you wish to purchase.");
                if(GetHasFeat(FEAT_CRAFT_ITEM, oPC))
                    AddChoice("Crafting recipes", 1);
                if(GetHasFeat(FEAT_BREW_POTION, oPC)
                    || GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)
                    || GetHasFeat(FEAT_CRAFT_WAND, oPC))
                    AddChoice("Magic item raw materials", 2);
                AddChoice("Spell scrolls", 3);
                if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
                    GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
                    AddChoice("Epic spell books", 4);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
            {
                SetHeader("This will cost you 10,000 GP, are you prepared to pay this?");
                if(GetGold(oPC) >= 10000)
                    AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP)
            {
                SetHeader("What do you want to change?");
                if(GetCurrentCohortCount(oPC) < GetMaximumCohortCount(oPC))
                    AddChoice("Recruit a new cohort", 1);
                if(GetCurrentCohortCount(oPC))
                    AddChoice("Dismiss an existing cohort", 2);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD)
            {
                SetHeader("Select a cohort:");

                int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
                int i;
                for(i=1;i<=nCohortCount;i++)
                {
                    string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
                    int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_race");
                    int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_class1");
                    int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_class2");
                    int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_class3");
                    int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_order");
                    int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(i)+"_moral");
                    string sKey  = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(i)+"_cdkey");
                    if(GetPCPublicCDKey(oPC) == ""
                        ||GetPCPublicCDKey(oPC) == sKey)
                        AddChoice("sName", i);
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CONFIRM)
            {
                string sHeader = "Are you sure you want this cohort?";

                int nCohortID = GetLocalInt(oPC, "CohortID");
                string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_name");
                int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_race");
                int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class1");
                int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class2");
                int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class3");
                int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_order");
                int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_moral");
                sHeader +="\nsName";
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass1)));
                if(nClass2 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass2)));
                if(nClass3 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass3)));
                SetHeader(sHeader);
                AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
    }
    else
    {
        // PC response handling
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == 1)
                nStage = STAGE_SWITCHES;
            else if(nChoice == 2)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 3)
                nStage = STAGE_SHOPS;
            else if(nChoice == 4)
                // Does not abort the conversation, it seems
                // Not supposed to, you can abort manually afterwards
                AssignCommand(oPC, TryToIDItems(oPC));
            else if(nChoice == 5)
                nStage = STAGE_TEFLAMMAR_SHADOWLORD;
            else if(nChoice == 6)
                // Does not abort the conversation, it seems
                //any way to fix this because here it really should
                RegisterAsCohort(oPC);
            else if(nChoice == 7)
                nStage = STAGE_LEADERSHIP;

            // Mark the target stage to need building if it was changed (ie, selection was other than ID all)
            if(nStage != STAGE_ENTRY)
                MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                //move to another stage based on response
                SetLocalString(oPC, "VariableName", GetChoiceText(oPC));
                nStage = STAGE_SWITCHES_VALUE;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES_VALUE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                nStage = STAGE_SWITCHES;
            }
            else
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                SetPRCSwitch(sVarName, GetPRCSwitch(sVarName) + nChoice);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
                nStage = STAGE_EPIC_SPELLS_ADD;
            else if (nChoice == 2)
                nStage = STAGE_EPIC_SPELLS_REMOVE;
            else if (nChoice == 3)
                nStage = STAGE_EPIC_SPELLS_CONTING;
            else if (nChoice == 4)
            {
                //research an epic spell
                object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ess_research", GetLocation(oPC));
                AssignCommand(oPC, DoPlaceableObjectAction(oPlaceable, PLACEABLE_ACTION_USE));
                DestroyObject(oPlaceable, 60.0);
            }

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_ADD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
                GiveFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
                TakeFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_CONTING)
        {
            //contingencies
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SHOPS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
            {
                //Crafting recipes
                object oStore = GetObjectByTag("prc_recipe");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_recipe", lLimbo);
                }
                OpenStore(oPC, oStore);
            }
            else if (nChoice == 2)
            {
                //Magic item raw materials
                object oStore = GetObjectByTag("prc_magiccraft");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_magiccraft", lLimbo);
                }
                OpenStore(oPC, oStore);
            }
            else if (nChoice == 3)
            {
                //Spell scrolls
            }
            else if (nChoice == 4)
            {
                //Epic spell books
                object oStore = GetObjectByTag("prc_epicspells");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_epicspells", lLimbo);
                }
                OpenStore(oPC, oStore);
            }

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
        {
            nStage = STAGE_ENTRY;
            if(nChoice == 1)
            {
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));
                CreateItemOnObject("shadowwalkerstok", oPC);
                SetLocalInt(oPC, "X1_AllowShaLow", 0);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP)
        {
            if(nChoice == 1)
                nStage = STAGE_LEADERSHIP_ADD;
            else if(nChoice == 2)
                nStage = STAGE_LEADERSHIP_REMOVE;
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD)
        {
            SetLocalInt(oPC, "CohortID", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {

            }
            else
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                RemoveCohortFromPlayer(GetCohort(nCohortID, oPC), oPC);
            }
            nStage = STAGE_LEADERSHIP;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CONFIRM)
        {
            if(nChoice == 1)
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                AddCohortToPlayer(nCohortID, oPC);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP_ADD;
            MarkStageNotSetUp(nStage, oPC);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
