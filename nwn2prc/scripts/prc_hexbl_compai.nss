/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 *
 * This just tells it to follow the master and do nothing else.
 */

#include "prc_alterations"

void main()
{
   if (DEBUG) DoDebug("Starting Dark Companion AI");
   
   // Forces it to move to the master's attack target so it take the penalty.
   if (GetIsInCombat(GetMaster()))
   {
   	object oMove = GetAttackTarget(GetMaster());
   	AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
   	AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oMove, TRUE));
   }
   	
   
   AssignCommand(OBJECT_SELF, ClearAllActions(TRUE));
   AssignCommand(OBJECT_SELF, ActionForceFollowObject(GetMaster(), 4.0));
   
   if (DEBUG) DoDebug("Ending Dark Companion AI");
}
