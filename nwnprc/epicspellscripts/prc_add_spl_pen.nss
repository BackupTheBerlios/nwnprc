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
			feat = FEAT_ES_FIRE;
		else if (element == "Cold")
			feat = FEAT_ES_COLD;
		else if (element == "Electricity")
			feat = FEAT_ES_ELEC;
		else if (element == "Acid")
			feat = FEAT_ES_ACID;

		// Now determine the bonus
		if (feat && GetHasFeat(feat, oCaster)) {
			if (GetHasFeat(FEAT_ES_PEN_3, oCaster))
				nSP += 3;
			else if (GetHasFeat(FEAT_ES_PEN_2, oCaster))
				nSP += 2;
			else	// We already know FEAT_ES_PEN_1
				nSP += 1;
		}
	}

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

int add_spl_pen(object oCaster = OBJECT_SELF)
{
    int spell_id = GetSpellId();
    int nSP = ElementalSavantSP(spell_id, oCaster);
    nSP += GetHeartWarderPene(spell_id, oCaster);
    nSP += GetSpellPowerBonus(oCaster);
    nSP += GetSpellPenetreFocusSchool(oCaster);
        
    return nSP;
}
