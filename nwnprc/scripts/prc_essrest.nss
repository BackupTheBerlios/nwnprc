
#include "prc_alterations"
#include "inc_epicspells"

void RestMeUp(object oPC)
{
    FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
    ForceRest(oPC);
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC) ||
        GetIsEpicFavSoul(oPC) || GetIsEpicHealer(oPC))
    {
        ReplenishSlots(oPC);
    }
}


 
void main()
{
    object oPC=OBJECT_SELF;

    if (!GetLocalInt(oPC,"ForceRest"))
    {

      AssignCommand(oPC, ClearAllActions(FALSE));
      // Start the special conversation with oPC.
      AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "_rest_button", TRUE, FALSE));
    }
    DeleteLocalInt(oPC,"ForceRest");
}