//sets tokens for conversation
// 99 is main line
//100-109 is choices
//also sets locals equal to each token
//locals follow "TOKEN_#" pattern
void SetupTokens();

//add a choice to the dynamic conversation system
void AddChoice(string sText, int nValue, object oPC = OBJECT_INVALID);

/**
 * Call this when exiting conversation.
 */
void ExitConvo();

/**
 * Sets the custom token at nTokenID to be the given string and stores
 * the value in a local variable on OBJECT_SELF.
 * Used by the dyynamic onversation system to track token assignment.
 *
 * @param nTokenID The custom token number to store the string in
 * @param sString  The string to store
 * @param oPC      The PC whose conversation this token belongs to
 */
void SetToken(int nTokenID, string sString, object oPC = OBJECT_SELF);


string GetTokenIDString(int nTokenID);


//const int DYNCONV_EXITED        =
const int DYNCONV_ABORTED       = -3;
//const int DYNCONV_SETUP_STAGE   =
const int DYNCONV_TOKEN_HEADER  = 99;
const int DYNCONV_TOKEN_REPLY_0 = 100;
const int DYNCONV_TOKEN_REPLY_1 = 101;
const int DYNCONV_TOKEN_REPLY_2 = 102;
const int DYNCONV_TOKEN_REPLY_3 = 103;
const int DYNCONV_TOKEN_REPLY_4 = 104;
const int DYNCONV_TOKEN_REPLY_5 = 105;
const int DYNCONV_TOKEN_REPLY_6 = 106;
const int DYNCONV_TOKEN_REPLY_7 = 107;
const int DYNCONV_TOKEN_REPLY_8 = 108;
const int DYNCONV_TOKEN_REPLY_9 = 109;
const int DYNCONV_TOKEN_EXIT    = 110;
const int DYNCONV_TOKEN_WAIT    = 111;
const int DYNCONV_TOKEN_NEXT    = 112;
const int DYNCONV_TOKEN_PREV    = 113;
const int DYNCONV_TOKEN_MIN     = 99;
const int DYNCONV_TOKEN_MAX     = 113;
//const int DYNCONV_
//const int DYNCONV_
//const int DYNCONV_

const string DYNCONV_SCRIPT     = "DynConv_Script";
const string DYNCONV_VARIABLE   = "DynConv_Var";
const string DYNCONV_TOKEN_BASE = "DynConv_TOKEN";


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_utility"


//////////////////////////////////////////////////
/* Function Definitions                         */
//////////////////////////////////////////////////

void SetupTokens()
{
    int i;
    object oPC = GetPCSpeaker();
    int nOffset = GetLocalInt(oPC, "ChoiceOffset");
    //choices
    for (i=0;i<10;i++)
    {
        SetToken(100+i, array_get_string(oPC, "ChoiceTokens", nOffset+i), oPC);
    }
}

string GetTokenIDString(int nTokenID)
{
    return DYNCONV_TOKEN_BASE + IntToString(nTokenID);
}

void AddChoice(string sText, int nValue, object oPC = OBJECT_INVALID)
{
    oPC = oPC == OBJECT_INVALID ? GetPCSpeaker() : oPC;
    array_set_string(oPC, "ChoiceTokens", array_get_size(oPC, "ChoiceTokens"), sText);
    array_set_int   (oPC, "ChoiceValues", array_get_size(oPC, "ChoiceValues"), nValue);
}

void CleanUp(object oPC = OBJECT_INVALID)
{
    array_delete(oPC, "ChoiceTokens");
    array_delete(oPC, "ChoiceValues");

    DeleteLocalInt(oPC, "DynConv_Var");
    DeleteLocalInt(oPC, "Stage");
    DeleteLocalString(oPC, "DynConv_Script");
    int i;
    for(i = 0; i <= DYNCONV_TOKEN_MAX; i++)
        DeleteLocalString(oPC, GetTokenIDString(i));
}

void SetToken(int nTokenID, string sString, object oPC = OBJECT_SELF)
{
    // Set the token
    SetCustomToken(nTokenID, sString);
    // Set a marker on the PC for the reply conditional scripts to check
    SetLocalString(oPC, GetTokenIDString(nTokenID), sString);
}
/*
void StartDynamicConversation(string sConversationScript, object oConverseWith = OBJECT_SELF)

void BranchDynamicConversation(string sConversationToEnter, int nStageToReturnTo)
*/