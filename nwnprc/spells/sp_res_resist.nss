//::///////////////////////////////////////////////
//:: Name      Resonating Resistance
//:: FileName  sp_res_resist.nss
//:://////////////////////////////////////////////
/**@file Resonating Resistance 
Transmutation
Level: Clr 5, Mortal Hunter 4, Sor/Wiz 5
Components: V, Fiend 
Casting Time: 1 action 
Range: Personal 
Target: Caster
Duration: 1 minute/level

The caster improves his spell resistance. Each time
a foe attempts to bypass the caster's spell 
resistance, it must make a spell resistance check 
twice. If either check fails, the foe fails to bypass
the spell resistance.

The caster must have spell resistance as an 
extraordinary ability for resonating resistance to 
function. Spell resistance granted by a magic item or
the spell resistance spell does not improve.

Author:    Tenjac
Created:   7/5/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{	
	if(!X2PreSpellCastCode()) return;
	
	PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
	
	object oPC = OBJECT_SELF;
	int nCasterLvl = PRCGetCasterLevel(oPC);
	float fDur = (60.0f * nCasterLvl);
	int nMetaMagic = PRCGetMetaMagicFeat();
	effect eVis = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		
	if(nMetaMagic == METAMAGIC_EXTEND)
	{
		fDur += fDur;
	}
	
	//if is a fiend
	if((GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) && (MyPRCGetRacialType(oPC) == RACIAL_TYPE_OUTSIDER))
	{
		//has spell SR on hide
		object oSkin = GetPCSkin(oPC);
		itemproperty iTest = GetFirstItemProperty(oSkin);
		int bValid = FALSE;
		
		while(GetIsItemPropertyValid(iTest))
		{
			if(GetItemPropertyType(iTest) == ITEM_PROPERTY_SPELL_RESISTANCE)
			{
				bValid = TRUE;
			}
			iTest = GetNextItemProperty(oSkin);
		}
		
		if(bValid == TRUE)
		{
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oPC, fDur);
		}
	}
	
	PRCSetSchool();
}

