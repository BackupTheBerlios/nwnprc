//::///////////////////////////////////////////////
//:: Name      Eternity of Torture
//:: FileName  sp_etern_tortr.nss
//:://////////////////////////////////////////////
/**@file Eternity of Torture 
Necromancy [Evil]
Level: Pain 9
Components: V, S, DF 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Target: One creature
Duration: Permanent
Saving Throw: Fortitude partial 
Spell Resistance: Yes

The subject's body is twisted and warped, wracked 
forever with excruciating pain. The subject is 
rendered helpless, but-as long as the spell continues
-it is sustained and has no need for food, drink, or 
air. The subject does not age-all the better to ensure
a true eternity of unimaginable torture. The subject 
takes 1 point of drain to each ability score each day
until all scores are reduced to 0 (except Constitution,
which stays at 1). The subject cannot heal or regenerate.
Lastly, the subject is completely unaware of its 
surroundings, insensate to anything but the excruciating
pain.

A single Fortitude saving throw is all that stands 
between a target and this horrible spell. However, 
even if the saving throw is successful, the target 
still feels terrible (but temporary) pain. The target 
takes 5d6 points of damage immediately and takes a -4
circumstance penalty on attack rolls, saving throws, 
skill checks, and ability checks for 1 round per level 
of the caster.

Author:    Tenjac
Created:   3/25/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = 15000.0f;
		
	
	//Spell resist
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{
			//Fort save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_EVIL))
			{
				AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, fDur)); 
				