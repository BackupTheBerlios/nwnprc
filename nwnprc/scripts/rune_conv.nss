#include "inc_item_props"

void main()
{
    object oPC;
    oPC = OBJECT_SELF;

    AssignCommand(oPC, ActionStartConversation(oPC, "prc_rune_conv", FALSE,FALSE));

    if(!GetHasItem(oPC,"runescarreddagge"))
    {
    CreateItemOnObject("runescarreddagge", oPC);
    }
}
