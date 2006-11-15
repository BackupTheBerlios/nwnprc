// ginc_item_script
/*
   include for item scripts
*/
// ChazM 9/8/06

#include "x2_inc_itemprop"
#include "ginc_debug"

/*
int SCRIPT_MODULE_ON_ACTIVATE_ITEM          = 6;
int SCRIPT_MODULE_ON_ACQUIRE_ITEM           = 7;
int SCRIPT_MODULE_ON_LOSE_ITEM              = 8;

int SCRIPT_MODULE_ON_EQUIP_ITEM             = 15;
int SCRIPT_MODULE_ON_UNEQUIP_ITEM           = 16;
*/


// use item property
int ItemScriptAcquireRunBefore1(object oItem)
{
	int iRet;
	itemproperty ipAdd = ItemPropertyWeightReduction(IP_CONST_REDUCEDWEIGHT_80_PERCENT);

	int iHasProp = IPGetItemHasProperty(oItem, ipAdd, -1, FALSE);
	
	if (iHasProp)
	{
		PrettyDebug("This item script previously acquired.");
		iRet = TRUE;
	}
	else
	{
		IPSafeAddItemProperty(oItem, ipAdd);
		PrettyDebug("This item acquired for the first time.");
		iRet = TRUE;
	}		
	return (iRet);
}

// use first name
int ItemScriptAcquireRunBefore2(object oItem)
{
	int iRet;
	string sFirstName = GetFirstName(oItem);
	if (sFirstName == "plot")
	{
		PrettyDebug("This item previously acquired.");
		iRet = TRUE;
	}
	else
	{
		SetFirstName(oItem, "plot");
		PrettyDebug("This item acquired for the first time.");
		iRet = FALSE;
	}
	return (iRet);
	
}

// use last name
int ItemScriptAcquireRunBefore3(object oItem)
{
	int iRet;
	string sLastName = GetLastName(oItem);
	if (sLastName == "plot")
	{
		PrettyDebug("This item previously acquired.");
		iRet = TRUE;
	}
	else
	{
		SetLastName(oItem, "plot");
		PrettyDebug("This item acquired for the first time.");
		iRet = FALSE;
	}
	return (iRet);
	
}

// use local int
int ItemScriptAcquireRunBefore4(object oItem)
{
	int iRet;
	int iAcquired = GetLocalInt(oItem, "Acquired");
	if (iAcquired == 1)
	{
		PrettyDebug("This item previously acquired.");
		iRet = TRUE;
	}
	else
	{
		SetLocalInt(oItem, "Acquired", 1);
		PrettyDebug("This item acquired for the first time.");
		iRet = FALSE;
	}
	return (iRet);
	
}


// use last character of first name
int ItemScriptAcquireRunBefore5(object oItem)
{
	int iRet;
	string sFirstName = GetFirstName(oItem);
	string sLastChar = GetStringRight(sFirstName, 1);
	
	if (sLastChar == " ")
	{
		PrettyDebug("This item previously acquired.");
		iRet = TRUE;
	}
	else
	{
		sFirstName = sFirstName + " ";
		SetFirstName(oItem, sFirstName);
		PrettyDebug("This item acquired for the first time.");
		iRet = FALSE;
	}
	return (iRet);
	
}

int ItemScriptAcquireRunBefore(object oItem)
{
	return (FALSE);
	//return(ItemScriptAcquireRunBefore5(oItem));
	
}

//void main(){}
