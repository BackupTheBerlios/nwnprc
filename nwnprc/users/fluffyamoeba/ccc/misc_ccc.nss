tlk entries:

39  // Continue

123 // Head
124 // Select the Appearance of your Character
125 // Hair Color
128 // Skin Color
147 // Portrait
337 // Tattoo Colors

2409 // Wings
2410 // Tail
7383 // Select a portrait
7498 // Sound Set
7535 // Select a sound set
7880 // Select Character Colors
7888 // Select Color

52977 // Select
65992 // Select None

void DoLoopTemplate()
{
    string q = PRC_SQLGetTick();
    // get the results 100 rows at a time to avoid TMI
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    int nCounter = 0;
    string sSQL;
    
    // make the SQL string
    
    PRC_SQLExecDirect(sSQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        nCounter++;
        // setup choices
    }
    
    if (nCounter == 100)
    {
        SetLocalInt(OBJECT_SELF, "i", nReali+100);
        DelayCommand(0.01, DoLoopTemplate());
    }
    else // end of the 2da
    {
        if(DEBUG) DoDebug("Finished 2da");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        return;
    }
}

// check stage

if (nChoice == 1)
    nStage++;
else
{
    nStage = 
    MarkStageNotSetUp(STAGE_ , OBJECT_SELF);
    MarkStageNotSetUp(STAGE_ , OBJECT_SELF);
    // delete any local vars
}

// check stage setup
sText = GetStringByStrRef(16824209) + " "; // You have selected:
int nThing = GetLocalInt(OBJECT_SELF, "Thing");
sText += GetStringByStrRef(StringToInt(Get2DACache("thing", "STRING_REF", nThing)));
sText += "\n"+GetStringByStrRef(16824210); // Is this correct?
SetHeader(sText);
// choices Y/N
AddChoice(GetStringByStrRef(4753), -1); // no
AddChoice(GetStringByStrRef(4752), 1); // yes
MarkStageSetUp(nStage);
break;



= "SELECT "+q+"rowid"+q+", "+q+"STRREF"+q+", "+q+"TYPE"+q+", "+q+"GENDER"+q+" FROM "+q+"prc_cached2da_soundset"+q+" WHERE ("+q+"RESREF"+q+" != '****') LIMIT 100 OFFSET "+IntToString(i);