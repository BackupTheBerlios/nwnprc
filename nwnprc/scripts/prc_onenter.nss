#include "inc_item_props"
#include "prc_inc_function"

void
ScrubPCSkin(object oPC)
{
    object oSkin = GetPCSkin(oPC);
	itemproperty ip = GetFirstItemProperty(oSkin);
	while (GetIsItemPropertyValid(ip)) {
		// Insert Logic here to determine if we spare a property
		if (GetItemPropertyType(ip) == ITEM_PROPERTY_BONUS_FEAT) {
			// Check for specific Bonus Feats
			// Reference iprp_feats.2da
			int st = GetItemPropertySubType(ip);

			// Spare 400 through 570 except for 428 (currently unknown)
			if (st < 400 || st > 570 || st == 428)
				RemoveItemProperty(oSkin, ip);
		}
		else
			RemoveItemProperty(oSkin, ip);

		// Get the next property
		ip = GetNextItemProperty(oSkin);
	}
}

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
	ScrubPCSkin(oPC);

         
    SetLocalInt(oPC,"ONENTER",1);
    ExecuteScript("onenter_setlocal",oPC);
    
    // Make sure we reapply any bonuses before the player notices they are gone.
    EvalPRCFeats(oPC);
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    CheckSpecialPRCRecs(oPC);
    DeleteLocalInt(oPC,"ONENTER");
}
