#include "inc_item_props"
#include "prc_inc_function"

/*void SetUndroppableAndPlot(object oItem)
{
     // -------------------------------------------------------------------------------------------
     // Makes it so that all equipped items cannot be sold or traded without being unequipped first
     // -------------------------------------------------------------------------------------------
     if (GetItemCursedFlag(oItem) == FALSE)
     {
         SetItemCursedFlag(oItem, TRUE);
         SetLocalInt(oItem, "PRC_MadeUndroppable", TRUE);
     }
     if (GetPlotFlag(oItem) == FALSE)
     {
         SetPlotFlag(oItem, TRUE);
         SetLocalInt(oItem, "PRC_MadePlot", TRUE);
     }
}

void SetAllEquippedUndroppableAndPlot(object oPC)
{
    // ---------------------------------------------------------
    // All equipped items are set as unsellable and untradeable.
    // ---------------------------------------------------------
    object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC); SetUndroppableAndPlot(oItem);
           oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC); SetUndroppableAndPlot(oItem);
}*/
    

void main()
{
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
	object oPC = GetEnteringObject();
        object oSkin = GetPCSkin(oPC);
	ScrubPCSkin(oPC, oSkin);
        DeletePRCLocalInts(oSkin);     
        
    //SetAllEquippedUndroppableAndPlot(oPC);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    DeleteLocalInt(oPC,"ONENTER");
}
