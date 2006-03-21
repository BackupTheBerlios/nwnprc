//::///////////////////////////////////////////////
//:: Name      Boneblast
//:: FileName  sp_boneblast.nss
//:://////////////////////////////////////////////
/**@file Boneblast
Necromancy [Evil]
Level: Blk 1, Clr 2
Components: V, S, M, Undead
Casting Time: 1 action
Range: Touch
Target: One creature that has a skeleton
Duration: Instantaneous
Saving Throw: Fortitude half or negates 
Spell Resistance: Yes

The caster causes some bone within a touched 
creature to break or crack. The caster cannot specify 
which bone. Because the damage is general rather than 
specific, the target takes 1d3 points of Constitution 
damage. A For­titude save reduces the Constitution damage
by half, or negates it if the full damage would have been
1 point of Constitution damage.

Material Component: The bone of a small child that still lives.
 

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"


void main()
{
	//define vars
	object oPC = OBJECT_SELF;
	int nCasterLvL = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nType = MyPRCGetRacialType(oPC);
	int nCreatureType = MyPRCGetRAcialType(oTarget);
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//Check for undeath
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		
		