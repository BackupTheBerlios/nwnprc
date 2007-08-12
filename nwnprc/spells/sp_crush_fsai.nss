/**
 * Crushing Fist of Spite
 *
 * This just tells it to move to the nearest enemy
 */

#include "prc_alterations"

void main()
{
   if (DEBUG) DoDebug("Starting Crushing Fist AI");
   	
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, 20.0, PRCGetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
	if (GetIsEnemy(oTarget, GetMaster()))
	{
		AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
   		AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oTarget, TRUE));
   		// End script for this heartbeat
   		return;
	}
        //Get next target in the spell cone
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, 20.0, PRCGetSpellTargetLocation(), TRUE);
    }
   
   if (DEBUG) DoDebug("Ending Crushing Fist AI");
}
