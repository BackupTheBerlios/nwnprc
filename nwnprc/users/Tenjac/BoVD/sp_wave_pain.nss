//::///////////////////////////////////////////////
//:: Name      Wave of Pain
//:: FileName  sp_wave_pain.nss
//:://////////////////////////////////////////////
/**@file Wave of Pain
Necromancy [Evil] 
Level: Brd 6, Pain 7 
Components: S, M 
Casting Time: 1 action 
Range: Close (25 ft. + 5 ft./2 levels) 
Area: Cone
Duration: 1 round/2 levels 
Saving Throw: Fortitude negates 
Spell Resistance: Yes

All living creatures within the cone are overcome 
with pain and suffering. They are stunned for the 
duration of the spell. A creature with no 
discernible anatomy is unaffected by this spell.

Material Component: A needle. 

Author:    Tenjac
Created:   5/10/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	location lLoc = GetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect(VFX_IMP_STUN);
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nMetaMagic = PRCGetMetaMagicFeat();
	int nType = MyPRCGetRacialType(oTarget);
	float fDur = (6.0f * (nCasterLvl/2));
	
	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur = fDur * 2;
	}
			
	//Spellhook
	if(!X2PreSpellCastCode()) return;
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	while(GetIsObjectValid(oTarget))
	{
		//Check for "discernable anatomy"
		if(nType != RACIAL_TYPE_OOZE)
		{
			if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
			{			
				if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
				{
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fDur);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 7.62f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	SPEvilShift(oPC);
	SPSetSchool();
}