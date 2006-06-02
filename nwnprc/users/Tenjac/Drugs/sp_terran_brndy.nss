//::///////////////////////////////////////////////
//:: Name      Terran Brandy
//:: FileName  sp_terran_brndy.nss 
//:://////////////////////////////////////////////
/** Script for the drug Sannish

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "spinc_common"
#include "prc_inc_drugfunc"

void main()
{
	object oPC = OBJECT_SELF;
	
	//Handle resetting addiction DC
	SetPersistantLocalInt(oPC, "PRC_Addiction_TerranBrandy_DC", 6);
			
		//Handle satiation
	SetPersistantLocalInt(oPC, "PRC_TerranBrandySatiation", 10);
	
	//Primary - +2 Caster level 1d20 +20 min
	
	
	//Secondary - 2 Con damage
	Delaycommand(60.0f, ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 2, DURATION_TYPE_TEMPORARY, TRUE, -1.0f));
	
	//Addiction check
	if(!GetHasSpellEffect(oPC, SPELL_DRUG_RESISTANCE))
	{
		if(!PRCMySavingThrow(SAVING_THROW_FORT, oPC, 6, SAVING_THROW_TYPE_DISEASE))
		{
			effect eAddict = EffectDisease(DISEASE_TERRAN_BRANDY_ADDICTION);
			SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eAddict, oPC);
			FloatingTextStringOnCreature("You have become addicted to Terran Brandy.", oPC, FALSE);
		}
	}
	
	//Overdose
	if(GetOverdoseCounter(oPC, "PRC_TerranBrandyOD"))
	{
		ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f)
	}
	
	//OD increment
	IncrementOverdoseTracker(oPC, "PRC_TerranBrandyOD", HoursToSeconds(8));
}
	
		
	