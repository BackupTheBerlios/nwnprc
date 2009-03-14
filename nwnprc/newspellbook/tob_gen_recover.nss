/*
    This is the delayed recovery script that the player has to manually fire outside of combat to recover maneuvers.
*/
#include "tob_inc_recovery"

// Counts down a minute, then recovers the maneuvers.
void Countdown(object oInitiator, int nTime)
{
	if (0 >= nTime)
	{
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_CRUSADER);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_SWORDSAGE);
		RecoverExpendedManeuvers(oInitiator, MANEUVER_LIST_WARBLADE);
		RecoverPrCAbilities(oInitiator);
		FloatingTextStringOnCreature("You have recovered all expended maneuvers", oInitiator, FALSE);
	}
	else if (!GetIsInCombat(oInitiator)) // Being in combat causes this to fail
	{
		FloatingTextStringOnCreature("You have " + IntToString(nTime) +" seconds until maneuvers are recovered", oInitiator, FALSE);
		DelayCommand(6.0, Countdown(oInitiator, nTime - 6));
	}
}

void main()
{
	object oInitiator = OBJECT_SELF;
	// One minute out of combat
	Countdown(oInitiator, 60);
}