#include "jx_inc_script_call"
#include "jx_inc_magic_info_impl"
#include "jx_inc_magic_item_impl"
#include "jx_inc_magic_class_impl"
#include "jx_inc_spbk_class_impl"
#include "jx_inc_magicstaff"
#include "jx_inc_magic_events_impl"
#include "jx_inc_spbk_events_impl"

void main()
{
	// Get the list of parameters
	struct script_param_list paramList = JXScriptGetParameters();
	// Get the operation to perform
	int iOperation = JXScriptGetForkOperation();

	switch (iOperation)
	{
		// Call the implementation of JXGetIsSpellUsingRangedTouchAttack() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLRANGEDTOUCHATTACK:
			JXScriptSetResponseInt(
				JXImplGetIsSpellUsingRangedTouchAttack(
					JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetIsSpellMagical() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLMAGICAL:
			JXScriptSetResponseInt(
				JXImplGetIsSpellMagical(
					JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetIsSpellSupernatural() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLSUPERNATURAL:
			JXScriptSetResponseInt(
				JXImplGetIsSpellSupernatural(
					JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetIsSpellExtraordinary() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLEXTRAORDINARY:
			JXScriptSetResponseInt(
				JXImplGetIsSpellExtraordinary(
					JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetIsSpellMiscellaneous() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLMISCELLANEOUS:
			JXScriptSetResponseInt(
				JXImplGetIsSpellMiscellaneous(
					JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetHasSpellDescriptor() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLDESCRIPTOR:
			JXScriptSetResponseInt(
				JXImplGetHasSpellDescriptor(
					JXScriptGetParameterInt(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXGetSpellSubSchool() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLSUBSCHOOL:
			JXScriptSetResponseInt(
				JXImplGetSpellSubSchool(JXScriptGetParameterInt(paramList, 1)));
			break;
		// Call the implementation of JXGetBaseSpellLevel() defined in "jx_inc_magic_info"
		case JX_FORK_SPELLLEVEL:
			JXScriptSetResponseInt(
				JXSpbkGetBaseSpellLevel(
					JXScriptGetParameterInt(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXDisableItemProperty() defined in "jx_inc_magic_item"
		case JX_FORK_DISABLEITEMPROP:
			JXImplDisableItemProperty(
				JXScriptGetParameterObject(paramList, 1),
				JXScriptGetParameterString(paramList, 2),
				JXScriptGetParameterInt(paramList, 3));
			break;
		// Call the implementation of JXEnableItemProperty() defined in "jx_inc_magic_item"
		case JX_FORK_ENABLEITEMPROP:
			JXImplEnableItemProperty(
				JXScriptGetParameterObject(paramList, 1),
				JXScriptGetParameterString(paramList, 2),
				JXScriptGetParameterInt(paramList, 3));
			break;
		// Call the implementation of JXGetItemCasterLevel() defined in "jx_inc_magic_item"
		case JX_FORK_ITEMCASTERLEVEL:
			JXScriptSetResponseInt(
				JXImplGetItemCasterLevel(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterString(paramList, 2)));
			break;
		// Call the implementation of JXGetItemSpellSchool() defined in "jx_inc_magic_item"
		case JX_FORK_ITEMSPELLSCHOOL:
			JXScriptSetResponseInt(
				JXImplGetItemSpellSchool(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterString(paramList, 2)));
			break;
		// Call the implementation of JXGetIsItemMagical() defined in "jx_inc_magic_item"
		case JX_FORK_ITEMMAGICAL:
			JXScriptSetResponseInt(
				JXImplGetIsItemMagical(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterString(paramList, 2)));
			break;
		// Call the implementation of JXGetMainCasterClass() defined in "jx_inc_magic_class"
		case JX_FORK_MAINCASTERCLASS:
			JXScriptSetResponseInt(
				JXImplGetMainCasterClass(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXGetCreatureArcaneCasterLevel() defined in "jx_inc_magic_class"
		case JX_FORK_CREATUREARCANECASTERLEVEL:
			JXScriptSetResponseInt(
				JXImplGetCreatureArcaneCasterLevel(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXGetCreatureDivineCasterLevel() defined in "jx_inc_magic_class"
		case JX_FORK_CREATUREDIVINECASTERLEVEL:
			JXScriptSetResponseInt(
				JXImplGetCreatureDivineCasterLevel(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXGetCreatureCasterLevel() defined in "jx_inc_magic_class"
		case JX_FORK_CREATURECASTERLEVEL:
			JXScriptSetResponseInt(
				JXImplGetCreatureCasterLevel(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2)));
			break;
		// Call the implementation of JXGetCreatureCasterLevelForSpell() defined in "jx_inc_magic_class"
		case JX_FORK_CREATURECASTERLEVELSPELL:
			JXScriptSetResponseInt(
				JXImplGetCreatureCasterLevelForSpell(
					JXScriptGetParameterInt(paramList, 1),
					JXScriptGetParameterObject(paramList, 2),
					JXScriptGetParameterInt(paramList, 3)));
			break;
		// Call the implementation of JXGetCreatureSpellSaveDC() defined in "jx_inc_magic_class"
		case JX_FORK_CREATURESPELLSAVEDC:
			JXScriptSetResponseInt(
				JXImplGetCreatureSpellSaveDC(
					JXScriptGetParameterInt(paramList, 1),
					JXScriptGetParameterObject(paramList, 2),
					JXScriptGetParameterInt(paramList, 3)));
			break;
		// Call the magic staff system function JXUseStaff()
		case JX_FORK_MAGIC_STAFF:
			JXUseStaff(
				JXScriptGetParameterObject(paramList, 1),
				JXScriptGetParameterInt(paramList, 2));
			break;
		// Call the implementation of JXEventActionCastSpellEnqueued() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLENQUEUED:
			JXScriptSetResponseInt(
				JXImplEventActionCastSpellEnqueued(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2),
					JXScriptGetParameterObject(paramList, 3),
					JXScriptGetParameterLocation(paramList, 4),
					JXScriptGetParameterInt(paramList, 5),
					JXScriptGetParameterInt(paramList, 6),
					JXScriptGetParameterInt(paramList, 7),
					JXScriptGetParameterInt(paramList, 8)));
			break;
		// Call the implementation of JXEventActionCastSpellStarted() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLSTARTED:
			JXScriptSetResponseInt(
				JXImplEventActionCastSpellStarted(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2),
					JXScriptGetParameterObject(paramList, 3),
					JXScriptGetParameterLocation(paramList, 4),
					JXScriptGetParameterInt(paramList, 5),
					JXScriptGetParameterInt(paramList, 6),
					JXScriptGetParameterInt(paramList, 7),
					JXScriptGetParameterInt(paramList, 8)));
			break;
		// Call the implementation of JXEventActionCastSpellConjuring() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLCONJURING:
		{
			object oCaster = JXScriptGetParameterObject(paramList, 1);
			int iSpellId = JXScriptGetParameterInt(paramList, 2);
			object oTarget = JXScriptGetParameterObject(paramList, 3);
			location lTarget = JXScriptGetParameterLocation(paramList, 4);
			int iCasterLevel = JXScriptGetParameterInt(paramList, 5);
			int iMetaMagicFeat = JXScriptGetParameterInt(paramList, 6);
			int iSpellSaveDC = JXScriptGetParameterInt(paramList, 7);
			int iClass = JXScriptGetParameterInt(paramList, 8);

			int bContinue = JXSpbkEventActionCastSpellConjuring(
							 oCaster, iSpellId, oTarget, lTarget, iCasterLevel, iMetaMagicFeat, iSpellSaveDC, iClass);
			if (bContinue)
				bContinue = JXImplEventActionCastSpellConjuring(
							 oCaster, iSpellId, oTarget, lTarget, iCasterLevel, iMetaMagicFeat, iSpellSaveDC, iClass);
			JXScriptSetResponseInt(bContinue);
			break;
		}
		// Call the implementation of JXEventActionCastSpellConjured() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLCONJURED:
			JXScriptSetResponseInt(
				JXImplEventActionCastSpellConjured(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2),
					JXScriptGetParameterObject(paramList, 3),
					JXScriptGetParameterLocation(paramList, 4),
					JXScriptGetParameterInt(paramList, 5),
					JXScriptGetParameterInt(paramList, 6),
					JXScriptGetParameterInt(paramList, 7),
					JXScriptGetParameterInt(paramList, 8)));
			break;
		// Call the implementation of JXEventActionCastSpellCast() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLCAST:
			JXScriptSetResponseInt(
				JXSpbkEventActionCastSpellCast(
					JXScriptGetParameterObject(paramList, 1),
					JXScriptGetParameterInt(paramList, 2),
					JXScriptGetParameterObject(paramList, 3),
					JXScriptGetParameterLocation(paramList, 4),
					JXScriptGetParameterInt(paramList, 5),
					JXScriptGetParameterInt(paramList, 6),
					JXScriptGetParameterInt(paramList, 7),
					JXScriptGetParameterInt(paramList, 8)));
			break;
		// Call the implementation of JXEventActionCastSpellFinished() defined in "jx_inc_magic_events"
		case JX_FORK_EVENTSPELLFINISHED:
			JXImplEventActionCastSpellFinished(
				JXScriptGetParameterObject(paramList, 1),
				JXScriptGetParameterInt(paramList, 2),
				JXScriptGetParameterObject(paramList, 3),
				JXScriptGetParameterLocation(paramList, 4),
				JXScriptGetParameterInt(paramList, 5),
				JXScriptGetParameterInt(paramList, 6),
				JXScriptGetParameterInt(paramList, 7),
				JXScriptGetParameterInt(paramList, 8),
				JXScriptGetParameterInt(paramList, 9));
			break;
	}
}