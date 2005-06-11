//:://///////////////////////////////////////////////////////////
//:: PRC 2DA caching system
//:: 2DA cache - test if feat.2da and spells.2da have been cached
//:: prccache_rbfeat
//::
//:: This file is licensed under the terms of the
//:: GNU GENERAL PUBLIC LICENSE (GPL) Version 2
//::
//:: Created By: Guido Imperiale (CRVSADER//KY)
//:: Created On: April 18, 2004
//::
//:: Test if the cache of spells.2da and feat.2da has been
//:: manually rebult.
//::
//:://////////////////////////////////////////////////////////////


#include "prccache"


int HaveFeatCache()
{
	SQLExecDirect("SELECT label FROM prccache_feat LIMIT 1");
	return (SQLFetch() == SQL_SUCCESS);
}


int HaveSpellsCache()
{
	SQLExecDirect("SELECT label FROM prccache_spells LIMIT 1");
	return (SQLFetch() == SQL_SUCCESS);
}


void Wait()
{
	DelayCommand(30.0, ExecuteScript("prccache_rbfeat", OBJECT_SELF));
}


void main()
{
	if (!PRCCACHE_CC) {
		//2DA rebuild has not finished yet
		Wait();
	}
	
	else if (!HaveFeatCache() || !HaveSpellsCache()) {
		string sMsg = "PRC 2DA Caching System: WARNING: spells and feats cache is out of date and has to be rebuilt!";
		SendMessageToAllDMs(sMsg);
		PrintString(sMsg);
		Wait();
	}
}
