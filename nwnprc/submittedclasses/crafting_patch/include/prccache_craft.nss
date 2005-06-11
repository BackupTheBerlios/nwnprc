//:://////////////////////////////////////////////////////
//:: PRC 2DA caching system
//:: Optimized fetching functions for the crafting system
//:: prccache_craft
//::
//:: This file is licensed under the terms of the
//:: GNU GENERAL PUBLIC LICENSE (GPL) Version 2
//::
//:: Created By: Guido Imperiale
//:: Created On: January 10, 2004
//:://////////////////////////////////////////////////////


#include "prccache"


struct convocc_req {
    int row;

    string ReqType;
    string ReqParam1;
    string ReqParam2;
};



//sequentially acquire data
struct convocc_req convocc_GetReqs(string file, int row);

//check if target item has a corresponding recipe
string GetRecipeTagFromItem(string sResRef);


struct convocc_req convocc_GetReqs(string file, int row)
{
    struct convocc_req req;

    if (PRC_USE_SQL) 
    {
        //NWNX2/SQL
        if (row == 0) {
            string sQuery = "SELECT reqtype,reqparam1,reqparam2 FROM prccache_reqs WHERE file='" + file + "' ORDER BY ID";
            SQLExecDirect(sQuery);
        }

        if (SQLFetch() == SQL_ERROR) {
            req.row = -1;
        } else {
            req.row       = row;
            req.ReqType   = SQLGetData(1);
            req.ReqParam1 = SQLGetData(2);
            req.ReqParam2 = SQLGetData(3);
        }
    }

    else {
        //Plain slow 2DA
        while (1) 
        {
            req.ReqType  = Get2DAString(file, "ReqType", row);
            if (req.ReqType != "")
                break;

            row++;
            if (row > PREREQ_2DA_END) {
                req.row = -1;
                return req;
            }
        }

        req.row   = row;
        req.ReqParam1 = Get2DAString(file, "ReqParam1", row);
        req.ReqParam2 = Get2DAString(file, "ReqParam2", row);
    }

    return req;
}


string GetRecipeTagFromItem(string sResRef)
{
    if (PRC_USE_SQL) 
    {
        //NWNX2/SQL
        string sQuery = "SELECT file FROM prccache_reqs WHERE ReqType='RESULT' AND ReqParam1='" + sResRef + "'";
        SQLExecDirect(sQuery);
        if (SQLFetch() == SQL_ERROR)
            return "";
        else
            return SQLGetData(1);
    }

    else {
        //Plain slow 2DA
    	
    	object oModule = GetModule();
    	
    	if (GetLocalInt(oModule, "PRC_cache_item_to_ireq") == FALSE) 
    	{
	    	//Cache item_to_ireq into module variables
			int row;
	        for (row = 0; row <= ITEM_TO_IREQ_2DA_END; row++) {
    	        string sResRefRead = Get2DAString("item_to_ireq", "L_RESREF"  , row);
    	        if (sResRefRead != "") {
					string sTagRead    = Get2DAString("item_to_ireq", "RECIPE_TAG", row);
					SetLocalString(oModule, "item_to_ireq" + sResRefRead, sTagRead);
				}
        	}
			SetLocalInt(GetModule(), "PRC_cache_item_to_ireq", TRUE);
    	}
    	
        //Test the cached item_to_ireq
        return GetLocalString(oModule, "item_to_ireq" + sResRef);
    }

    //never reached
    return "";
}
