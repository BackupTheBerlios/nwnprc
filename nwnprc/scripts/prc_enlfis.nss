#include "prc_alterations"

void EnlightenedFistSpeed(object oPC, object oSkin, int nLevel)
{
	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
	object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

	int iShield = GetBaseItemType(oItemL) == BASE_ITEM_TOWERSHIELD ||
	              GetBaseItemType(oItemL) == BASE_ITEM_LARGESHIELD ||
	              GetBaseItemType(oItemL) == BASE_ITEM_SMALLSHIELD;

	if (GetBaseAC(oArmor) < 4 && !iShield )
		ActionCastSpellOnSelf(SPELL_SACREDSPEED);
}


void EnlightenedFistSR(object oPC, object oSkin, int nLevel)
{
	if(GetLocalInt(oSkin, "EnlightenedFistSR") == nLevel) return;

	int nSR = 10 + nLevel;
	effect eSR = EffectSpellResistanceIncrease(nSR);
	eSR = ExtraordinaryEffect(eSR);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSR, oPC);
	SetLocalInt(oSkin, "EnlightenedFistSR", nLevel);
}


void main()
{
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);

 	int nLevel = GetLevelByClass(CLASS_TYPE_ENLIGHTENEDFIST, oPC);

	RemoveEffectsFromSpell(oPC, SPELL_SACREDSPEED);

	EnlightenedFistSpeed(oPC, oSkin, nLevel);
	if (nLevel >=9 ) EnlightenedFistSR(oPC, oSkin, nLevel + GetLevelByClass(CLASS_TYPE_MONK));

	//Evaluate The Unarmed Strike Feats
	SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);

	//Evaluate Fists
	SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
}