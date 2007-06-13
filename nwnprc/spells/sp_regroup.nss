//::///////////////////////////////////////////////
//:: Name      Regroup
//:: FileName  sp_regroup.nss
//:://////////////////////////////////////////////
/**@file Regroup
Conjuration (Teleportation)
Level: Duskblade 3, sorcerer/wizard 3
Components: V,S
Casting Time: 1 standard action
Range: Close
Targets: One willing creature/level
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

Each subject of this spell teleports to a square
adjacent to you.  If those squares are occupied or
cannot support the teleported creatures, the creatures
appear as close to you as possible, on a surface that 
can support them, in an unoccupied square.

**/
////////////////////////////////////////////////////
// Author: Tenjac
// Date:   26.9.06
////////////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
	
	object oPC = OBJECT_SELF;
	object oArea = GetArea(oPC);
	object oTarget = GetFirstObjectInArea(oArea);
	int nCounter = PRCGetCasterLevel(oPC);
	
	while(nCounter > 0 && GetIsObjectValid(oTarget))
	{
		if(GetIsFriend(oTarget, oPC) && !GetPlotFlag(oTarget))
		{
			DelayCommand(1.0f, AssignCommand(oTarget, JumpToObject(oPC)));
			nCounter--;
		}
		oTarget = GetNextObjectInArea(oArea);
	}
	SPSetSchool();
}
	
	
	