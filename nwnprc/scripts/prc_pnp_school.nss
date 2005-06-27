#include "inc_utility"
#include "inc_array"
#include "inc_item_props"
#include "inc_dynconv"

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
    array_set_string(OBJECT_SELF, "ChoiceTokens", array_get_size(OBJECT_SELF, "ChoiceTokens"),
        sName);      
    int nValue = nSchool + (nSchool2 << 4) + (nSchool3 << 8);
    array_set_int(OBJECT_SELF, "ChoiceValues", array_get_size(OBJECT_SELF, "ChoiceValues"), nValue);
    
    string sMessage;
    sMessage += "sName = "+sName+"\n";
    sMessage += "nValue = "+IntToString(nValue)+"\n";
    sMessage += "nSchool = "+IntToString(nSchool)+"\n";
    sMessage += "nSchool2 = "+IntToString(nSchool2)+"\n";
    sMessage += "nSchool3 = "+IntToString(nSchool3)+"\n";
    sMessage += "nSchool2 << 4 = "+IntToString(nSchool2 << 4)+"\n";
    sMessage += "nSchool3 << 8 = "+IntToString(nSchool3 << 8)+"\n";    
    SendMessageToPC(GetFirstPC(), sMessage);
    PrintString(sMessage);
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
    return 0;
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
    return 0;
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

    SetupTokens();
    if(nValue == -1)
    {
        int nStage = GetLocalInt(oPC, "Stage");
        array_create(oPC, "StagesSetup");
        if(array_get_int(oPC, "StagesSetup", nStage))
            return;
        // INSERT CODE HERE FOR THE HEADER
        // AND PC RESPONSES
        // token no 99 = header
        // array named ChoiceTokens for strings
        // array named ChoiceValues for ints associated with responces
        if(nStage == 0) //select a school
        {
            int i;
            for(i=0; i< 9; i++) //use 9 to force original schools only
            {
                array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"),
                    GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", i))));
                array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), i);
            }
            SetCustomToken(99, "Select a specialist school.");
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        else if(nStage == 1)//select oposing school(s)
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
                                 //do nothing
                                }
                                else
                                    AddSchool(a,b,c);
                            }
                        }
                    }
                    break;
            }
            SetCustomToken(99, "Select a set of opposition school(s).");
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        else if(nStage == 2)//confirmation
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

            string sText = "You have selected "+GetStringByStrRef(StringToInt(Get2DACache("spellschools", "StringRef", nSchool)))
                +" as your specialist school.\n";
            if(nSchool != SPELL_SCHOOL_GENERAL)                  
                sText += "You have selected "+sName+" as your opposition school(s).\n";
            sText += "Is this correct?";
            SetCustomToken(99, sText);
            array_set_int(oPC, "StagesSetup", nStage, TRUE);
        }
        else if(nStage == 3)//completion
        {
            //end stage, do not set responces
            string sText = "Your PnP Spell Schools are now setup";
            SetCustomToken(99, sText);
        }
        //do token setup
        SetupTokens();
        SetCustomToken(110, GetStringByStrRef(16824212));//finish
        SetCustomToken(111, GetStringByStrRef(16824202));//please wait
        SetCustomToken(112, GetStringByStrRef(16824204));//next
        SetCustomToken(113, GetStringByStrRef(16824203));//previous

// END OF INSERT FOR THE HEADER

        return;
    }
    else if(nValue == -2)
    {
      //end of conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
        return;
    }
    else if(nValue == -3)
    {
      //abort conversation cleanup
        DeleteLocalInt(oPC, "DynConv_Var");
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_delete(oPC, "StagesSetup");
        DeleteLocalInt(oPC, "Stage");
        DeleteLocalInt(oPC, "School");
        DeleteLocalInt(oPC, "School1");
        DeleteLocalInt(oPC, "School2");
        DeleteLocalInt(oPC, "School3");
        return;
    }
    nValue += GetLocalInt(oPC, "ChoiceOffset");
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
    else if(nStage == 1)//select opposing school(s)
    {
        int nSchool1 = nValue & 15;
        int nSchool2 = (nValue & 240) >> 4;
        int nSchool3 = (nValue & 3840) >> 8;
        SetLocalInt(oPC, "School1", nSchool1); 
        SetLocalInt(oPC, "School2", nSchool2); 
        SetLocalInt(oPC, "School3", nSchool3); 
        nStage++;
        array_delete(oPC, "ChoiceTokens");
        array_delete(oPC, "ChoiceValues");
        array_create(oPC, "ChoiceTokens");
        array_create(oPC, "ChoiceValues");
        DeleteLocalInt(oPC, "ChoiceOffset");
    string sMessage;
    sMessage += "nValue = "+IntToString(nValue)+"\n";
    sMessage += "nSchool1 = "+IntToString(nSchool1)+"\n";
    sMessage += "nSchool2 = "+IntToString(nSchool2)+"\n";
    sMessage += "nSchool3 = "+IntToString(nSchool3)+"\n";
    sMessage += "nValue & 240 = "+IntToString(nValue & 240)+"\n";
    sMessage += "nValue & 3840 = "+IntToString(nValue & 3840)+"\n";    
    SendMessageToPC(GetFirstPC(), sMessage);
    PrintString(sMessage);
        
    }
    else if(nStage == 2)//confirmation
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
            array_set_int(oPC, "StagesSetup", 0, FALSE);
            array_set_int(oPC, "StagesSetup", 1, FALSE);
            array_set_int(oPC, "StagesSetup", 2, FALSE);
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