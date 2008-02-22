/*
    Nymph Dimension Door
*/
const int SPELLID_TELEPORT_SELF_ONLY         = 2891;
const int SPELLID_TELEPORT_PARTY             = 2892;
const int SPELLID_TELEPORT_SELF_ONLY_DIRDIST = 2896;
const int SPELLID_TELEPORT_PARTY_DIRDIST     = 2897;

#include "prc_inc_racial"
#include "prc_inc_clsfunc"

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
