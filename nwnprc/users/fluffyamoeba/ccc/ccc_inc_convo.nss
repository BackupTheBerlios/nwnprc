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
        case STAGE_CLASS:
            sText = GetStringByStrRef(61920); // Select a Class for Your Character
            SetHeader(sText);
            // set up choices
            // try with waiting set up first
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, DoClassesLoop());
            MarkStageSetUp(nStage);
            SetDefaultTokens();
            break;
        case STAGE_CLASS_CHECK:
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            sText += GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", GetLocalInt(OBJECT_SELF, "Class"))));
            sText += "\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("classes", "Description", GetLocalInt(OBJECT_SELF, "Class"))));
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        case STAGE_ALIGNMENT:
            sText = GetStringByStrRef(111); // Select an Alignment for your Character
            SetHeader(sText);
            // get the restriction info from classes.2da
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            int nClass = GetLocalInt(OBJECT_SELF, "Class");
            int iAlignRestrict = HexToInt(Get2DACache("classes", "AlignRestrict",nClass));
            int iAlignRstrctType = HexToInt(Get2DACache("classes", "AlignRstrctType",nClass));
            int iInvertRestrict = HexToInt(Get2DACache("classes", "InvertRestrict",nClass));
            // set up choices
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_GOOD,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(112), 112);
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(115), 115);
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(118), 118);
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(113), 113);
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(116), 116);
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(119), 119);
            if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_EVIL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(114), 114);
            if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(117), 117);
            if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL,iAlignRestrict, iAlignRstrctType, iInvertRestrict))
                AddChoice(GetStringByStrRef(120), 120);
            DelayCommand(0.01, DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting"));
            MarkStageSetUp(nStage);
            break;
        case STAGE_ALIGNMENT_CHECK:
            DoDebug(IntToString(nStage));
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            int nStrRef = GetLocalInt(OBJECT_SELF, "AlignChoice"); // strref for the alignment
            sText += GetStringByStrRef(nStrRef);
            sText += "\n"+GetStringByStrRef(16824210); // Is this correct?
            DoDebug(sText);
            SetHeader(sText);
            DoDebug("1");
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            DoDebug("2");
            AddChoice(GetStringByStrRef(4752), 1); // yes
            DoDebug("3");
            DoDebug(IntToString(nStage));
            MarkStageSetUp(nStage);
            DoDebug("4");
            break;
        default:
            DoDebug("Huh?");
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
            SetLocalInt(OBJECT_SELF, "Gender", nChoice);
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
            SetLocalInt(OBJECT_SELF, "Race", nChoice);
            nStage++;
            break;
        case STAGE_RACE_CHECK:
            if(nChoice == 1)
            {
                nStage++;
                // set race appearance, remove wings and tails, get rid of
                // invisible/undead etc body parts
                DoSetRaceAppearance();
                // clone the PC and hide the swap with a special effect
                CreateCloneCutscene();
                // use letoscript to assign the gender
                DoCloneGender();
                // set up the camera and animations
                DoRotatingCamera();
                // store racial feat variables
                AddRaceFeats(GetLocalInt(OBJECT_SELF, "Race"));
            }
            else // go back and pick race
            {
                nStage = STAGE_RACE;
                MarkStageNotSetUp(STAGE_RACE_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_RACE, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Race");
            }
            break;
        case STAGE_CLASS:
            SetLocalInt(OBJECT_SELF, "Class", nChoice);
            nStage++;
            break;
        case STAGE_CLASS_CHECK:
            if(nChoice == 1)
            {
                nStage++;
                // add class feats
                AddClassFeats(GetLocalInt(OBJECT_SELF, "Class"));
                // now for hitpoints (without con alteration)
                SetLocalInt(OBJECT_SELF, "HitPoints",
                    StringToInt(Get2DACache("classes", "HitDie",
                        GetLocalInt(OBJECT_SELF, "Class"))));
            }
            else // go back and pick class
            {
                nStage = STAGE_CLASS;
                MarkStageNotSetUp(STAGE_CLASS_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_CLASS, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Class");
            }
            break;
        case STAGE_ALIGNMENT:
            // for stage check later
            SetLocalInt(OBJECT_SELF, "AlignChoice", nChoice);
            DoDebug("AlignChoice is: " + IntToString(nChoice));
            switch(nChoice)
            {
                case 112: //lawful good
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 85);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 85);
                    break;
                case 115: //neutral good
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 50);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 85);
                    break;
                case 118: //chaotic good
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 15);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 85);
                    break;
                case 113: //lawful neutral
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 85);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 50);
                    break;
                case 116: //true neutral
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 50);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 50);
                    break;
                case 119: //chaotic neutral
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 15);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 50);
                    break;
                case 114: //lawful evil
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 85);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 15);
                    break;
                case 117: //neutral evil
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 50);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 15);
                    break;
                case 120: //chaotic evil
                    SetLocalInt(OBJECT_SELF, "LawfulChaotic", 15);
                    SetLocalInt(OBJECT_SELF, "GoodEvil", 15);
                    break;
                default:
                    DoDebug("Duh, that clearly didn't work right");
            }
            nStage++;
            DoDebug("LawfulChaotic is: " + IntToString(GetLocalInt(OBJECT_SELF, "LawfulChaotic")));
            DoDebug("GoodEvil is: " + IntToString(GetLocalInt(OBJECT_SELF, "GoodEvil")));
            break;
        case STAGE_ALIGNMENT_CHECK:
            if(nChoice == 1)
            {
                nStage++;
            }
            else // go back and pick alignment
            {
                nStage = STAGE_ALIGNMENT;
                MarkStageNotSetUp(STAGE_ALIGNMENT_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_ALIGNMENT, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "AlignChoice");
                DeleteLocalInt(OBJECT_SELF, "LawfulChaotic");
                DeleteLocalInt(OBJECT_SELF, "GoodEvil");
            }
            break;
    }
    return nStage;
}
