#include "eldritchtheurgespells"
#include "nw_i0_invocatns"

void main()
{
	int nSpell;
	int nMetaMagic;
	if ((GetHasSpell(SPELL_I_SPELLBLAST))&& (GetLevelByClass(CLASS_TYPE_ELDRITCHTHEURGE)>=3))
	{
		if (IsSpellAoEType(nSpell))
		{
			SetLocalInt(OBJECT_SELF, "SpellblastSpell", nSpell);
			SetLocalInt(OBJECT_SELF, "SpellblastMeta", nMetaMagic);
			int Strref = StringToInt(Get2DAString("spells","Name", nSpell));
			string Name = GetStringByStrRef(Strref);
			SendMessageToPC(OBJECT_SELF, Name+" added to Spellblast");
		}
		else 
		{
			int OldSpell = GetLocalInt(OBJECT_SELF, "SpellblastSpell");
			int OldStrref = StringToInt(Get2DAString("spells","Name", OldSpell));
			string OldName = GetStringByStrRef(OldStrref);
			SendMessageToPC(OBJECT_SELF, "Spell not usable with Spellblast: "+OldName+" is still set as your Spellblast");
		}
	}
	else SendMessageToPC(OBJECT_SELF,"You need to be a level 3 Eldritch Theurge with the Spellblast essence to use this ability");
}