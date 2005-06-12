//:://////////////////////////////////////////////
//:: Examine Recipe or Item (was: Read Magic)
//:: prccraft_read
//:: Copyright (c) 2003 Gerald Leung.
//::
//:: Created By: Gerald Leung
//:: Created On: November 12, 2003
//:: Edited  By: Guido Imperiale (CRVSADER//KY)
//:: Edited  On: March 1, 2005
//::
//:: Attempt to read an item.  Part of Hierarchical
//:: Design's Item Creation Feats System
//:: The target can be a recipe or an item
//::
//:://////////////////////////////////////////////

#include "prc_inc_craft"

void main()
{
	if (GetLocalInt(GetModule(), "PRC_DISABLE_CRAFT")) {
	    SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CRAFTDISABLED);
	    return;
	}
	
    object oItem = GetSpellTargetObject();
    
    //If targeting a valid recipe, display its content
    struct ireqreport iReport = CheckIReqs(oItem, TRUE, FALSE);
	
    if (iReport.result == "" && iReport.validrecipe == FALSE)
    {
		//Try to write a recipe
        SendMessageToPCByStrRef(OBJECT_SELF, STRREF_TRYTOWRITERECIPE);
		
		//Need 1 GP
		if (GetGold(OBJECT_SELF) < 1)
			SendMessageToPCByStrRef(OBJECT_SELF, STRREF_NEED1GOLD);
		
        //Try to make a recipe for the item (must be identified)
        else if (!GetIdentified(oItem) || !CreateRecipeFromItem(oItem,OBJECT_SELF))
            SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CANTUNDERSTAND);
		
		//Recipe successfully written; take 1 GP
		else
			TakeGoldFromCreature(1, OBJECT_SELF, TRUE);
    }
}
