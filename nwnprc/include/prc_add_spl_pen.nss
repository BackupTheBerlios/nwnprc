#include "prcsp_archmaginc"

int GetHeartWarderPene(int spell_id, object oCaster = OBJECT_SELF) {
	// Guard Expensive Calculations
    if (!GetHasFeat(FEAT_VOICE_SIREN, oCaster)) return 0;

    int  nSchool = GetLocalInt(OBJECT_SELF,"X2_L_LAST_SPELLSCHOOL_VAR");
    
    if ( nSchool != SPELL_SCHOOL_ENCHANTMENT) return 0;
    
	// Bonus Requires Verbal Spells
    string VS = lookup_spell_vs(spell_id);
    if (VS != "v" && VS != "vs")
        return 0;

	// These feats provide greater bonuses or remove the Verbal requirement
	if (GetMetaMagicFeat() == METAMAGIC_SILENT
			|| GetHasFeat(FEAT_SPELL_PENETRATION, oCaster)
			|| GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster)
			|| GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
        return 0;

    return 2;
}

//
//	Calculate Elemental Savant Contributions
//
int ElementalSavantSP(int spell_id, object oCaster = OBJECT_SELF)
{
	int nSP = 0;
	int nES;

	// All Elemental Savants will have this feat
	// when they first gain a penetration bonus.
	// Otherwise this would require checking ~4 items (class or specific feats)
	if (GetHasFeat(FEAT_ES_PEN_1, oCaster)) {
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

			if (nES > 28)		nSP = 10;
			else if (nES > 25)	nSP = 9;
			else if (nES > 22)	nSP = 8;
			else if (nES > 19)	nSP = 7;
			else if (nES > 16)	nSP = 6;
			else if (nES > 13)	nSP = 5;
			else if (nES > 10)	nSP = 4;
			else if (nES > 7)	nSP = 3;
			else if (nES > 4)	nSP = 2;
			else if (nES > 1)	nSP = 1;

		}
	}
	SendMessageToPC(GetFirstPC(), "Your Elemental Penetration modifier is " + IntToString(nSP));
	return nSP;
}

int GetSpellPenetreFocusSchool(object oCaster = OBJECT_SELF)
{
  int  nSchool = GetLocalInt(OBJECT_SELF,"X2_L_LAST_SPELLSCHOOL_VAR");
  
  if (nSchool >0){
     if (GetHasFeat(FEAT_FOCUSED_SPELL_PENETRATION_ABJURATION+nSchool-1, oCaster))
       return 4;}	
	
  return 0;
}

int GetSpellPowerBonus(object oCaster = OBJECT_SELF)
{
    int nBonus = 0;

    if(GetHasFeat(FEAT_SPELLPOWER_10, oCaster))
        nBonus = 10;
    else if(GetHasFeat(FEAT_SPELLPOWER_8, oCaster))
        nBonus = 8;
    else if(GetHasFeat(FEAT_SPELLPOWER_6, oCaster))
        nBonus = 6;
    else if(GetHasFeat(FEAT_SPELLPOWER_4, oCaster))
        nBonus = 4;
    else if(GetHasFeat(FEAT_SPELLPOWER_2, oCaster))
        nBonus = 2;

    return nBonus;
}

// Shadow Weave Feat
// +1 caster level vs SR (school Ench,Illu,Necro)
int ShadowWeavePen(object oCaster = OBJECT_SELF)
{
   int nSP;
   
   if (!GetHasFeat(FEAT_SHADOWWEAVE,oCaster)) return 0;
   if (!GetLocalInt(oCaster, "PatronShar")) return 0 ;
   
   int nSchool = GetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
   if ( nSchool == SPELL_SCHOOL_ENCHANTMENT || nSchool == SPELL_SCHOOL_NECROMANCY || nSchool == SPELL_SCHOOL_ILLUSION)
     nSP++;

   return  nSP;
}

int add_spl_pen(object oCaster = OBJECT_SELF)
{
    int spell_id = GetSpellId();
    int nSP = ElementalSavantSP(spell_id, oCaster);
    nSP += GetHeartWarderPene(spell_id, oCaster);
    nSP += GetSpellPowerBonus(oCaster);
    nSP += GetSpellPenetreFocusSchool(oCaster);
    nSP += ShadowWeavePen(oCaster);
        
    return nSP;
}
