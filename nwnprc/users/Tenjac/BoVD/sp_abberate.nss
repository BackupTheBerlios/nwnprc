//::///////////////////////////////////////////////
//:: Name      Aberrate
//:: FileName  sp_abberate.nss
//:://////////////////////////////////////////////
/**@file Aberrate 
Transmutation [Evil] 
Level: Sor/Wiz 1 
Components: V, S, Fiend 
Casting Time: 1 action 
Range: Touch
Target: One living creature 
Duration: 10 minutes/level 
Saving Throw: Fortitude negates 
Spell Resistance: Yes
 
The caster transforms one creature into an aberration.
The subject's form twists and mutates into a hideous 
mockery of itself. The subject's type changes to 
aberration, and it gains a +1 natural armor bonus to 
AC (due to the toughening and twisting of the flesh) 
for every four levels the caster has, up to a maximum
of +5.

Author:    Tenjac
Created:   
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);