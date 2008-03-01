//:://////////////////////////////////////////////
//:: Imbue Item - Start crafting conversation
//:: inv_imbue_item
//:://////////////////////////////////////////////
/** @file
    Starts the Imbue Item crafting dynamic conversation.


    @author Shane Hennessy
    @date   Modified - 2006.10.08 - rewritten by Ornedan - modified by Fox
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"


void main()
{
    object oPC = OBJECT_SELF;
    
    SetLocalObject(oPC, "CraftingBaseItem", PRCGetSpellTargetObject());
    
    StartDynamicConversation("inv_imbueitemcon", oPC, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, oPC);
}