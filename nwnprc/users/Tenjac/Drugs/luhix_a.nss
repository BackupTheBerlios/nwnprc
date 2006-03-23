// Luhix initial effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA,1);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oPC);
	
	effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION,1);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oPC);
	
	effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY,1);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDex, oPC);
	
	effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE,1);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eInt, oPC);
	
	effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH,1);
	SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oPC);
    
        effect eWis = EffectAbilityDecrease(ABILITY_WISDOM,1);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eWis, oPC);
        
        PlayVoiceChat(VOICE_CHAT_PAIN1);
}
