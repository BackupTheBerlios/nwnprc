
int GetTotalCastingLevel(object oCaster)
{
    int nLevel = GetCasterLvl(TYPE_DIVINE, oCaster);
    if (nLevel < GetCasterLvl(TYPE_ARCANE, oCaster))
        nLevel = GetCasterLvl(TYPE_ARCANE, oCaster); 
    return nLevel;
}

int GetDCSchoolFocusAdjustment(object oPC, string sChool)
{
    int nNewDC = 0;
    if (sChool == "A") // Abjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "C") // Conjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "D") // Divination spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 6;
    }
    if (sChool == "E") // Enchantment spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 6;
    }
    if (sChool == "V") // Evocation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 6;
    }
    if (sChool == "I") // Illusion spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 6;
    }
    if (sChool == "N") // Necromancy spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 6;
    }
    if (sChool == "T") // Transmutation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 6;
    }
    return nNewDC;
}