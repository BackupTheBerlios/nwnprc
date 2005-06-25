//sets tokens for conversation
// 99 is main line
//100-109 is choices
//also sets locals equal to each token
//locals follow "TOKEN_#" pattern
void SetupTokens();

void SetupTokens()
{
    int i;
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "ChoiceOffset");
    //choices
    for (i=0;i<10;i++)
    {
        SetToken(100+i, array_get_string(oPC, "ChoiceTokens", nOffset+i));
    }
}

//add a choice to the dynamic conversation system
void AddChoice(string sText, int nValue);

void AddChoice(string sText, int nValue)
{
    object oPC = GetPCSpeaker();
    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"), sText);
    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), nValue);
}