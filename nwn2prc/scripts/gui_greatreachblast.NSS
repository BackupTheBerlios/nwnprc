#include "eldritchtheurgespells"
#include "nw_i0_invocatns"

void main(int nSpell, int nMetaMagic)
{
	if ((GetHasSpell(SPELL_I_GREATREACH))&& (GetLevelByClass(CLASS_TYPE_ELDRITCHTHEURGE)>=10))
	{
		if (IsSpellTouchAttack(nSpell))
		{
			SetLocalInt(OBJECT_SELF, "GreatreachSpell", nSpell);
			SetLocalInt(OBJECT_SELF, "GreatreachMeta", nMetaMagic);
			int Strref = StringToInt(Get2DAString("spells","Name", nSpell));
			string Name = GetStringByStrRef(Strref);
			SendMessageToPC(OBJECT_SELF, Name+" added to Greatreach Spellblast");
		}
		else 
		{
			int OldSpell = GetLocalInt(OBJECT_SELF, "GreatreachSpell");
			int OldStrref = StringToInt(Get2DAString("spells","Name", OldSpell));
			string OldName = GetStringByStrRef(OldStrref);
			SendMessageToPC(OBJECT_SELF, "Spell not usable with Greatreach Spellblast: "+OldName+" is still set as your Greatreach Spellblast");
		}
	}
		else SendMessageToPC(OBJECT_SELF,"You need to be a level 10 Eldritch Theurge with the Greatreach Spellblast essence to use this ability");
}