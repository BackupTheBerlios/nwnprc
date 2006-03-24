//::///////////////////////////////////////////////
//:: Cloud of the Achaierai: On Enter
//:: sp_cloud_achaiA.nss
//:: 
//:://////////////////////////////////////////////
/*
    
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac	
//:: Created On: 3/24/06
//:://////////////////////////////////////////////


#include "spinc_common"

void main()
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);
			
	int nMetaMagic = PRCGetMetaMagicFeat();
	effect eDark = EffectDarkness();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eDark, eDur);
	effect eConf = EffectConfused();
	effect eLinkConf = EffectLinkEffects(eLink, eConf);
	
	object oTarget = GetEnteringObject();
	object oPC = GetAreaOfEffectCreator();
	float fDuration = (nCasterLvl * 600.0f);
	int nDam = d6(2);
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	//Enter Metamagic conditions
	if ((nMetaMagic & METAMAGIC_EXTEND))
	{
		fDuration = fDuration *2; //Duration is +100%
	}
		
	// * July 2003: If has darkness then do not put it on it again
	// Primogenitor: Yes, what about overlapping darkness effects by different casters?
	//if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
	//{
		//    return;
		//}
	
	//if valid                     and not caster
	if(GetIsObjectValid(oTarget) && oTarget != oPC)
	{
		//Spell resistance
		if(!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
		{	
			//Save
			if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkConf, oTarget, fDuration);
			}
			else
			{
				SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
			
			//Damage
			effect eDam = EffectDamage(DAMAGE_TYPE_MAGICAL, nDam);
			SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}
	}	
	
	SPSetSchool(SPELL_SCHOOL_CONJURATION);		
}



