/*
    Nymph Dimension Door
*/

#include "prc_alterations"

void main()
{
    int CasterLvl = 7;

    if(GetSpellId() == SPELL_NYMPH_DIMDOOR_SELF)
        DoRacialSLA(SPELLID_TELEPORT_SELF_ONLY, CasterLvl);
    else if(GetSpellId() == SPELL_NYMPH_DIMDOOR_PARTY)
        DoRacialSLA(SPELLID_TELEPORT_PARTY, CasterLvl);
    else if(GetSpellId() == SPELL_NYMPH_DIMDOOR_DIST_SELF)
        DoRacialSLA(SPELLID_TELEPORT_SELF_ONLY_DIRDIST, CasterLvl);
    else if(GetSpellId() == SPELL_NYMPH_DIMDOOR_DIST_PARTY)
        DoRacialSLA(SPELLID_TELEPORT_PARTY_DIRDIST, CasterLvl);
}
