//::///////////////////////////////////////////////
//:: Name      Blade of Blood event script
//:: FileName  prc_evnt_bladeb.nss
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
	object oWielder = OBJECT_SELF;	
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oWielder);
	effect eTest = GetFirstEffect(oWeapon);
	int nDamBonus;
	
	//if spell has expired, remove event hook
	if(!GetHasSpellEffect(SPELL_BLADE_OF_BLOOD, oWielder))
	{
		RemoveEventScript(oWeapon, EVENT_ONHIT, "prc_evnt_bladeb");
		return;
	}
	
	int nMetaMagic = GetLocalInt(oWeapon, "PRC_BLADE_BLOOD_METAMAGIC");
	int nSpell = GetLocalInt(oWeapon, "PRC_BLADE_BLOOD_SPELLID");
	
	if(nMetaMagic == METAMAGIC_MAXIMIZE)
	{
		nDamBonus = 6;
	}
	
	if(nSpell == SPELL_BLADE_OF_BLOOD_EMP)
	{		
		nDamBonus = d6(3);
		
		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDamBonus = 18;
		}
		
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oWielder);
	}
	
	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDamBonus += (nDamBonus/2);
	}
	
	//Deal bonus damage
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamBonus, DAMAGE_TYPE_MAGICAL), PRCGetSpellTargetObject());
	
	while (GetIsEffectValid(eTest))
	{
		int nSpell = GetEffectSpellId(eTest);
		if(nSpell == SPELL_BLADE_OF_BLOOD)
		{
			RemoveEffect(oWeapon, eTest);
		}
		
		eTest = GetNextEffect(oWeapon);
	}
	
	//Clean up local ints
	DeleteLocalInt(oWeapon, "PRC_BLADE_BLOOD_METAMAGIC");
	DeleteLocalInt(oWeapon, "PRC_BLADE_BLOOD_SPELLID");
}
