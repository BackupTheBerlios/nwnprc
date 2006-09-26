//:://////////////////////////////////////////////
//:: Appearance changing dynamic conversation
//:: appearconv.nss
//:://////////////////////////////////////////////
/** @file
    Conversation to change appearance
    
    Allows for add/remove wings/tails, head changes,
    portrait, and overall appearance


    @author Primogenitor
    @date   Created  - 2006.09.26
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                       =  0;
const int STAGE_APPEARANCE                  = 10;
const int STAGE_HEAD                        = 20;
const int STAGE_WINGS                       = 30;
const int STAGE_TAIL                        = 40;
const int STAGE_BODYPART                    = 50;
const int STAGE_BODYPART_CHANGE             = 51;
const int STAGE_PORTRAIT                    = 60;
const int STAGE_EQUIPMENT                   = 90;

const int CHOICE_RETURN_TO_PREVIOUS             = 0xEFFFFFFF;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddPortraits(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("portraits", "Race", i) != "")
        {
            sName = Get2DACache("portraits", "BaseResRef", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddPortraits(i, nMax, oPC));        
}

void AddTails(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("tailmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("wingmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddTails(i, nMax, oPC));        
}

void AddWings(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("wingmodel", "MODEL", i) != "")
        {
            sName = Get2DACache("wingmodel", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddWings(i, nMax, oPC));
}

void AddAppearances(int nMin, int nMax, object oPC)
{
    int i;
    string sName;
    for(i=nMin;i<nMin+100;i++)
    {
        //test for model
        if(Get2DACache("appearance", "RACE", i) != "")
        {
            //test for tlk name
            sName = GetStringByStrRef(StringToInt(Get2DACache("appearance", "STRING_REF", i)));
            //no tlk name, use label
            if(sName == "")
                sName = Get2DACache("appearance", "LABEL", i);
            AddChoice(sName, i, oPC);
        }
    }
    if(i < nMax)
        DelayCommand(0.00, AddAppearances(i, nMax, oPC));
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
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_ENTRY)
            {
                // Set the header
                SetHeader("What aspect of your appearance do you wish to alter?");
                // Add responses for the PC
                AddChoice("Model", 1, oPC);
                int bCanHaveWings;
                int bCanHaveTail;
                string sModelType = Get2DACache("appearance", "MODELTYPE", GetLocalInt(OBJECT_SELF, "Appearance"));
                if(sModelType == "P")
                {
                    bCanHaveTail=TRUE;
                    bCanHaveWings=TRUE;
                }
                else
                {
                    if(TestStringAgainstPattern("**W**", sModelType))
                        bCanHaveWings=TRUE;
                    if(TestStringAgainstPattern("**T**", sModelType))
                        bCanHaveTail=TRUE;
                }
                if(sModelType == "P")
                    AddChoice("Head", 2, oPC);
                if(bCanHaveWings)
                    AddChoice("Wings", 3, oPC);
                if(bCanHaveTail)
                    AddChoice("Tail", 4, oPC);
                if(sModelType == "P")
                    AddChoice("Other bodypart including tattoos", 5, oPC);
                //AddChoice("Equipment", 6, oPC);

                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_APPEARANCE)
            {
                SetHeader("Select an appearance to assume");
                AddChoice("Return to previous", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddAppearances(0, GetPRCSwitch(FILE_END_APPEARANCE), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_HEAD)
            {
                SetHeader("Select a head");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Goto first head", 1, oPC);
                AddChoice("Next head", 2, oPC);
                if(GetCreatureBodyPart(CREATURE_PART_HEAD, oPC) > 0)
                    AddChoice("Previous head", 3, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_WINGS)
            {
                SetHeader("");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddWings(0, GetPRCSwitch(FILE_END_WINGS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_TAIL)
            {
                SetHeader("");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddTails(0, GetPRCSwitch(FILE_END_TAILS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_BODYPART)
            {
                SetHeader("Which bodypart?");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Right shin",     CREATURE_PART_RIGHT_SHIN, oPC);
                AddChoice("Left shin",      CREATURE_PART_LEFT_SHIN, oPC);
                AddChoice("Right thigh",    CREATURE_PART_RIGHT_THIGH, oPC);
                AddChoice("Left thigh",     CREATURE_PART_LEFT_THIGH, oPC);
                AddChoice("Torso",          CREATURE_PART_TORSO, oPC);
                AddChoice("Right forearm",  CREATURE_PART_RIGHT_FOREARM, oPC);
                AddChoice("Left forearm",   CREATURE_PART_LEFT_FOREARM, oPC);
                AddChoice("Right bicep",    CREATURE_PART_RIGHT_BICEP, oPC);
                AddChoice("Left bicep",     CREATURE_PART_LEFT_BICEP, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_BODYPART_CHANGE)
            {
                SetHeader("Select a change");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddChoice("Goto first bodypart", 1, oPC);
                AddChoice("Next bodypart", 2, oPC);
                int nPart = GetLocalInt(oPC, "BodypartToChange");
                if(GetCreatureBodyPart(nPart, oPC) > 0)
                    AddChoice("Previous bodypart", 3, oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_PORTRAIT)
            {
                SetHeader("");
                AddChoice("Return to previous step", CHOICE_RETURN_TO_PREVIOUS, oPC);
                AddPortraits(0, GetPRCSwitch(FILE_END_PORTRAITS), oPC);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_EQUIPMENT)
            {
                //disabled at moment
                SetHeader("");
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "BodypartToChange");
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "BodypartToChange");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == 1)
                nStage = STAGE_APPEARANCE;
            else if(nChoice == 2)
                nStage = STAGE_HEAD;
            else if(nChoice == 3)
                nStage = STAGE_WINGS;
            else if(nChoice == 4)
                nStage = STAGE_TAIL;
            else if(nChoice == 5)
                nStage = STAGE_BODYPART;
            else if(nChoice == 4)
                nStage = STAGE_EQUIPMENT;
        }
        else if(nStage == STAGE_APPEARANCE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureAppearanceType(oPC, nChoice);    
             
        }
        else if(nStage == STAGE_HEAD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                //need to regenerate the list so go lower disappears correctly
                MarkStageSetUp(nStage, oPC); 
                if(nChoice == 1)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, 1, oPC);   
                else if(nChoice == 2)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, GetCreatureBodyPart(CREATURE_PART_HEAD, oPC)+1, oPC);  
                else if(nChoice == 3)
                    SetCreatureBodyPart(CREATURE_PART_HEAD, GetCreatureBodyPart(CREATURE_PART_HEAD, oPC)-1, oPC);   
            }    
             
        }
        else if(nStage == STAGE_WINGS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureWingType(nChoice, oPC);    
             
        }
        else if(nStage == STAGE_TAIL)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
                SetCreatureTailType(nChoice, oPC);    
             
        }
        else if(nStage == STAGE_BODYPART)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                SetLocalInt(oPC, "BodypartToChange", nChoice);
                nStage = STAGE_BODYPART_CHANGE;
            }
        }    
        else if(nStage == STAGE_BODYPART_CHANGE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_BODYPART;
            else
            {
                int nPart = GetLocalInt(oPC, "BodypartToChange");
                if(nChoice == 1)
                    SetCreatureBodyPart(nPart, 1, oPC);   
                else if(nChoice == 2)
                    SetCreatureBodyPart(nPart, GetCreatureBodyPart(nPart, oPC)+1, oPC);  
                else if(nChoice == 3)
                    SetCreatureBodyPart(nPart, GetCreatureBodyPart(nPart, oPC)-1, oPC);  
            
            }
        }  
        else if(nStage == STAGE_PORTRAIT)
        {  
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else
            {
                string sPortraitResRef = Get2DACache("portraits", "BaseResRef", nChoice);
                sPortraitResRef = GetStringLeft(sPortraitResRef, GetStringLength(sPortraitResRef)-1); //trim the trailing _
                SetPortraitResRef(oPC, sPortraitResRef);
                SetPortraitId(oPC, nChoice);
            }
        }
        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
