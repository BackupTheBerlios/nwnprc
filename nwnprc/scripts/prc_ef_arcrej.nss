#include "prc_sp_func"
#include "prc_alterations"
#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	int nSpellID = GetLocalInt(oPC, "EF_SPELL_CURRENT");

	if (!PRCGetHasSpell(nSpellID, oPC))
	{
		SendMessageToPC(oPC, "No uses or preperations left for selected spell!");
		return;
	}

	// expend spell use
	PRCDecrementRemainingSpellUses(oPC, nSpellID);

	effect eHeal = EffectHeal(PRCGetSpellLevel(oPC, nSpellID));

	ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
}

