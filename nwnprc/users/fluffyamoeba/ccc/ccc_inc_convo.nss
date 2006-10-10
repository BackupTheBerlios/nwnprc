#include "ccc_inc_misc"
#include "prc_ccc_const"

// sets up the header and the choices for each stage of the convoCC
void DoHeaderAndChoices(int nStage);

// processes the player choices for each stage of the convoCC
int HandleChoice(int nStage, int nChoice);

// placeholders
void DoHeaderAndChoices(int nStage)
{
    string sText;
    string sName;
    int i = 0; // loop counter
    switch(nStage)
    {
        case STAGE_INTRODUCTION:
            sText = "This is the Conversation Character Creator (CCC) by Primogenitor.\n";
            sText+= "This is a replicate of the bioware character creator, but it will allow you to select custom content at level 1.\n";
            sText+= "Simply follow the step by step instructions and select what you want. ";
            sText+= "If you dont get all the options you think you should at a stage, select one, then select No at the confirmation step.";
            SetHeader(sText);
            // setup the choices
            AddChoice("continue", 0);
            MarkStageSetUp(nStage);
            break;
            
        case STAGE_GENDER:
            sText = GetStringByStrRef(158);
            SetHeader(sText);
            // set up the choices
            Do2daLoop("gender", "NAME", GetPRCSwitch(FILE_END_GENDER));
            MarkStageSetUp(nStage);
            break;
            
        case STAGE_GENDER_CHECK:
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            sText+= GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", GetLocalInt(OBJECT_SELF, "Gender"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        case STAGE_RACE:
            sText = GetStringByStrRef(162); // Select a Race for your Character
            SetHeader(sText);
            // set up choices
            // try with waiting set up first
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, DoRacialtypesLoop());
            MarkStageSetUp(nStage);
            SetDefaultTokens();
            break;
        case STAGE_RACE_CHECK:
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            sText += GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", GetLocalInt(OBJECT_SELF, "Race"))));
            sText += "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Description", GetLocalInt(OBJECT_SELF, "Race"))));
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
    }
}

int HandleChoice(int nStage, int nChoice)
{
    switch(nStage)
    {
        case STAGE_INTRODUCTION:
            nStage++;
            break;
            
        case STAGE_GENDER:
            SetLocalInt(OBJECT_SELF, "Gender",
                GetChoice(OBJECT_SELF));
            nStage++;
            break;
            
        case STAGE_GENDER_CHECK:
            if(nChoice == 1)
                nStage++;
            else // go back to pick gender
            {
                nStage = STAGE_GENDER;
                MarkStageNotSetUp(STAGE_GENDER_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_GENDER, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Gender");
            }
            break;
        case STAGE_RACE:
            SetLocalInt(OBJECT_SELF, "Race", GetChoice(OBJECT_SELF));
            nStage++;
            break;
        case STAGE_RACE_CHECK:
            if(nChoice == 1)
            {
                nStage++;
                /* TODO eeek!! */
                // set race appearance, remove wings and tails, get rid of
                // invisible/undead etc body parts
                DoSetRaceAppearance();
                // clone the PC and hide the swap with a special effect
                CreateCloneCutscene();
                // use letoscript to assign the gender
                DoCloneGender();
                // set up the camera and animations
                DoRotatingCamera();
            }
            else // go back and pick race
            {
                nStage = STAGE_RACE;
                MarkStageNotSetUp(STAGE_RACE_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_RACE, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Race");
            }
            break;
    }
    return nStage;
}
