//::///////////////////////////////////////////////
//:: Name      Mass Fire Shield
//:: FileName  sp_mass_frshld.nss
//:://////////////////////////////////////////////
/**@file Mass Fire Shield
Evocation [Fire or Cold]
Level: Sorcerer/wizard 5, warmage 5
Components: V, S, M
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Targets: One or more allied creatures, no two of which
can be more than 30 ft. apart
Duration: 1 round/level (D)
Save: Will negates (harmless)
Spell Resistance: Yes (harmless)

This spell functions like fire shield (see
page 230 of the Player�s Handbook),
except as noted above.

Author:    Tenjac
Created:   7/6/07
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_EVOCATION);
	
	object oPC = OBJECT_SELF
	location lLoc = GetSpellTargetLocation();
	int nSpell = GetSpellId();
	float fRadius = FeetToMeters(15);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nMetaMagic = PRCGetMetaMagicFeat();
	
	int nSpellName;
	
	if(nSpell == MASS_FIRE_SHIELD_RED) nSpellName = SPELL_PNP_FIRE_SHIELD_RED;
	
	else if (nSpell == MASS_FIRE_SHIELD_BLUE) nSpellName = SPELL_PNP_FIRE_SHIELD_BLUE;
	
	while(GetIsObjectValid(oTarget))
	{
		if(GetIsReactionTypeFriendly(oTarget, oPC))
		{
			ActionCastSpellAtObject(nSpellName, oTarget, nMetaMagic, TRUE);
		}
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	
	SPSetSchool()
}
		
	

