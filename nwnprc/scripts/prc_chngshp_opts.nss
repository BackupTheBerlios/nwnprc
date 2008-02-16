//:://////////////////////////////////////////////
//:: Change Shape - Start options conversation
//:: prc_chngshp_opts
//:://////////////////////////////////////////////
/** @file
    Starts the Change Shape Options dynamiv conversation.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//#include "prc_inc_shifting"
#include "inc_dynconv"


void main()
{
    object oPC = OBJECT_SELF;
    
    SetLocalInt(oPC, "ChangeShapeConfig", GetSpellId());

    StartDynamicConversation("prc_chngshp_conv", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}