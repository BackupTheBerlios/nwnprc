#include "prc_class_const"
#include "prc_feat_const"
#include "lookup_2da_spell"
//#include "prcsp_archmaginc"
#include "prc_add_spl_pen"

// Check for CLASS_TYPE_HIEROPHANT > 0 in caller
int GetWasLastSpellHieroSLA(int spell_id, object oCaster = OBJECT_SELF)
{
	int iAbility = GetLastSpellCastClass() == CLASS_TYPE_INVALID;
	int iSpell   = spell_id == SPELL_HOLY_AURA ||
				   spell_id == SPELL_UNHOLY_AURA ||
				   spell_id == SPELL_BANISHMENT ||
				   spell_id == SPELL_BATTLETIDE ||
				   spell_id == SPELL_BLADE_BARRIER ||
				   spell_id == SPELL_CIRCLE_OF_DOOM ||
				   spell_id == SPELL_CONTROL_UNDEAD ||
				   spell_id == SPELL_CREATE_GREATER_UNDEAD ||
				   spell_id == SPELL_CREATE_UNDEAD ||
				   spell_id == SPELL_CURE_CRITICAL_WOUNDS ||
				   spell_id == SPELL_DEATH_WARD ||
				   spell_id == SPELL_DESTRUCTION ||
				   spell_id == SPELL_DISMISSAL ||
				   spell_id == SPELL_DIVINE_POWER ||
				   spell_id == SPELL_EARTHQUAKE ||
				   spell_id == SPELL_ENERGY_DRAIN ||
				   spell_id == SPELL_ETHEREALNESS ||
				   spell_id == SPELL_FIRE_STORM ||
				   spell_id == SPELL_FLAME_STRIKE ||
				   spell_id == SPELL_FREEDOM_OF_MOVEMENT ||
				   spell_id == SPELL_GATE ||
				   spell_id == SPELL_GREATER_DISPELLING ||
				   spell_id == SPELL_GREATER_MAGIC_WEAPON ||
				   spell_id == SPELL_GREATER_RESTORATION ||
				   spell_id == SPELL_HAMMER_OF_THE_GODS ||
				   spell_id == SPELL_HARM ||
				   spell_id == SPELL_HEAL ||
				   spell_id == SPELL_HEALING_CIRCLE ||
				   spell_id == SPELL_IMPLOSION ||
				   spell_id == SPELL_INFLICT_CRITICAL_WOUNDS ||
				   spell_id == SPELL_MASS_HEAL ||
				   spell_id == SPELL_MONSTROUS_REGENERATION ||
				   spell_id == SPELL_NEUTRALIZE_POISON ||
				   spell_id == SPELL_PLANAR_ALLY ||
				   spell_id == SPELL_POISON ||
				   spell_id == SPELL_RAISE_DEAD ||
				   spell_id == SPELL_REGENERATE ||
				   spell_id == SPELL_RESTORATION ||
				   spell_id == SPELL_RESURRECTION ||
				   spell_id == SPELL_SLAY_LIVING ||
				   spell_id == SPELL_SPELL_RESISTANCE ||
				   spell_id == SPELL_STORM_OF_VENGEANCE ||
				   spell_id == SPELL_SUMMON_CREATURE_IV ||
				   spell_id == SPELL_SUMMON_CREATURE_IX ||
				   spell_id == SPELL_SUMMON_CREATURE_V ||
				   spell_id == SPELL_SUMMON_CREATURE_VI ||
				   spell_id == SPELL_SUMMON_CREATURE_VII ||
				   spell_id == SPELL_SUMMON_CREATURE_VIII ||
				   spell_id == SPELL_SUNBEAM ||
				   spell_id == SPELL_TRUE_SEEING ||
				   spell_id == SPELL_UNDEATH_TO_DEATH ||
				   spell_id == SPELL_UNDEATHS_ETERNAL_FOE ||
				   spell_id == SPELL_WORD_OF_FAITH;

	return iAbility && iSpell;
}

int GetHierophantSLAAdjustment(int spell_id, object oCaster = OBJECT_SELF)
{
	int retval = 0;

	if (GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster) > 0 && GetWasLastSpellHieroSLA(spell_id, oCaster) )
	{
             retval = StringToInt( lookup_spell_cleric_level(spell_id) );
	     retval -= GetLevelByClass(CLASS_TYPE_HIEROPHANT, oCaster);
        }
   
   return retval;
}

int GetHeartWarderDC(int spell_id, object oCaster = OBJECT_SELF)
{
	// Check the curent school
	if (GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR") != SPELL_SCHOOL_ENCHANTMENT)
		return 0;

	if (!GetHasFeat(FEAT_VOICE_SIREN, oCaster)) return 0;

	// Bonus Requires Verbal Spells
	string VS = lookup_spell_vs(GetSpellId());
	if (VS != "v" && VS != "vs")
		return 0;

	// These feats provide greater bonuses or remove the Verbal requirement
	if (GetMetaMagicFeat() == METAMAGIC_SILENT
			|| GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oCaster)
			|| GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oCaster))
		return 0;

	return 2;
}

//
//	Calculate Elemental Savant Contributions
//
int ElementalSavantDC(int spell_id, object oCaster = OBJECT_SELF)
{
	int nDC = 0;
	int nES;

	// All Elemental Savants will have this feat
	// when they first gain a penetration bonus.
	// Otherwise this would require checking ~4 items (class or specific feats)
	if (GetHasFeat(FEAT_ES_FOCUS_1, oCaster)) {
		// get spell elemental type
		string element = ChangedElementalType(spell_id, oCaster);

		// Any value that does not match one of the enumerated feats
		int feat = 0;

		// Specify the elemental type rather than lookup by class?
		if (element == "Fire")
		{
			feat = FEAT_ES_FIRE;
			nES = GetLevelByClass(CLASS_TYPE_ES_FIRE,oCaster);
		}
		else if (element == "Cold")
		{
			feat = FEAT_ES_COLD;
			nES = GetLevelByClass(CLASS_TYPE_ES_COLD,oCaster);
		}
		else if (element == "Electricity")
		{
			feat = FEAT_ES_ELEC;
			nES = GetLevelByClass(CLASS_TYPE_ES_ELEC,oCaster);
		}
		else if (element == "Acid")
		{
			feat = FEAT_ES_ACID;
			nES = GetLevelByClass(CLASS_TYPE_ES_ACID,oCaster);
		}

		// Now determine the bonus
		if (feat && GetHasFeat(feat, oCaster)) 
		{

			if (nES > 28)		nDC = 10;
			else if (nES > 25)	nDC = 9;
			else if (nES > 22)	nDC = 8;
			else if (nES > 19)	nDC = 7;
			else if (nES > 16)	nDC = 6;
			else if (nES > 13)	nDC = 5;
			else if (nES > 10)	nDC = 4;
			else if (nES > 7)	nDC = 3;
			else if (nES > 4)	nDC = 2;
			else if (nES > 1)	nDC = 1;

		}
	}
	SendMessageToPC(GetFirstPC(), "Your Elemental Focus modifier is " + IntToString(nDC));
	return nDC;
}

// Shadow Weave Feat
// DC +1 (school Ench,Illu,Necro)
int ShadowWeaveDC(object oCaster ,object oTarget, int nID )
{
   int nDC;
   int iClass = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT,oTarget)/3;
   
   //if (!GetHasFeat(FEAT_SHADOWWEAVE,oCaster)) return 0-iClass;
   int iShar = GetLocalInt(oCaster, "PatronShar");
   
   int nSchool = GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
   if ( nSchool == SPELL_SCHOOL_ENCHANTMENT || nSchool == SPELL_SCHOOL_NECROMANCY || nSchool == SPELL_SCHOOL_ILLUSION)
      nDC = iShar-iClass;
   else if( nID== SPELL_DARKNESS || nID == SPELLABILITY_AS_DARKNESS  || nID == SPELL_SHADOW_CONJURATION_DARKNESS || nID == 688 || nID ==SHADOWLORD_DARKNESS)
      nDC = iShar-iClass;
      
   return  nDC;

}

int GetChangesToSaveDC(object oTarget, object oCaster/* = OBJECT_SELF*/)
{
    int spell_id = GetSpellId();
    int nDC = ElementalSavantDC(spell_id, oCaster);
    nDC += GetHierophantSLAAdjustment(spell_id, oCaster);
    nDC += GetHeartWarderDC(spell_id, oCaster);
    nDC += GetSpellPowerBonus(oCaster);
    nDC += ShadowWeaveDC(oCaster,oTarget,spell_id);

	return nDC;
}
