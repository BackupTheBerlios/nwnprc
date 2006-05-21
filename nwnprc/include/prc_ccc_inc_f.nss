void SetupSkin()
{
    AddChoice("Very pale"          ,  0);
    AddChoice("Pale"               ,  1);
    AddChoice("Slightly pale"      ,  2);
    AddChoice("'Normal'"           ,  3);
    AddChoice("Slightly tanned"    ,  4);
    AddChoice("Tanned"             ,  5);
    AddChoice("Very tanned"        ,  6);
    AddChoice("Extremely tanned"   ,  7);
    AddChoice("Very light yellow A",  8);
    AddChoice("Very light yellow B", 24);
    AddChoice("Light yellow A"     ,  9);
    AddChoice("Light yellow B"     , 25);
    AddChoice("Dark yellow A"      , 10);
    AddChoice("Dark yellow B"      , 26);
    AddChoice("Very dark yellow A" , 11);
    AddChoice("Very dark yellow B" , 27);
    AddChoice("Very light grey A"  , 16);
    AddChoice("Very light grey B"  , 40);
    AddChoice("Light grey A"       , 17);
    AddChoice("Light grey B"       , 41);
    AddChoice("Dark grey A"        , 18);
    AddChoice("Dark grey B"        , 42);
    AddChoice("Very dark grey A"   , 19);
    AddChoice("Very dark grey B"   , 43);
    AddChoice("Very pale blue-grey", 20);
    AddChoice("Pale blue-grey"     , 21);
    AddChoice("Slightly pale blue-grey",22);
    AddChoice("Blue-grey"          , 23);
    AddChoice("Slightly dark blue-grey",28);
    AddChoice("Dark blue-grey"     , 29);
    AddChoice("Very dark blue-grey", 30);
    AddChoice("Extremely dark blue-grey", 31);
    AddChoice("Very light yellow-green ", 32);
    AddChoice("Light yellow-green" , 33);
    AddChoice("Yellow-green"       , 34);
    AddChoice("Dark yellow-green"  , 35);
    AddChoice("Very light green"   , 36);
    AddChoice("Light green"        , 37);
    AddChoice("Green"              , 38);
    AddChoice("Dark green"         , 39);
    AddChoice("Red A"              , 44);
    AddChoice("Red B"              , 45);
    AddChoice("Pink A"             , 46);
    AddChoice("Pink B"             , 47);
    AddChoice("Blue A"             , 48);
    AddChoice("Blue B"             , 49);
    AddChoice("Turquoise A"        , 50);
    AddChoice("Turquoise B"        , 51);
    AddChoice("Green A"            , 52);
    AddChoice("Green B"            , 53);
    AddChoice("Amber A"            , 54);
    AddChoice("Amber B"            , 55);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS))
    {
        AddChoice("Silver"             , 56);
        AddChoice("Obsidian"           , 57);
        AddChoice("Gold"               , 58);
        AddChoice("Bronze"             , 59);
        AddChoice("Odd grey"           , 60);
        AddChoice("Odd metalic"        , 61);
        AddChoice("Matt while"         , 62);
        AddChoice("Matt black"         , 63);
    }
}

void SetupHair()
{

    AddChoice("Light brown A"      ,  0);
    AddChoice("Light brown B"      , 12);
    AddChoice("Brown A"            ,  1);
    AddChoice("Brown B"            , 13);
    AddChoice("Dark brown A"       ,  2);
    AddChoice("Dark brown B"       , 14);
    AddChoice("Darkest brown A"    ,  3);
    AddChoice("Darkest brown B"    , 15);
    AddChoice("Light red"          ,  4);
    AddChoice("Red"                ,  5);
    AddChoice("Dark red"           ,  6);
    AddChoice("Darkest red"        ,  7);
    AddChoice("Light blonde"       ,  8);
    AddChoice("Blonde"             ,  9);
    AddChoice("Dark blonde"        , 10);
    AddChoice("Darkest blonde"     , 11);
    AddChoice("Silver grey"        , 16);
    AddChoice("Lightest grey"      , 17);
    AddChoice("Light grey"         , 18);
    AddChoice("Grey"               , 19);
    AddChoice("Dark grey"          , 20);
    AddChoice("Darkest grey"       , 21);
    AddChoice("Black with grey highights", 22);
    AddChoice("Black"               , 23);
    AddChoice("Light violet"        , 24);
    AddChoice("Dark violet"         , 25);
    AddChoice("Light purple"        , 26);
    AddChoice("Dark purple"         , 27);
    AddChoice("Light blue"          , 28);
    AddChoice("Dark blue"           , 29);
    AddChoice("Light blue-grey"     , 30);
    AddChoice("Dark blue-grey"      , 31);
    AddChoice("Light blue-green"    , 32);
    AddChoice("Dark blue-green"     , 33);
    AddChoice("Light blue-grey-green", 34);
    AddChoice("Dark blue-grey-green", 35);
    AddChoice("Light green"         , 36);
    AddChoice("Dark green"          , 37);
    AddChoice("Light green-grey"    , 38);
    AddChoice("Dark green-grey"     , 39);
    AddChoice("Light snot green"    , 40);
    AddChoice("Dark snot green"     , 41);
    AddChoice("Light green-yellow"  , 42);
    AddChoice("Dark green-yellow"   , 43);
    AddChoice("Light yellow"        , 44);
    AddChoice("Dark yellow"         , 45);
    AddChoice("Light yellow-grey"   , 46);
    AddChoice("Dark yellow-grey"    , 47);
    AddChoice("Light orange"        , 48);
    AddChoice("Dark orange"         , 49);
    AddChoice("Light orange-grey"   , 50);
    AddChoice("Dark orange-grey"    , 51);
    AddChoice("Light pink"          , 52);
    AddChoice("Dark pink"           , 53);
    AddChoice("Light pink-grey"     , 54);
    AddChoice("Dark pink-grey"      , 55);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS))
    {
        AddChoice("Silver"              , 56);
        AddChoice("Obsidian"            , 57);
        AddChoice("Gold"                , 58);
        AddChoice("Bronze"              , 59);
        AddChoice("Odd grey"            , 60);
        AddChoice("Odd metalic"         , 61);
        AddChoice("Matt while"          , 62);
        AddChoice("Matt black"          , 63);
    }
}

void SetupTattooColours()
{
    AddChoice("Lightest tan/brown", 1);
    AddChoice("Light tan/brown", 2);
    AddChoice("Dark tan/brown", 3);
    AddChoice("Darkest tan/brown", 4);
    AddChoice("Lightest tan/red", 5);
    AddChoice("Light tan/red", 6);
    AddChoice("Dark tan/red", 7);
    AddChoice("Darkest tan/red", 8);
    AddChoice("Lightest tan/yellow", 9);
    AddChoice("Light tan/yellow", 10);
    AddChoice("Dark tan/yellow", 11);
    AddChoice("Darkest tan/yellow", 12);
    AddChoice("Lightest tan/grey", 13);
    AddChoice("Light tan/grey", 14);
    AddChoice("Dark tan/grey", 15);
    AddChoice("Darkest tan/grey", 16);
    AddChoice("Lightest olive", 17);
    AddChoice("Light olive", 18);
    AddChoice("Dark olive", 19);
    AddChoice("Darkest olive", 20);
    AddChoice("White", 21);
    AddChoice("Light grey", 22);
    AddChoice("Dark grey", 23);
    AddChoice("Black", 24);
    AddChoice("Light blue", 25);
    AddChoice("Dark blue", 26);
    AddChoice("Light aqua", 27);
    AddChoice("Dark aqua", 28);
    AddChoice("Light teal", 29);
    AddChoice("Dark teal", 30);
    AddChoice("Light green", 31);
    AddChoice("Dark green", 32);
    AddChoice("Light yellow", 33);
    AddChoice("Dark yellow", 34);
    AddChoice("Light orange", 35);
    AddChoice("Dark orange", 36);
    AddChoice("Light red", 37);
    AddChoice("Dark red", 38);
    AddChoice("Light pink", 39);
    AddChoice("Dark pink", 40);
    AddChoice("Light purple", 41);
    AddChoice("Dark purple", 42);
    AddChoice("Light violet", 43);
    AddChoice("Dark violet", 44);
    AddChoice("Shiny white", 45);
    AddChoice("Shiny black", 46);
    AddChoice("Shiny blue", 47);
    AddChoice("Shiny aqua", 48);
    AddChoice("Shiny teal", 49);
    AddChoice("Shiny green", 50);
    AddChoice("Shiny yellow", 51);
    AddChoice("Shiny irange", 52);
    AddChoice("Shiny red", 53);
    AddChoice("Shiny pink", 54);
    AddChoice("Shiny purple", 55);
    AddChoice("Shiny violet", 56);
    if(GetPRCSwitch(PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS))
    {
        AddChoice("Silver"           , 56);
        AddChoice("Obsidian"         , 57);
        AddChoice("Gold"             , 58);
        AddChoice("Bronze"           , 59);
        AddChoice("Odd grey"         , 60);
        AddChoice("Odd metalic"      , 61);
        AddChoice("Matt while"       , 62);
        AddChoice("Matt black"       , 63);
    }
}

void SetupHead()
{
    int nGender = GetLocalInt(OBJECT_SELF, "Gender");
    int nAppearance = GetLocalInt(OBJECT_SELF, "Appearance");
    int i;
    if(nAppearance == APPEARANCE_TYPE_HUMAN
        || nAppearance == APPEARANCE_TYPE_HALF_ELF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=21;i++)
                AddChoice(IntToString(i), i);
            AddChoice(IntToString(143), 143);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=15;i++)
                AddChoice(IntToString(i), i);
            AddChoice(IntToString(143), 143);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_ELF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=10;i++)
                AddChoice(IntToString(i), i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=16;i++)
                AddChoice(IntToString(i), i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_HALFLING)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=8;i++)
                AddChoice(IntToString(i), i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=11;i++)
                AddChoice(IntToString(i), i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_HALF_ORC)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=11;i++)
                AddChoice(IntToString(i), i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=11;i++)
                AddChoice(IntToString(i), i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_DWARF)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=10;i++)
                AddChoice(IntToString(i), i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=12;i++)
                AddChoice(IntToString(i), i);
        }
    }
    else if(nAppearance == APPEARANCE_TYPE_GNOME)
    {
        if(nGender == GENDER_MALE)
        {
            for(i=1;i<=11;i++)
                AddChoice(IntToString(i), i);
        }
        else if(nGender == GENDER_FEMALE)
        {
            for(i=1;i<=9;i++)
                AddChoice(IntToString(i), i);
        }
    }
    else
    {
        AddChoice("You cannot change your head", -1);
    }
}
