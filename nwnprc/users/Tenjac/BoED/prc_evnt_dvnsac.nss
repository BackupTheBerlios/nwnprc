//::///////////////////////////////////////////////
//:: Name      Divine Sacrifice event script
//:: FileName  prc_evnt_dvnsac.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eTest = GetFirstEffect(oPC);
	
	while (GetIsEffectValid(eTest))
	{
		if(GetEffectSpellId(eTest) == SPELL_DIVINE_SACRIFICE)
		{
			RemoveEffect(oPC, eTest);
		}
		
		eTest = GetNextEffect(oPC);
	}
	
	RemoveEventScript(oPC, EVENT_ONHIT, "prc_evnt_dvnsac", TRUE, FALSE);
	
	
}
	
