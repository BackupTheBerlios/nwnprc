//::///////////////////////////////////////////////
//:: Tome of Battle include: Martial Lore Skill
//:: tob_inc_martlore
//::///////////////////////////////////////////////
/** @file
    Defines various functions and other stuff that
    do something related to the Martial Lore skill
    See page #28 of Tome of Battle
    
    Functions below are called by the initiator as
    he makes a maneuver.

    @author Stratovarius
    @date   Created - 2007.3.19
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////


//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

/**
 * Returns the maneuver that the Initiator just used
 * @param oInitiator  The maneuver initiator
 * @param nSpellId   maneuver to check
 *
 * @return           nothing, uses SendMessageToPC to give results
 */
void IdentifyManeuver(object oInitiator, int nSpellId);

/**
 * Returns the disciplines that the Initiator has
 * @param oInitiator  The maneuver initiator
 *
 * @return           nothing, uses SendMessageToPC to give results
 */
void IdentifyDiscipline(object oInitiator);

//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_move_const"
#include "prc_alterations"
#include "tob_inc_move"
#include "tob_inc_moveknwn"

//////////////////////////////////////////////////
/*             Internal functions               */
//////////////////////////////////////////////////

void _DoMartialLoreCheck(object oInitiator, object oCheck, int nManeuverLevel, int nSpellId)
{
	// NPCs wouldn't benefit from being told the name of the maneuver
	if (!GetIsPC(oTarget)) return;
	
	// No Bonus normally
	int nSwordSage = 0;
	
	if (TOBGetHasDiscipleFocus(oInitiator, nSpellId)) nSwordSage = 2;
	
	// Roll the check, DC is reduced by Swordsage bonus instead of bonus on check. Same end result.
	if(GetIsSkillSuccessful(oCheck, SKILL_MARTIAL_LORE, 10 + nManeuverLevel - nSwordSage))
	{	// get the name of the initiator and maneuver
		SendMessageToPC(oCheck, GetName(oInitiator) + "initiates" + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellId))));
	}
	else // Skill check failed
	{
		SendMessageToPC(oCheck, GetName(oInitiator) + "initiates unknown maneuver");
	}
}

void _DoDisciplineCheck(object oInitiator, object oCheck, int nInitiatorLevel)
{
	// NPCs wouldn't benefit from being told the disciplines
	if (!GetIsPC(oTarget)) return;
	
	if(GetIsSkillSuccessful(oCheck, SKILL_MARTIAL_LORE, 20 + nInitiatorLevel))
	{	
		// Check the Disciplines, 1 to 9
		sDiscipline = "";
		int 1;
		for(i = 1; i < 10; i++)
		{
			if (TOBGetHasDisciple(oInitiator, i)) 
			{
				sDiscipline += GetDiscipleName(i);
				sDiscipline += ", ";
			}
		}
		// Send the Message
		SendMessageToPC(oCheck, GetName(oInitiator) + "knows maneuvers from" + sDiscipline);
	}
	else // Skill check failed
	{
		SendMessageToPC(oCheck, GetName(oInitiator) + "discipline check failed.");
	}
}

//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void IdentifyManeuver(object oInitiator, int nSpellId)
{
	int nManeuverLevel = GetManeuverLevel(oInitiator);

	// The area to check for martial lore users
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		// If the target has points in the skill
		if (GetSkillRank(SKILL_MARTIAL_LORE, oTarget) > 0) _DoMartialLoreCheck(oInitiator, oTarget, nManeuverLevel, nSpellId);
		
	//Select the next target within the area.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
	}
}

void IdentifyDiscipline(object oInitiator)
{
	int nInitiatorLevel = GetInitiatorLevel(oInitiator);

	// The area to check for martial lore users
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
	//Cycle through the targets within the spell shape until an invalid object is captured.
	while (GetIsObjectValid(oTarget))
	{
		// If the target has points in the skill
		if (GetSkillRank(SKILL_MARTIAL_LORE, oTarget) > 0) _DoDisciplineCheck(oInitiator, oTarget, nInitiatorLevel);
		
	//Select the next target within the area.
	oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oInitiator), TRUE, OBJECT_TYPE_CREATURE);
	}
}