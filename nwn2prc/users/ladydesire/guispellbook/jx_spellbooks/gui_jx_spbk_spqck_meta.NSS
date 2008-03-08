//::///////////////////////////////////////////////
//:: JX Spellbook - Spells ready GUI screen event: choose metamagic
//:: gui_jx_spbk_spqck_meta
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Nov 16, 2007
//:://////////////////////////////////////////////
//
// This script is fired when a player selects a metamagic
// feat in the quick spells GUI screen.
// It updates this screen depending on the metamagic feat selected.
//
//:://////////////////////////////////////////////

#include "jx_inc_spbk_process_sprdy"




void main(string sDataString)
{
	object oPC = OBJECT_SELF;

	int iCurrentClass = GetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTCLASS);
	int iMetaMagicPositionUIChosen = StringToInt(JXStringSplit(sDataString, "_", 2));
	int iMetaMagic = 0;

	// Spells without metamagic
	if (iMetaMagicPositionUIChosen != 0)
	{
		// Metamagic feats for non-warlocks
		int iMetaMagicPositionUI = 1;
		if (iCurrentClass != CLASS_TYPE_WARLOCK)
		{
			// Find the metamagic feat at the specified position
			if (GetHasFeat(FEAT_EXTEND_SPELL, oPC))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_EXTEND;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(FEAT_EMPOWER_SPELL, oPC) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_EMPOWER;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(FEAT_MAXIMIZE_SPELL, oPC) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_MAXIMIZE;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(FEAT_QUICKEN_SPELL, oPC) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_QUICKEN;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(FEAT_SILENCE_SPELL, oPC) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_SILENT;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(FEAT_STILL_SPELL, oPC) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_STILL;
				else
					iMetaMagicPositionUI++;
			}
			if (GetHasFeat(1679, oPC) && (iMetaMagic == 0))	// FEAT_PERSISTENT_SPELL
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_PERSISTENT;
				else
					iMetaMagicPositionUI++;
			}
		}
		// Metamagic feats for warlocks
		else
		{
			struct jx_spells_known spellsKnown = JXRestoreSpellsKnown(oPC, iCurrentClass);

			// Find the metamagic feat at the specified position
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_SPEAR))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_ELDRITCH_SPEAR;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HIDEOUS_BLOW) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_HIDEOUS_BLOW;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CHAIN) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_ELDRITCH_CHAIN;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_CONE) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_ELDRITCH_CONE;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_ELDRITCH_DOOM) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_ELDRITCH_DOOM;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_DRAINING_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_DRAINING_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_FRIGHTFUL_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_FRIGHTFUL_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BESHADOWED_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_BESHADOWED_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BRIMSTONE_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_BRIMSTONE_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_HELLRIME_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_HELLRIME_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_BEWITCHING_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_BEWITCHING_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_NOXIOUS_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_NOXIOUS_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_VITRIOLIC_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_VITRIOLIC_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, SPELL_I_UTTERDARK_BLAST) && (iMetaMagic == 0))
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_UTTERDARK_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, 1130) && (iMetaMagic == 0))	// Hindering blast
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_HINDERING_BLAST;
				else
					iMetaMagicPositionUI++;
			}
			if (JXSpellsKnownContainsSpell(spellsKnown, 1131) && (iMetaMagic == 0))	// Binding blast
			{
				if (iMetaMagicPositionUI == iMetaMagicPositionUIChosen)
					iMetaMagic = METAMAGIC_INVOC_BINDING_BLAST;
				else
					iMetaMagicPositionUI++;
			}
		}
	}

	// Save the metamagic found
	SetLocalInt(oPC, JX_UI_SPELLS_QUICK_CURRENTMETAMAGIC, iMetaMagic);

	// Update the quick spells GUI screen
	JXUpdateGUISpellQuick(oPC);
}