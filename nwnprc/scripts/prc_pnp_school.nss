//This used Bitwise math 
//this thread should help if you dont understand bitwise math
//http://nwn.bioware.com/forums/viewtopic.html?topic=391126&forum=47

void AddSchool(int nSchool, int nSchool2 = 0, int nSchool3 = 0)
{
    string sName;
    sName += GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool)));
    if(nSchool2 && !nSchool3)  
        sName += " and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
    if(nSchool2 && nSchool3)  
    {
        sName += ", "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
        sName += ", and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool3)));
    }       
    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
        sName);      
    nValue = nSchool | (nSchool2 << 4) | (nSchool3 << 8);
    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), nValue);
}

int GetIPFromSchool(int nSchool)
{
    switch(nSchool)
    {
        case SPELL_SCHOOL_GENERAL:      return 241;
        case SPELL_SCHOOL_ABJURATION:   return 242;
        case SPELL_SCHOOL_CONJURATION:  return 243;
        case SPELL_SCHOOL_DIVINATION:   return 244;
        case SPELL_SCHOOL_ENCHANTMENT:  return 245;
        case SPELL_SCHOOL_EVOCATION:    return 246;
        case SPELL_SCHOOL_ILLUSION:     return 247;
        case SPELL_SCHOOL_NECROMANCY:   return 248;
        case SPELL_SCHOOL_TRANSMUTATION:return 249;
    }       
}

int GetIPFromOppSchool(int nSchool)
{
    switch(nSchool)
    {
        case SPELL_SCHOOL_ABJURATION:   return 233;
        case SPELL_SCHOOL_CONJURATION:  return 234;
        case SPELL_SCHOOL_DIVINATION:   return 235;
        case SPELL_SCHOOL_ENCHANTMENT:  return 236;
        case SPELL_SCHOOL_EVOCATION:    return 237;
        case SPELL_SCHOOL_ILLUSION:     return 238;
        case SPELL_SCHOOL_NECROMANCY:   return 239;
        case SPELL_SCHOOL_TRANSMUTATION:return 240;
    }       
}

void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, "DynConv_Var");
            array_create(oPC, "ChoiceTokens");
            array_create(oPC, "ChoiceValues");

    if(nValue == 0)
        return;
    if(nValue > 0)
        nValue --;//correct for 1 based to zero based


    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");
// INSERT CODE HERE FOR THE HEADER
// AND PC RESPONSES
// token no 99 = header
// array named ChoiceTokens for strings
// array named ChoiceValues for ints associated with responces
        if(nStage == 0) //select a school
        {
            int i;
            for(i=0; i< SPELLSCHOOL_2DA_END; i++)
            {
                array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                    GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))));
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
            }
            SetCustomToken(99, "Select a specialist school.");
        }
        if(nStage == 1)//select oposing school(s)
        {
            int nSchool = GetLocalInt(oPC, "School");
            int a,b,c;
            switch(nSchool)
            {
                case SPELL_SCHOOL_ABJURATION:
                    AddSchool(SPELL_SCHOOL_CONJURATION);
                    AddSchool(SPELL_SCHOOL_ENCHANTMENT);
                    AddSchool(SPELL_SCHOOL_EVOCATION);
                    AddSchool(SPELL_SCHOOL_ILLUSION);
                    AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                    AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                    break;
                case SPELL_SCHOOL_CONJURATION:
                    AddSchool(SPELL_SCHOOL_EVOCATION);
                    AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                    AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                    for(a=1;a<=8;a++)
                    {
                        for(b=a+1;b<=8;b++)
                        {
                            for(c=b+1;c<=8;c++)
                            {
                                if(a == SPELL_SCHOOL_EVOCATION
                                    || b == SPELL_SCHOOL_EVOCATION
                                    || c == SPELL_SCHOOL_EVOCATION
                                    || a == SPELL_SCHOOL_TRANSMUTATION
                                    || b == SPELL_SCHOOL_TRANSMUTATION
                                    || c == SPELL_SCHOOL_TRANSMUTATION
                                    || a == SPELL_SCHOOL_CONJURATION
                                    || b == SPELL_SCHOOL_CONJURATION
                                    || c == SPELL_SCHOOL_CONJURATION
                                    || (a == SPELL_SCHOOL_ABJURATION
                                        && b == SPELL_SCHOOL_ENCHANTMENT
                                        && c == SPELL_SCHOOL_ILLUSION))
                                {
                                }
                                else
                                    AddSchool(a,b,c);
                            }
                        }
                    }
                    break;
                case SPELL_SCHOOL_DIVINATION:
                    for(a=1;a<=8;a++)
                    {
                        if(a != SPELL_SCHOOL_DIVINATION)
                            AddSchool(a);
                    }
                    break;
                case SPELL_SCHOOL_ENCHANTMENT:
                    AddSchool(SPELL_SCHOOL_ABJURATION);
                    AddSchool(SPELL_SCHOOL_CONJURATION);
                    AddSchool(SPELL_SCHOOL_EVOCATION);
                    AddSchool(SPELL_SCHOOL_ILLUSION);
                    AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                    AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                    break;
                case SPELL_SCHOOL_EVOCATION:
                    AddSchool(SPELL_SCHOOL_CONJURATION);
                    AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                    AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                    for(a=1;a<=8;a++)
                    {
                        for(b=a+1;b<=8;b++)
                        {
                            for(c=b+1;c<=8;c++)
                            {
                                if(a == SPELL_SCHOOL_CONJURATION
                                    || b == SPELL_SCHOOL_CONJURATION
                                    || c == SPELL_SCHOOL_CONJURATION
                                    || a == SPELL_SCHOOL_TRANSMUTATION
                                    || b == SPELL_SCHOOL_TRANSMUTATION
                                    || c == SPELL_SCHOOL_TRANSMUTATION
                                    || a == SPELL_SCHOOL_EVOCATION
                                    || b == SPELL_SCHOOL_EVOCATION
                                    || c == SPELL_SCHOOL_EVOCATION
                                    || (a == SPELL_SCHOOL_ABJURATION
                                        && b == SPELL_SCHOOL_ENCHANTMENT
                                        && c == SPELL_SCHOOL_ILLUSION))
                                {
                                }
                                else
                                    AddSchool(a,b,c);
                            }
                        }
                    }
                    break;
                case SPELL_SCHOOL_ILLUSION:
                    AddSchool(SPELL_SCHOOL_ABJURATION);
                    AddSchool(SPELL_SCHOOL_CONJURATION);
                    AddSchool(SPELL_SCHOOL_EVOCATION);
                    AddSchool(SPELL_SCHOOL_ENCHANTMENT);
                    AddSchool(SPELL_SCHOOL_TRANSMUTATION);
                    AddSchool(SPELL_SCHOOL_DIVINATION, SPELL_SCHOOL_NECROMANCY);
                    break;
                case SPELL_SCHOOL_NECROMANCY:
                    for(a=1;a<=8;a++)
                    {
                        if(a != SPELL_SCHOOL_NECROMANCY)
                            AddSchool(a);
                    }
                    break;
                case SPELL_SCHOOL_TRANSMUTATION:
                    AddSchool(SPELL_SCHOOL_CONJURATION);
                    AddSchool(SPELL_SCHOOL_EVOCATION);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ENCHANTMENT);
                    AddSchool(SPELL_SCHOOL_ABJURATION, SPELL_SCHOOL_ILLUSION);
                    AddSchool(SPELL_SCHOOL_ENCHANTMENT, SPELL_SCHOOL_ILLUSION);
                    for(a=1;a<=8;a++)
                    {
                        for(b=a+1;b<=8;b++)
                        {
                            for(c=b+1;c<=8;c++)
                            {
                                if(a == SPELL_SCHOOL_CONJURATION
                                    || b == SPELL_SCHOOL_CONJURATION
                                    || c == SPELL_SCHOOL_CONJURATION
                                    || a == SPELL_SCHOOL_TRANSMUTATION
                                    || b == SPELL_SCHOOL_TRANSMUTATION
                                    || c == SPELL_SCHOOL_TRANSMUTATION
                                    || a == SPELL_SCHOOL_EVOCATION
                                    || b == SPELL_SCHOOL_EVOCATION
                                    || c == SPELL_SCHOOL_EVOCATION
                                    || (a == SPELL_SCHOOL_ABJURATION
                                        && b == SPELL_SCHOOL_ENCHANTMENT
                                        && c == SPELL_SCHOOL_ILLUSION))
                                {
                                }
                                else
                                    AddSchool(a,b,c);
                            }
                        }
                    }
                    break;
                }                    
                SetCustomToken(99, "Select a set of opposition school(s).");
            }
            if(nStage == 3)//confirmation
            {
                int nSchool  = GetLocalInt(oPC, "School" );
                int nSchool1 = GetLocalInt(oPC, "School1");
                int nSchool2 = GetLocalInt(oPC, "School2");
                int nSchool3 = GetLocalInt(oPC, "School3");
                array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                    "Yes");
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), TRUE);
                array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                    "No");
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), FALSE);
                
                string sName;
                sName += GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool1)));
                if(nSchool2 && !nSchool3)  
                    sName += " and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
                if(nSchool2 && nSchool3)  
                {
                    sName += ", "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool2)));
                    sName += ", and "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool3)));
                }       
    
                string sText = "You have selected "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i)))
                    +" as your specialist school.\n";
                if(nSchool != SPELL_SCHOOL_GENERAL)                  
                    sText += "You have selected "+sName+" as your opposition school(s).\n";
                sText += "Is this correct?";
                SetCustomToken(99, sText);
            }
        }
        //do token setup
        int nOffset = GetLocalInt(oPC, "ChoiceOffset");
        int i;
        for(i=nOffset; i<nOffset+10; i++)
        {
            string sValue = array_get_string(oPC, "ChoiceTokens" ,i);
            SetLocalString(oPC, "TOKEN10"+IntToString(i-nOffset), sValue);
            SetCustomToken(100+i-nOffset, sValue);
        }
        SetCustomToken(110, GetStringByStrRef(16824212));//finish
        SetCustomToken(111, GetStringByStrRef(16824202));//please wait
        SetCustomToken(112, GetStringByStrRef(16824204));//next
        SetCustomToken(113, GetStringByStrRef(16824203));//previous

// END OF INSERT FOR THE HEADER
        return;
    }
    if(nValue == -2)
    {
      //end of conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
        return;
    }
    if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
        return;
    }
    nValue = array_get_int(oPC, "ChoiceValues", nValue);
    int nStage = GetLocalInt(oPC, "Stage");
    if(nStage == 0)//select a school
    {
        //nValue is the int associated with the response selected
        //move to another stage based on responce
        if(nValue == SPELL_SCHOOL_GENERAL)
            nStage = 2;// generalist, go to confirmation
        else            
            nStage = 1;//select opposing school
        SetLocalInt(oPC, "School", nValue); 
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    if(nStage == 1)//select opposing school(s)
    {
        nSchool1 = nValue & 15;
        nSchool2 = (nValue & 240) >> 4;
        nSchool3 = (nValue & 3840) >> 8;
        SetLocalInt(oPC, "School1", nSchool1); 
        SetLocalInt(oPC, "School2", nSchool2); 
        SetLocalInt(oPC, "School3", nSchool3); 
        nStage++;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    }
    if(nStage == 2)//confirmation
    {
        if(nValue == TRUE)
        {
            nStage = 3;    
            int nSchool  = GetLocalInt(oPC, "School" );
            int nSchool1 = GetLocalInt(oPC, "School1");
            int nSchool2 = GetLocalInt(oPC, "School2");
            int nSchool3 = GetLocalInt(oPC, "School3");
            object oSkin = GetPCSkin(oPC);
            itemproperty ipSchool = ItemPropertyBonusFeat(GetIPFromSchool(nSchool));
            itemproperty ipSchool1 = ItemPropertyBonusFeat(GetIPFromOppSchool(nSchool1));
            itemproperty ipSchool2 = ItemPropertyBonusFeat(GetIPFromOppSchool(nSchool2));
            itemproperty ipSchool3 = ItemPropertyBonusFeat(GetIPFromOppSchool(nSchool3));
            AddItemProperty(DURATION_TYPE_PERMANENT, ipSchool, oSkin);
            if(nSchool1 != 0)
                AddItemProperty(DURATION_TYPE_PERMANENT, ipSchool1, oSkin);
            if(nSchool2 != 0)
                AddItemProperty(DURATION_TYPE_PERMANENT, ipSchool2, oSkin);
            if(nSchool3 != 0)
                AddItemProperty(DURATION_TYPE_PERMANENT, ipSchool3, oSkin);
        }
        else
        {
            nStage = 0;
        }
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
    }
    SetLocalInt(oPC, "Stage", nStage);
}
