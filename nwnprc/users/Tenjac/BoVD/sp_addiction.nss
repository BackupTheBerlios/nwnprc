//::///////////////////////////////////////////////
//:: Name      Addiction
//:: FileName  sp_addiction.nss
//:://////////////////////////////////////////////
/**@file Addiction
Enchantment
Level: Asn 1, Brd 2, Clr 2, Sor/Wiz 2
Components: V, S, Drug
Casting Time: 1 action 
Range: Touch
Area: One living creature 
Duration: Instantaneous 
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster gives the target an addiction to a drug.
A caster of level 5 or less can force the subject to
become addicted to any drug with a low addiction
rating. A 6th to 10th level caster can force an 
addiction to any drug with a medium addiction 
rating, and 11th to 15th level caster can force
addiction to a drug with a high addiction rating.  
Casters of 16th level or higher can give the
subject an addiction to a drug with an extreme 
addiction rating.

Author:    Tenjac
Created:   5/15/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	effect eVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
		
	//spellhook
	if(!X2PreSpellCastCode()) return;
	
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	//SR
	if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		//Fort save
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			//determine addiction
			int nAddict = DISEASE_ADDICT_TERRAN_BRANDY;
			
			if(nCasterLvl > 5)
			{
				nAddict = DISEASE_ADDICT_MUSHROOM_POWDER;
			}
			if(nCasterLvl > 10)
			{
				nAddcit = DISEASE_ADDICT_VODARE;
			}
			if(nCasterLvl > 15)
			{
				nAddict = DISEASE_ADDICT_AGONY;
			}
			
			//Construct effect
			effect eAddict = EffectDisease(nAddict);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oTarget);
		}
	}
	
	SPSetSchool();
}
		