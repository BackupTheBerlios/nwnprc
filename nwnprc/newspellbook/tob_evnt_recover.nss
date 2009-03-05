/*
    Recover all maneuvers through EvalPRCFeats
*/
#include "tob_inc_recovery"

void main()
{
	object oInitiator = OBJECT_SELF;
	if (GetIsBladeMagicUser(oInitiator))
	{
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_SWORDSAGE);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
	}
	if (GetLevelByClass(CLASS_TYPE_JADE_PHOENIX_MAGE, oInitiator))
	{
		SetLocalInt(oInitiator, "JPM_Empowering_Strike_Ready", TRUE);
		SetLocalInt(oInitiator, "JPM_Quickening_Strike_Ready", TRUE);
	}
	if (GetLevelByClass(CLASS_TYPE_DEEPSTONE_SENTINEL, oInitiator))
		SetLocalInt(oInitiator, "DPST_Awaken_Stone_Dragon", TRUE);
}