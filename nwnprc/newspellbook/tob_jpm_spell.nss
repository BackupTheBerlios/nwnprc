//:://////////////////////////////////////////////
//:: Spell selection for the Jade Phoenix Mage's abilities
//:: tob_jpm_spell.nss
//:://////////////////////////////////////////////
/** @file
    Spell selection for Jade Phoenix Mage's abilities
    Handles the quickselects

    @author Stratovaris
    @rewritten GC

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "inc_newspellbook"
#include "prc_alterations"

void main()
{
	int nID = GetSpellId();
	if (nID == JPM_SPELL_SELECT_CONVO)
	{
		DelayCommand(0.5, StartDynamicConversation("tob_jpm_spellconv", OBJECT_SELF, DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, FALSE, OBJECT_SELF));
	}
	else if (nID == JPM_SPELL_SELECT_QUICK1)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "JPM_SPELL_QUICK1");
		int nRealSpell = GetLocalInt(oPC, "JPM_REAL_SPELL_QUICK1");
		if(DEBUG) DoDebug("tob_jpm_spell: JPM_REAL_SPELL_QUICK1 value = " + IntToString(nRealSpell));
		SetLocalInt(oPC, "JPM_SPELL_CURRENT", nSpell);
		SetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT", nRealSpell);
		int nRealSpellId = (UseNewSpellBook(oPC)) ? GetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT") : GetLocalInt(oPC, "JPM_SPELL_CURRENT");
		int nUses = PRCGetSpellUsesLeft(nRealSpellId, oPC);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
		FloatingTextStringOnCreature("*You have " + IntToString(nUses) + " uses left*", oPC, FALSE);

	}
	else if (nID == JPM_SPELL_SELECT_QUICK2)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "JPM_SPELL_QUICK2");
		int nRealSpell = GetLocalInt(oPC, "JPM_REAL_SPELL_QUICK2");
		SetLocalInt(oPC, "JPM_SPELL_CURRENT", nSpell);
		SetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT", nRealSpell);
		int nRealSpellId = (UseNewSpellBook(oPC)) ? GetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT") : GetLocalInt(oPC, "JPM_SPELL_CURRENT");
		int nUses = PRCGetSpellUsesLeft(nRealSpellId, oPC);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
		FloatingTextStringOnCreature("*You have " + IntToString(nUses) + " uses left*", oPC, FALSE);
	}
	else if (nID == JPM_SPELL_SELECT_QUICK3)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "JPM_SPELL_QUICK3");
		int nRealSpell = GetLocalInt(oPC, "JPM_REAL_SPELL_QUICK3");
		SetLocalInt(oPC, "JPM_SPELL_CURRENT", nSpell);
		SetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT", nRealSpell);
		int nRealSpellId = (UseNewSpellBook(oPC)) ? GetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT") : GetLocalInt(oPC, "JPM_SPELL_CURRENT");
		int nUses = PRCGetSpellUsesLeft(nRealSpellId, oPC);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
		FloatingTextStringOnCreature("*You have " + IntToString(nUses) + " uses left*", oPC, FALSE);
	}
	else if (nID == JPM_SPELL_SELECT_QUICK4)
	{
		object oPC = OBJECT_SELF;
		int nSpell = GetLocalInt(oPC, "JPM_SPELL_QUICK4");
		int nRealSpell = GetLocalInt(oPC, "JPM_REAL_SPELL_QUICK4");
		SetLocalInt(oPC, "JPM_SPELL_CURRENT", nSpell);
		SetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT", nRealSpell);
		int nRealSpellId = (UseNewSpellBook(oPC)) ? GetLocalInt(oPC, "JPM_REAL_SPELL_CURRENT") : GetLocalInt(oPC, "JPM_SPELL_CURRENT");
		int nUses = PRCGetSpellUsesLeft(nRealSpellId, oPC);
		FloatingTextStringOnCreature("*Selected Spell: " + GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpell))) + "*", oPC, FALSE);
		FloatingTextStringOnCreature("*You have " + IntToString(nUses) + " uses left*", oPC, FALSE);
	}
}
