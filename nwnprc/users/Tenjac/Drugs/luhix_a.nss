// Luhix initial effects

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	
	PlayVoiceChat(VOICE_CHAT_PAIN1);
	
	ApplyAbilityDamage(oPC, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	ApplyAbilityDamage(oPC, ABILITY_DEXTERITY, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	ApplyAbilityDamage(oPC, ABILITY_CONSTITUTION, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_INTELLIGENCE, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_WISDOM, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        ApplyAbilityDamage(oPC, ABILITY_CHARISMA, 1, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        
}
