//::///////////////////////////////////////////////
//:: Name      Unliving Weapon
//:: FileName  sp_unliv_weap.nss
//:://////////////////////////////////////////////
/**@file Unliving Weapon 
Necromancy [Evil] 
Level: Clr 3
Components: V, S, M 
Casting Time: 1 full round 
Range: Touch
Targets: One undead creature 
Duration: 1 hour/level 
Saving Throw: Will negates 
Spell Resistance: Yes

This spell causes an undead creature to explode in a
burst of powerful energy when struck for at least 1
point of damage, or at a set time no longer than the
duration of the spell, whichever comes first. The 
explosion is a 10-foot radius burst that deals 1d6 
points of damage for every two caster levels 
(maximum 10d6).

While this spell can be an effective form of attack 
against an undead creature, necromancers often use 
unliving weapon to create undead capable of suicide 
attacks (if such a term can be applied to something 
that is already dead). Skeletons or zombies with this
spell cast upon them can be very dan­gerous to foes 
that would normally disregard them.

Material Component: A drop of bile and a bit of sulfur.

Author:    Tenjac
Created:   5/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// Set the spellschool
	SPSetSchool(SPELL_SCHOOL_NECROMANCY); 
		
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = HoursToSeconds(nCasterLvl);
			
	//Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Saving Throw
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			//Setup bomb
			int nDam = d6(min((nCasterLvl/2), 10));
			
			if(nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nDam = 6 * min((nCasterLvl/2), 10);
			}
			
			if(nMetaMagic == METAMAGIC_EMPOWER)
			{
				nDam += (nDam/2);
			}
			
			if(nMetaMagic == METAMAGIC_EXTEND)
			{
				fDur += fDur;
			}
			
			
		}
	}
	SPEvilShift(oPC);
	SPSetSchool();
}
