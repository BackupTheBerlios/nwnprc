#include "jx_inc_spellbook"


void main(int iDataObject)
{
	object oPC = OBJECT_SELF;

	object oScroll = IntToObject(iDataObject);

	// Get the spell found on the scroll
	int iSpellId = -1;
	itemproperty ipCastSpell = GetFirstItemProperty(oScroll);
	while (GetIsItemPropertyValid(ipCastSpell))
	{
		if (GetItemPropertyType(ipCastSpell) == ITEM_PROPERTY_CAST_SPELL)
		{
			int iSubType = GetItemPropertySubType(ipCastSpell);
			iSpellId = StringToInt(Get2DAString("iprp_spells", "SpellIndex", iSubType));
			break;
			
		}
		ipCastSpell = GetNextItemProperty(oScroll);
	}

	// Add the spell in the wizard's spellbook
	if (iSpellId > -1)
	{
		if (JXGetKnowsSpell(iSpellId, CLASS_TYPE_WIZARD))
			SendMessageToPCByStrRef(oPC, 53308);
		else
		{
			JXLearnSpell(iSpellId, CLASS_TYPE_WIZARD);
			SendMessageToPC(oPC, JXStringReplaceToken(GetStringByStrRef(53307), 0, JXGetSpellName(iSpellId)));
			DestroyObject(oScroll);
		}
	}
}