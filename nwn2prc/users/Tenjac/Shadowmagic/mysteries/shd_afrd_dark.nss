//::///////////////////////////////////////////////
//:: Name      Afraid of the Dark
//:: FileName  shd_afrd_dark.nss
//:://////////////////////////////////////////////
/**@file Afraid of the Dark
Apprentice, Umbral Mind
Level/School: 3rd/Illusion (Mind-Affecting, Shadow)
Range: Medium (100ft + 10ft/level)
Duration:  Instantaneous
Saving Throw:  Will half
Spell Resistance: Yes

You draw forth a twisted reflection of your foe from
the Plane of Shadow.  The image unerringly touches
the subject, causing Wisdom damage equal to 1d6 
points +1 point per four caster levels (max +5). A
Will saving throw halves the Wisdom damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "spinc_shadow"

void main()
{
	if(!X2PreSpellCastCode()) return;
	
	
	object oPC = OBJECT_SELF;
	object oTarget = PRCGetSpellTargetObject();
	object oCopy = CopyObject(oTarget, GetLocation(oTarget), oPC);
	int nMystLevel = PRCGetMysteryUserLevel(oPC);
	int nDam = d6(1) + min((nMystLevel/4), 5);
	
	//Metashadow
	
	//Force touch attack
	
	//SR
	if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
	{
		
	
	
