//::///////////////////////////////////////////////
//:: Name      Blade of Blood event script
//:: FileName  prc_evnt_bladeb.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oPC = OBJECT_SELF;
	effect eTest = GetFirstEffect(oPC);
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	
	//if spell has expired, remove event hook
	if(!GetHasSpellEffect(SPELL_BLADE_OF_BLOOD, oPC))
	{
		RemoveEventScript(oWeapon, EVENT_ONHIT, "prc_evnt_bladeb");
		return;
	}
	
	while (GetIsEffectValid(eTest))
	{
		int nSpell = GetEffectSpellId(eTest);
		if(nSpell == SPELL_BLADE_OF_BLOOD)
		{
			RemoveEffect(oPC, eTest);
		}
		
		eTest = GetNextEffect(oPC);
	}
}
