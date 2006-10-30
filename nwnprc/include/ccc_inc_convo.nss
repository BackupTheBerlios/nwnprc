#include "ccc_inc_misc"

// sets up the header and the choices for each stage of the convoCC
void DoHeaderAndChoices(int nStage);

// processes the player choices for each stage of the convoCC
int HandleChoice(int nStage, int nChoice);

void DoHeaderAndChoices(int nStage)
{
    string sText;
    string sName;
    int i = 0; // loop counter
    switch(nStage)
    {
        case STAGE_INTRODUCTION: {
            sText = "This is the Conversation Character Creator (CCC) by Primogenitor.\n";
            sText+= "This is a replicate of the bioware character creator, but it will allow you to select custom content at level 1.\n";
            sText+= "Simply follow the step by step instructions and select what you want. ";
            sText+= "If you dont get all the options you think you should at a stage, select one, then select No at the confirmation step.";
            SetHeader(sText);
            // setup the choices
            AddChoice("continue", 0);
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_GENDER: {
            sText = GetStringByStrRef(158);
            SetHeader(sText);
            // set up the choices
            Do2daLoop("gender", "NAME", GetPRCSwitch(FILE_END_GENDER));
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_GENDER_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            sText+= GetStringByStrRef(StringToInt(Get2DACache("gender", "NAME", GetLocalInt(OBJECT_SELF, "Gender"))));
            sText+= "\n"+GetStringByStrRef(16824210);
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_RACE: {
            sText = GetStringByStrRef(162); // Select a Race for your Character
            SetHeader(sText);
            // set up choices
            // try with waiting set up first
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, DoRacialtypesLoop());
            MarkStageSetUp(nStage);
            SetDefaultTokens();
            break;
        }
        case STAGE_RACE_CHECK: {
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
        case STAGE_CLASS: {
            sText = GetStringByStrRef(61920); // Select a Class for Your Character
            SetHeader(sText);
            // set up choices
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DelayCommand(0.01, DoClassesLoop());
            MarkStageSetUp(nStage);
            SetDefaultTokens();
            break;
        }
        case STAGE_CLASS_CHECK: {
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
        }
        case STAGE_ALIGNMENT: {
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
        }
        case STAGE_ALIGNMENT_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            int nStrRef = GetLocalInt(OBJECT_SELF, "AlignChoice"); // strref for the alignment
            sText += GetStringByStrRef(nStrRef);
            sText += "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_ABILITY: {
            // the first time through this stage set everything up
            if(GetLocalInt(OBJECT_SELF, "Str") == 0)
            {
                // get the starting points to allocate
                int nPoints = GetPRCSwitch(PRC_CONVOCC_STAT_POINTS);
                if(nPoints == 0)
                    nPoints = 30; // default
                SetLocalInt(OBJECT_SELF, "Points", nPoints);
                // get the max stat level (before racial modifiers)
                int nMaxStat = GetPRCSwitch(PRC_CONVOCC_MAX_STAT);
                if(nMaxStat == 0)
                    nMaxStat = 18; // default
                SetLocalInt(OBJECT_SELF, "MaxStat", nMaxStat);
                // set the starting stat values
                SetLocalInt(OBJECT_SELF, "Str", 8);
                SetLocalInt(OBJECT_SELF, "Dex", 8);
                SetLocalInt(OBJECT_SELF, "Con", 8);
                SetLocalInt(OBJECT_SELF, "Int", 8);
                SetLocalInt(OBJECT_SELF, "Wis", 8);
                SetLocalInt(OBJECT_SELF, "Cha", 8);
            }
            sText = GetStringByStrRef(130) + "\n"; // Select Ability Scores for your Character
            sText += GetStringByStrRef(138) + ": "; // Remaining Points
            sText += IntToString(GetLocalInt(OBJECT_SELF, "Points"));
            SetHeader(sText);
            // get the racial adjustment
            int nRace = GetLocalInt(OBJECT_SELF, "Race");
            string sStrAdjust = Get2DACache("racialtypes", "StrAdjust", nRace);
            string sDexAdjust = Get2DACache("racialtypes", "DexAdjust", nRace);
            string sConAdjust = Get2DACache("racialtypes", "ConAdjust", nRace);
            string sIntAdjust = Get2DACache("racialtypes", "IntAdjust", nRace);
            string sWisAdjust = Get2DACache("racialtypes", "WisAdjust", nRace);
            string sChaAdjust = Get2DACache("racialtypes", "ChaAdjust", nRace);
            // set up the choices in "<statvalue> (racial <+/-modifier>) <statname>. Cost to increase <cost>" format
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Str"), GetStringByStrRef(135), sStrAdjust, ABILITY_STRENGTH);
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Dex"), GetStringByStrRef(133), sDexAdjust, ABILITY_DEXTERITY);
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Con"), GetStringByStrRef(132), sConAdjust, ABILITY_CONSTITUTION);
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Int"), GetStringByStrRef(134), sIntAdjust, ABILITY_INTELLIGENCE);
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Wis"), GetStringByStrRef(136), sWisAdjust, ABILITY_WISDOM);
            AddAbilityChoice(GetLocalInt(OBJECT_SELF, "Cha"), GetStringByStrRef(131), sChaAdjust, ABILITY_CHARISMA);
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_ABILITY_CHECK: {
            sText = GetStringByStrRef(16824209) + "\n"; // You have selected:
            sText += GetStringByStrRef(135) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Str")) + "\n"; // str
            sText += GetStringByStrRef(133) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Dex")) + "\n"; // dex
            sText += GetStringByStrRef(132) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Con")) + "\n"; // con
            sText += GetStringByStrRef(134) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Int")) + "\n"; // int
            sText += GetStringByStrRef(136) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Wis")) + "\n"; // wis
            sText += GetStringByStrRef(131) + ": " + IntToString(GetLocalInt(OBJECT_SELF, "Cha")) + "\n"; // cha
            sText += "\n" + GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_SKILL: {
            // the first time through this stage set everything up
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            if(nPoints == 0)
            {
                //calculate number of points
                nPoints += StringToInt(Get2DACache("classes", "SkillPointBase", GetLocalInt(OBJECT_SELF, "Class")));
                // calculate the intelligence bonus/penalty
                int nInt = GetLocalInt(OBJECT_SELF, "Int");
                int nRace = GetLocalInt(OBJECT_SELF, "Race");
                nPoints += (nInt-10+StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace)))/2;
                if(GetPRCSwitch(PRC_CONVOCC_SKILL_MULTIPLIER))
                    nPoints *= GetPRCSwitch(PRC_CONVOCC_SKILL_MULTIPLIER);
                else
                    nPoints *= 4;
                // humans get an extra 4 skill points at level 1
                if (GetLocalInt(OBJECT_SELF, "Race") == RACIAL_TYPE_HUMAN)
                    nPoints += 4;
                nPoints += GetPRCSwitch(PRC_CONVOCC_SKILL_BONUS);
                // minimum of 4, regardless of int
                if(nPoints < 4)
                    nPoints = 4;
                SetLocalInt(OBJECT_SELF, "Points", nPoints);
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            // do header
            sText = GetStringByStrRef(396) + "\n"; // Allocate skill points
            sText += GetStringByStrRef(395) + ": "; // Remaining Points
            sText += IntToString(GetLocalInt(OBJECT_SELF, "Points"));
            SetHeader(sText);
            DoSkillsLoop();
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_SKILL_CHECK: {
            sText = GetStringByStrRef(16824209) + "\n"; // You have selected:
            if(GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
            {
                sText += "Stored skill points: ";
                sText += IntToString(GetLocalInt(OBJECT_SELF, "SavedSkillPoints")) + "\n";
            }
            // loop through the "Skills" array
            for(i=0; i < GetPRCSwitch(FILE_END_SKILLS); i++) // the array can't be bigger than the skills 2da
            {
                if(array_get_int(OBJECT_SELF, "Skills",i) != 0) // if there are points in the skill, add it to the header
                {
                    sText+= GetStringByStrRef(StringToInt(Get2DACache("skills", "Name", i)));
                    sText+= " "+IntToString(array_get_int(OBJECT_SELF, "Skills",i))+"\n";
                }
            }
            sText += "\n" + GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_FEAT: {
            sText = GetStringByStrRef(397) + "\n"; // Select Feats
            sText += GetStringByStrRef(398) + ": "; // Feats remaining
            // if it's the first time through, work out the number of feats
            int nFeatsRemaining = GetLocalInt(OBJECT_SELF, "Points");
            if (!nFeatsRemaining) // first time through
            {
                nFeatsRemaining = 1; // always have at least 1
                // check for quick to master
                nFeatsRemaining += GetLocalInt(OBJECT_SELF, "QTM");
                // set how many times to go through this stage
                SetLocalInt(OBJECT_SELF, "Points", nFeatsRemaining);
            }
            // check for bonus feat(s) from class - show the player the total feats
            // even though class bonuses are a different stage
            int nClass = GetLocalInt(OBJECT_SELF, "Class");
            nFeatsRemaining += StringToInt(Get2DACache(Get2DACache("Classes", "BonusFeatsTable", nClass), "Bonus", 0));
            sText += IntToString(nFeatsRemaining);
            SetHeader(sText);
            // do feat list
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DoFeatLoop();
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_FEAT_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            // get feat
            int nFeat = array_get_int(OBJECT_SELF, "Feats", (array_get_size(OBJECT_SELF, "Feats") - 1));
            // alertness fix
            if (nFeat == -1)
                nFeat == 0;
            sText += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeat))) + "\n"; // name
            sText += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeat))) + "\n"; // description
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_BONUS_FEAT: {
            sText = GetStringByStrRef(397) + "\n"; // Select Feats
            sText += GetStringByStrRef(398) + ": "; // Feats remaining
            int nFeatsRemaining = GetLocalInt(OBJECT_SELF, "Points");
            if (!nFeatsRemaining) // first time through
            {
                // check for bonus feat(s) from class
                int nClass = GetLocalInt(OBJECT_SELF, "Class");
                nFeatsRemaining += StringToInt(Get2DACache(Get2DACache("Classes", "BonusFeatsTable", nClass), "Bonus", 0));
                // set how many times to go through this stage
                SetLocalInt(OBJECT_SELF, "Points", nFeatsRemaining);
            }
            sText += IntToString(nFeatsRemaining);
            SetHeader(sText);
            // do feat list
            SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            DoBonusFeatLoop();
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_BONUS_FEAT_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            // get feat
            int nFeat = array_get_int(OBJECT_SELF, "Feats", (array_get_size(OBJECT_SELF, "Feats") - 1));
            sText += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeat))) + "\n"; // name
            sText += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", nFeat))) + "\n"; // description
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_WIZ_SCHOOL: {
            sText = GetStringByStrRef(381); // Select a School of Magic
            SetHeader(sText);
            // choices
            if(GetPRCSwitch(PRC_PNP_SPELL_SCHOOLS))
            {
                AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", 9))), 9);
            }
            else
            {
                for(i = 0; i < 9; i++)
                {
                    AddChoice(GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))), i);
                }
            }
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_WIZ_SCHOOL_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\n\n";
            sText+= GetStringByStrRef(StringToInt(Get2DACache("spellschools", "Description", GetLocalInt(OBJECT_SELF, "School"))));
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_SPELLS_0: {
            // if the first time through, set up the number of cantrips to pick
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            int nClass = GetLocalInt(OBJECT_SELF, "Class");
            if(nPoints == 0)
            {
                // set up the number of spells to pick
                // get the cls_spkn_***2da to use
                string sSpkn = Get2DACache("classes", "SpellKnownTable", nClass);
                // set the number of spells to pick
                nPoints = StringToInt(Get2DACache(sSpkn, "SpellLevel0", 0));
                SetLocalInt(OBJECT_SELF, "Points", nPoints);
                // don't want to be waiting every time
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            sText = GetStringByStrRef(372) + "\n"; // Select Cantrips
            sText += GetStringByStrRef(371) + ": "; // Remaining Spells
            sText += IntToString(nPoints);
            SetHeader(sText);
            // choices, uses nStage to see if it's listing level 0 or level 1 spells
            DoSpellsLoop(nStage);
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_SPELLS_1: {
            // if the first time through, set up the number of spells to pick
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            int nClass = GetLocalInt(OBJECT_SELF, "Class");
            if(nPoints == 0)
            {
                switch(nClass)
                {
                    case CLASS_TYPE_WIZARD: {
                        // spells to pick is 3 + int modifier
                        int nIntMod = GetLocalInt(OBJECT_SELF, "Int");
                        nIntMod += StringToInt(Get2DACache("racialtypes", "IntAdjust", GetLocalInt(OBJECT_SELF, "Race")));
                        nIntMod = (nIntMod - 10)/2;
                        nPoints = 3 + nIntMod;
                        break;
                    }
                    case CLASS_TYPE_SORCERER: {
                        // get the cls_spkn_***2da to use
                        string sSpkn = Get2DACache("classes", "SpellKnownTable", nClass);
                        // set the number of spells to pick
                        nPoints = StringToInt(Get2DACache(sSpkn, "SpellLevel1", 0));
                        break;
                    }
                }
                SetLocalInt(OBJECT_SELF, "Points", nPoints);
                // don't want to be waiting every time
                SetLocalInt(OBJECT_SELF, "DynConv_Waiting", TRUE);
            }
            sText = GetStringByStrRef(368) + "\n"; // Select Spells for your Character
            sText += GetStringByStrRef(371) + ": "; // Remaining Spells
            sText += IntToString(GetLocalInt(OBJECT_SELF, "Points"));
            SetHeader(sText);
            // choices, uses nStage to see if it's listing level 0 or level 1 spells
            DoSpellsLoop(nStage);
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_SPELLS_CHECK: {
            sText = GetStringByStrRef(16824209) + "\n"; // You have selected:
            int spellID = 0;
            sText += GetStringByStrRef(691) + " - \n"; // Cantrips
            // loop through the spell choices
            for (i = 0; i < array_get_size(OBJECT_SELF, "SpellLvl0"); i++)
            {
                spellID = array_get_int(OBJECT_SELF, "SpellLvl0", i);
                sText+= GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", spellID)));
                sText += "\n";
            }
            sText += GetStringByStrRef(61924) + " - \n"; // Level 1 Spells
            // loop through the spell choices
            for (i = 0; i < array_get_size(OBJECT_SELF, "SpellLvl1"); i++)
            {
                spellID = array_get_int(OBJECT_SELF, "SpellLvl1", i);
                sText+= GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", spellID)));
                sText += "\n";
            }
            sText+= "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_FAMILIAR: {
            int nClass = GetLocalInt(OBJECT_SELF, "Class");
            sText = GetStringByStrRef(5607) + "\n"; // Choose a Familiar for your Character
            sText += "(" + GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass))) + ")";
            SetHeader(sText);
            // do choices
            if (nClass == CLASS_TYPE_DRUID)
                Do2daLoop("hen_companion", "STRREF", GetPRCSwitch(FILE_END_ANIMALCOMP));
            else // wizard or sorc
                Do2daLoop("hen_familiar", "STRREF", GetPRCSwitch(FILE_END_FAMILIAR));
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_FAMILIAR_CHECK: {
            sText = GetStringByStrRef(16824209) + " "; // You have selected:
            if (GetLocalInt(OBJECT_SELF, "Class") == CLASS_TYPE_DRUID)
            {
                int nCompanion = GetLocalInt(OBJECT_SELF, "Companion");
                sText += GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "STRREF", nCompanion)));
                sText += "\n";
                sText += GetStringByStrRef(StringToInt(Get2DACache("hen_companion", "DESCRIPTION", nCompanion)));
                sText += "\n";
            }
            else
            {
                int nFamiliar = GetLocalInt(OBJECT_SELF, "Familiar");
                sText += GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "STRREF", nFamiliar)));
                sText += "\n";
                sText += GetStringByStrRef(StringToInt(Get2DACache("hen_familiar", "DESCRIPTION", nFamiliar)));
                sText += "\n";
            }
            sText += "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_DOMAIN: {
            sText = GetStringByStrRef(5982); // Pick Cleric Domain
            SetHeader(sText);
            // choices
            DoDomainsLoop();
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_DOMAIN_CHECK: {
            sText = GetStringByStrRef(16824209) + "\n"; // You have selected:
            // first domain
            int nDomain = GetLocalInt(OBJECT_SELF,"Domain1");
            // fix for air domain being 0
            if (nDomain == -1)
                nDomain = 0;
            sText += GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", nDomain))) + "\n";
            sText += GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", nDomain))) + "\n";
            // second domain
            nDomain = GetLocalInt(OBJECT_SELF,"Domain2");
            // fix for air domain being 0
            if (nDomain == -1)
                nDomain = 0;
            sText += GetStringByStrRef(StringToInt(Get2DACache("domains", "Name", nDomain))) + "\n";
            sText += GetStringByStrRef(StringToInt(Get2DACache("domains", "Description", nDomain))) + "\n";
            sText += "\n"+GetStringByStrRef(16824210); // Is this correct?
            SetHeader(sText);
            // choices Y/N
            AddChoice(GetStringByStrRef(4753), -1); // no
            AddChoice(GetStringByStrRef(4752), 1); // yes
            MarkStageSetUp(nStage);
            break;
        }
        case STAGE_APPEARANCE: {
            SetHeader("Placeholder");
            AddChoice("Continue", 1);
            MarkStageSetUp(nStage);
            break;
        }
        case FINAL_STAGE: {
            sText = "Your character will now be generated. As part of this process, you will be booted. Please exit NWN completely before rejoining.";
            SetHeader(sText);
            AddChoice("Make Character", 1);
            MarkStageSetUp(nStage);
            break;
        }
        default:
            DoDebug("ccc_inc_convo: DoHeaderAndChoices(): Unknown nStage value: " + IntToString(nStage));
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

        case STAGE_GENDER_CHECK: {
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
        }
        case STAGE_RACE:
            SetLocalInt(OBJECT_SELF, "Race", nChoice);
            nStage++;
            break;
        case STAGE_RACE_CHECK: {
            if(nChoice == 1)
            {
                nStage++;
                DoCutscene(OBJECT_SELF);
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
        }
        case STAGE_CLASS:
            SetLocalInt(OBJECT_SELF, "Class", nChoice);
            nStage++;
            break;
        case STAGE_CLASS_CHECK: {
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
        }
        case STAGE_ALIGNMENT: {
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
        }
        case STAGE_ALIGNMENT_CHECK: {
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
        case STAGE_ABILITY: {
            int nAbilityScore;
            switch(nChoice)
            {
                case ABILITY_STRENGTH:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Str"));
                    SetLocalInt(OBJECT_SELF, "Str", nAbilityScore);
                    break;
                case ABILITY_DEXTERITY:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Dex"));
                    SetLocalInt(OBJECT_SELF, "Dex", nAbilityScore);
                    break;
                case ABILITY_CONSTITUTION:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Con"));
                    SetLocalInt(OBJECT_SELF, "Con", nAbilityScore);
                    break;
                case ABILITY_INTELLIGENCE:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Int"));
                    SetLocalInt(OBJECT_SELF, "Int", nAbilityScore);
                    break;
                case ABILITY_WISDOM:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Wis"));
                    SetLocalInt(OBJECT_SELF, "Wis", nAbilityScore);
                    break;
                case ABILITY_CHARISMA:
                    nAbilityScore = IncreaseAbilityScore(GetLocalInt(OBJECT_SELF, "Cha"));
                    SetLocalInt(OBJECT_SELF, "Cha", nAbilityScore);
                    break;
            }
            int nPoints = GetLocalInt(OBJECT_SELF, "Points"); // new total
            if (nPoints) // if there's still points to allocate
            {
                // resets the stage so that the convo choices reflect the new ability scores
                ClearCurrentStage();
            }
            else
                nStage++; // go to next stage
            break;
        }
        case STAGE_ABILITY_CHECK:{
            if(nChoice == 1)
            {
                nStage++;
            }
            else // go back and reselect ability score
            {
                nStage = STAGE_ABILITY;
                MarkStageNotSetUp(STAGE_ABILITY_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_ABILITY, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Str");
                DeleteLocalInt(OBJECT_SELF, "Dex");
                DeleteLocalInt(OBJECT_SELF, "Con");
                DeleteLocalInt(OBJECT_SELF, "Int");
                DeleteLocalInt(OBJECT_SELF, "Wis");
                DeleteLocalInt(OBJECT_SELF, "Cha");
            }
            break;
        }
        case STAGE_SKILL: {
            // first time through, create the skills array
            if(!array_exists(OBJECT_SELF, "Skills"))
                array_create(OBJECT_SELF, "Skills");
            // get current points
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            if(GetChoice(OBJECT_SELF) == -2) // save all remaining points
            {
                SetLocalInt(OBJECT_SELF, "SavedSkillPoints", nPoints);
                nPoints = 0;    
            }
            else // chosen a skill to increase
            {
                // get the cls_skill_*** 2da to use
                string sFile = Get2DACache("classes", "SkillsTable", GetLocalInt(OBJECT_SELF, "Class"));
                // work out what line in skills.2da it corresponds to
                int nSkillIndex = StringToInt(Get2DACache(sFile, "SkillIndex", nChoice));
                //increase the points in that skill
                // the array index is the line number in skills.2da
                array_set_int(OBJECT_SELF, "Skills", nSkillIndex,
                    array_get_int(OBJECT_SELF, "Skills", nSkillIndex)+1);
                //decrease points remaining
                // see if it's class or cross-class
                int nClassSkill = StringToInt(Get2DACache(sFile, "ClassSkill", nChoice));
                if (nClassSkill) // class skill
                    nPoints -= 1;
                else // cross class skill
                    nPoints -= 2;
            }
            // store new points total
            SetLocalInt(OBJECT_SELF, "Points", nPoints);
            if (nPoints) // still some left to allocate
                ClearCurrentStage();
            else
                nStage++;
            break;
        }
        case STAGE_SKILL_CHECK: {
            if (nChoice = 1)
                nStage++;
            else
            {
                nStage = STAGE_SKILL;
                MarkStageNotSetUp(STAGE_SKILL_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_SKILL, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "SavedSkillPoints");
                DeleteLocalInt(OBJECT_SELF, "Points");
                array_delete(OBJECT_SELF, "Skills");
            }
            break;
        }
        case STAGE_FEAT: {
            int nArraySize = array_get_size(OBJECT_SELF, "Feats");
            // alertness fix
            if (nChoice == 0)
                nChoice == -1;
            // add the feat chosen to the feat array
            array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"), nChoice);
            nStage++;
            break;
        }
        case STAGE_FEAT_CHECK: {
            if (nChoice = 1)
            {
                // decrement the number of feats left to pick
                int nFeatsRemaining = GetLocalInt(OBJECT_SELF, "Points");
                --nFeatsRemaining;
                // check new number of feats left
                if (nFeatsRemaining == 0)
                {
                    // no more feats left to pick
                    // if there's a bonus feat to pick, go to next stage
                    nFeatsRemaining = StringToInt(Get2DACache(Get2DACache("Classes", "BonusFeatsTable", 
                        GetLocalInt(OBJECT_SELF, "Class")), "Bonus", 0));
                    if (nFeatsRemaining)
                    {
                        // go to bonus feat stage
                        nStage = STAGE_BONUS_FEAT;
                    }
                    else
                    {
                        // go to next stage after that the PC qualifies for
                        nStage = GetNextCCCStage(nStage);
                    }
                }
                else 
                {
                    // go back to feat stage to pick next feat
                    nStage = STAGE_FEAT;
                    MarkStageNotSetUp(STAGE_FEAT_CHECK, OBJECT_SELF);
                    MarkStageNotSetUp(STAGE_FEAT, OBJECT_SELF);
                }
                SetLocalInt(OBJECT_SELF, "Points", nFeatsRemaining);
            }
            else
            {
                nStage = STAGE_FEAT;
                MarkStageNotSetUp(STAGE_FEAT_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_FEAT, OBJECT_SELF);
                // delete the chosen feat
                if(array_shrink(OBJECT_SELF, "Feats", (array_get_size(OBJECT_SELF, "Feats") - 1)) != SDL_SUCCESS)
                    DoDebug("No feats array!");
            }
            break;
        }
        case STAGE_BONUS_FEAT: {
            int nArraySize = array_get_size(OBJECT_SELF, "Feats");
            // alertness fix
            if (nChoice == 0)
                nChoice == -1;
            // add the feat chosen to the feat array
            array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"), nChoice);
            nStage++;
            break;
        }
        case STAGE_BONUS_FEAT_CHECK: {
            if (nChoice = 1)
            {
                // decrement the number of feats left to pick
                int nFeatsRemaining = GetLocalInt(OBJECT_SELF, "Points");
                --nFeatsRemaining;
                // check new number of feats left
                if (nFeatsRemaining == 0)
                {
                    // no more feats left to pick
                    // go to next stage after that the PC qualifies for
                    nStage = GetNextCCCStage(nStage);
                }
                else 
                {
                    // go back to feat stage to pick next feat
                    nStage = STAGE_BONUS_FEAT;
                    MarkStageNotSetUp(STAGE_BONUS_FEAT_CHECK, OBJECT_SELF);
                    MarkStageNotSetUp(STAGE_BONUS_FEAT, OBJECT_SELF);
                }
                SetLocalInt(OBJECT_SELF, "Points", nFeatsRemaining);
            }
            else
            {
                nStage = STAGE_BONUS_FEAT;
                MarkStageNotSetUp(STAGE_BONUS_FEAT_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_BONUS_FEAT, OBJECT_SELF);
                // delete the chosen feat
                if(array_shrink(OBJECT_SELF, "Feats", (array_get_size(OBJECT_SELF, "Feats") - 1)) != SDL_SUCCESS)
                    DoDebug("No feats array!");
            }
            break;
        }
        case STAGE_WIZ_SCHOOL: {
            SetLocalInt(OBJECT_SELF, "School", GetChoice());
            nStage++;
            break;
        }
        case STAGE_WIZ_SCHOOL_CHECK: {
            if(nChoice == 1)
            {
                // go to next stage after that the PC qualifies for
                nStage = GetNextCCCStage(nStage);
                // add cantrips - wizards know all of them so don't need to choose
                SetWizCantrips(GetLocalInt(OBJECT_SELF, "School"));
            }
            else // go back and pick the school again
            {
                nStage = STAGE_WIZ_SCHOOL;
                MarkStageNotSetUp(STAGE_WIZ_SCHOOL_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_WIZ_SCHOOL, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "School");
            }
            break;
        }
        case STAGE_SPELLS_0: {
            // create the array first time through
            if (!array_exists(OBJECT_SELF, "SpellLvl0"))
                array_create(OBJECT_SELF, "SpellLvl0");
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            // add the choice to the spells known array
            array_set_int(OBJECT_SELF, "SpellLvl0", array_get_size(OBJECT_SELF, "SpellLvl0"), nChoice);
            // decrement the number of spells left to select
            SetLocalInt(OBJECT_SELF, "Points", --nPoints);
            if (nPoints) // still some left to allocate
                ClearCurrentStage();
            else // go to next stage after that the PC qualifies for
                nStage = GetNextCCCStage(nStage);
            break;
        }
        case STAGE_SPELLS_1: {
            // create the array first time through
            if (!array_exists(OBJECT_SELF, "SpellLvl1"))
                array_create(OBJECT_SELF, "SpellLvl1");
            int nPoints = GetLocalInt(OBJECT_SELF, "Points");
            // add the choice to the spells known array
            array_set_int(OBJECT_SELF, "SpellLvl1", array_get_size(OBJECT_SELF, "SpellLvl1"), nChoice);
            // decrement the number of spells left to select
            SetLocalInt(OBJECT_SELF, "Points", --nPoints);
            if (nPoints) // still some left to allocate
                ClearCurrentStage();
            else // go to next stage after that the PC qualifies for
                nStage = GetNextCCCStage(nStage);
            break;
        }
        case STAGE_SPELLS_CHECK: {
            if(nChoice == 1)
            {
                // go to next stage after that the PC qualifies for
                nStage = GetNextCCCStage(nStage);
                /* TODO spells per day */
                int nClass = GetLocalInt(OBJECT_SELF, "Class");
                // get the cls_spgn_***2da to use
                string sSpgn = Get2DACache("classes", "SpellGainTable", nClass);
                int nSpellsPerDay;
                // level 1 spells
                if (array_exists(OBJECT_SELF, "SpellLvl1"))
                {
                    nSpellsPerDay = StringToInt(Get2DACache(sSpgn, "SpellLevel1", 0));
                    SetLocalInt(OBJECT_SELF, "SpellsPerDay1", nSpellsPerDay);
                }
                // cantrips
                if (array_exists(OBJECT_SELF, "SpellLvl0"))
                {
                    nSpellsPerDay = StringToInt(Get2DACache(sSpgn, "SpellLevel0", 0));
                    SetLocalInt(OBJECT_SELF, "SpellsPerDay0", nSpellsPerDay);
                }
            }
            else // go back and pick the spells again
            {
                // hacky...but returns the right stage, depending on the class
                nStage = GetNextCCCStage(STAGE_WIZ_SCHOOL_CHECK);
                MarkStageNotSetUp(STAGE_SPELLS_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_SPELLS_1, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_SPELLS_0, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Points");
                array_delete(OBJECT_SELF, "spellLvl1");
                if(nStage == STAGE_SPELLS_0)
                {
                    // if the new value of nStage takes us back to picking cantrips,
                    // then also delete the level 0 array
                    array_delete(OBJECT_SELF, "spellLvl0");
                }
            }
            break;
        }
        case STAGE_FAMILIAR: {
            if(GetLocalInt(OBJECT_SELF, "Class") == CLASS_TYPE_DRUID)
                SetLocalInt(OBJECT_SELF, "Companion", nChoice);
            else // sorc or wiz
                SetLocalInt(OBJECT_SELF, "Familiar", nChoice);
            nStage++;
            break;
        }
        case STAGE_FAMILIAR_CHECK: {
            if (nChoice == 1)
                nStage = GetNextCCCStage(nStage);
            else
            {
                nStage = STAGE_FAMILIAR;
                MarkStageNotSetUp(STAGE_FAMILIAR_CHECK, OBJECT_SELF);
                MarkStageNotSetUp(STAGE_FAMILIAR, OBJECT_SELF);
                DeleteLocalInt(OBJECT_SELF, "Familiar");
                DeleteLocalInt(OBJECT_SELF, "Companion");
            }
            break;
        }
        case STAGE_DOMAIN: {
            // if this is the first domain chosen
            if (GetLocalInt(OBJECT_SELF, "Domain1") == 0)
            {
                // fix for air domain being 0
                if (nChoice == 0)
                    nChoice = -1;
                SetLocalInt(OBJECT_SELF, "Domain1", nChoice);
            }
            else // second domain
            {
                // fix for air domain being 0
                if (nChoice == 0)
                    nChoice = -1;
                SetLocalInt(OBJECT_SELF, "Domain2", nChoice);
                nStage++;
            }
            break;
        }
        case STAGE_DOMAIN_CHECK: {
            if (nChoice == 1)
            {
                nStage++;
                // add domain feats
                AddDomainFeats();
            }
            else
            {
                nStage = STAGE_DOMAIN;
                MarkStageNotSetUp(STAGE_DOMAIN_CHECK);
                MarkStageNotSetUp(STAGE_DOMAIN);
                DeleteLocalInt(OBJECT_SELF,"Domain1");
                DeleteLocalInt(OBJECT_SELF,"Domain2");
            }
            break;
        }
        case STAGE_APPEARANCE: {
            nStage = FINAL_STAGE;
            break;
        }
        case FINAL_STAGE: {
            ExecuteScript("prc_ccc_make_pc", OBJECT_SELF);
            AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            break;
        }
    }
    return nStage;
}
