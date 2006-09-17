//:://////////////////////////////////////////////
//:: Truenaming Utterance gain calculation script
//:: true_uttergain
//:://////////////////////////////////////////////
/** @file
    This script determines whether a given character
    has utterance slots left unfilled. If the character
    does have some, it launches the utterance gain
    conversation.


    @date Modified - 2006.07.19
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "true_inc_trufunc"
#include "inc_dynconv"


int CheckMissingUtterances(object oPC, int nClass, int nLexicon)
{
    int nLevel = GetLevelByClass(nClass, oPC);
    if(!nLevel)
        return FALSE;

    int nCurrentUtterances = GetUtteranceCount(oPC, nClass, nLexicon);
    int nMaxUtterances = GetMaxUtteranceCount(oPC, nClass, nLexicon);

    if(nCurrentUtterances < nMaxUtterances)
    {
        // Mark the class for which the PC is to gain Utterances and start the conversation
        SetLocalInt(oPC, "nClass", nClass);
        StartDynamicConversation("true_utterconv", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

        return TRUE;
    }
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "nPCShifted"))
        return;
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return;
        eTest = GetNextEffect(oPC);
    }
    // Three different Lexicons to check
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_EVOLVING_MIND))
        return;
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_CRAFTED_TOOL))
        return;
    if(CheckMissingUtterances(oPC, CLASS_TYPE_TRUENAMER, LEXICON_PERFECTED_MAP))
        return;        
}