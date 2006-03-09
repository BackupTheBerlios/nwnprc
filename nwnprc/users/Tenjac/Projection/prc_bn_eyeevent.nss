//::///////////////////////////////////////////////
//:: Baelnorn Eyes - Eventhooks
//:: prc_bn_eyeevent
//::///////////////////////////////////////////////
/**
    
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	int nEvent = GetRunningEvent();
	object oPC;
	
	if(nEvent == EVENT_ONPLAYEREQUIPITEM)
	{
		oPC = GetItemLastEquippedBy();
		SetLocalInt(oPC, "APPLY_BAELNORN_EYES", 1)
	}
	
	//assigncommand cheatcasting of the 1) spell to the baelnorn char
	AssignCommand(oPC, ActionCastSpellAtObject(SPELL_BAELN_EYES, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
}
