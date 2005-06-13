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

void CreateRecipeAndTakeGold(string sRecipeTag)
{
    object oRecipe = CreateObject(OBJECT_TYPE_ITEM, "itemrecipe", GetLocation(OBJECT_SELF), FALSE, sRecipeTag);
    ActionDoCommand(ActionPickUpItem(oRecipe));
    TakeGoldFromCreature(1, OBJECT_SELF, TRUE);
}

void SafeGetRecipeTagFromItem(string sResRef, int nRow = 0)
{
    if (GetPRCSwitch(PRC_USE_DATABASE)) 
    {
        //NWNX2/SQL
        string sQuery = "SELECT recipe_tag FROM prc_cached2da_item_to_ireq WHERE l_resref='"+sResRef+"'";
        PRC_SQLExecDirect(sQuery);
        if (PRC_SQLFetch() == PRC_SQL_ERROR)
            return;
        else
            CreateRecipeAndTakeGold(PRC_SQLGetData(1));
    }
    else 
    {
        //Plain slow 2DA
        if(nRow > GetPRCSwitch(FILE_END_ITEM_TO_IREQ))
            return;
        int row;            
        for (row = nRow; row <= nRow+100; row++) 
        {
            string sResRefRead = Get2DACache("item_to_ireq", "L_RESREF"  , row);
            if (sResRefRead ==  sResRef) 
            {
                CreateRecipeAndTakeGold(Get2DACache("item_to_ireq", "RECIPE_TAG"  , row));
                return;
            }
        }
        DelayCommand(0.01, SafeGetRecipeTagFromItem(sResRef, nRow+100));
    }

    return;
}

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
        else if (!GetIdentified(oItem))
            SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CANTUNDERSTAND);
        
        //Recipe successfully written; take 1 GP
        else
            SafeGetRecipeTagFromItem(GetResRef(oItem));
    }
}
