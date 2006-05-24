//::///////////////////////////////////////////////
//:: Name      Luhix
//:: FileName  sp_luhix.nss 
//:://////////////////////////////////////////////
/** Script for the drug Luhix

Author:    Tenjac
Created:   5/23/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
		
	// Initial effects
	PlayVoiceChat(VOICE_CHAT_PAIN1);
	
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_INTELLIGENCE, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_CHARISMA, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        
        //Secondary
        
        float fDur = HoursToSeconds(d3());
		
	effect eCha = EffectAbilityIncrease(ABILITY_CHARISMA, 2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCha, oPC, fDur));
	
	effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION,2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCon, oPC, fDur));
	
	effect eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oPC, fDur));
	
	effect eInt = EffectAbilityIncrease(ABILITY_INTELLIGENCE,2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oPC, fDur));
	
	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH,2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, fDur));
	
	effect eWis = EffectAbilityIncrease(ABILITY_WISDOM,2);
	DelayCommand(60.0f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oPC, fDur));
	
	// Luhix overdose
	//if(overdose)
	{
		if(!FortitudeSave(oPC, 25, SAVING_THROW_TYPE_POISON))
		{
			PlayVoiceChat(VOICE_CHAT_PAIN3);
			DelayCommand(3.0,SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC));
		}
	}
}