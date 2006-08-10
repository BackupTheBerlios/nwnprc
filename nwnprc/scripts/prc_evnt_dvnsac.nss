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
		int nSpell = GetEffectSpellId(eTest);
		if(nSpell == SPELL_DIVINE_SACRIFICE_2 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_4 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_6 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_8 ||
		   nSpell == SPELL_DIVINE_SACRIFICE_10)
		{
			RemoveEffect(oPC, eTest);
		}
		
		eTest = GetNextEffect(oPC);
	}
}
	
