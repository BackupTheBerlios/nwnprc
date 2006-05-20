//::///////////////////////////////////////////////
//:: Name      Liquid Pain
//:: FileName  sp_liquid_pain.nss
//:://////////////////////////////////////////////
/**@file Liquid Pain
Necromancy
Level: Pain 4, Sor/Wiz 4
Components: V, S, F
Casting Time: 1 day
Range: Touch
Target: One living creature
Duration: Permanent
Saving Throw: Fortitude negates
Spell Resistance: Yes
 
The caster takes a subject already in great pain,
wracked with disease, the victim of torture, or 
dying of a wound, for example-and captures its pain 
in liquid form. This physical manifestation of agony 
can be used to create magic items or enhance spells. It
can also be used as a potent drug.

Focus: A jar, vial, or other container for the liquid pain.

Author:    Tenjac
Created:   5/19/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	effect eVis = EffectVisualEffect(VFX_COM_BLOOD_CRT_RED);
	
	SPRaiseSpellCastAt(oTarget,TRUE, SPELL_LIQUID_PAIN, oPC);
	
	//SR
	if(!MyPRCResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr()))
        {
		//Save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			//Check for pain
			if(GetHasEffect(EFFECT_TYPE_DISEASE, oTarget) ||
			   GetHasEffect(EFFECT_TYPE_POISON, oTarget) ||
			   GetHasSpellEffect(SPELL_ETERNITY_OF_TORTURE, oTarget) ||
			   GetHasSpellEffect(SPELL_WRACK, oTarget) ||
			   GetHasSpellEffect(SPELL_WAVE_OF_PAIN, oTarget) ||
			   GetHasSpellEffect(SPELL_AVASCULAR_MASS, oTarget) ||
			   GetHasSpellEffect(SPELL_RED_FESTER, oTarget))
			{
				//Create liquid pain in caster's inventory
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				//CreateItemOnObject("whateveritis", oPC, 1);
			}
		}
	   
	 }
	 SPSetSchool();	 
 }
			   
			
	
	
	

