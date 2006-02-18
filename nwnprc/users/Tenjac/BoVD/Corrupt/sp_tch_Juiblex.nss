//::///////////////////////////////////////////////
//:: Name      Touch of Juiblex
//:: FileName  sp_tch_Juiblex.nss
//:://////////////////////////////////////////////
/**@file Touch of Juiblex 
Transmutation [Evil] 
Level: Corrupt 3 
Components: V, S, Corrupt
Casting Time: 1 action 
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates 
Spell Resistance: Yes

The subject turns into green slime over the course of
4 rounds. If a remove curse, polymorph other, heal, 
greater restoration, limited wish, miracle, or wish
spell is cast during the 4 rounds of transformation,
the subject is restored to normal but still takes 3d6
points of damage. 

Corruption Cost: 1d6 points of Strength damage.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	
	
	
	