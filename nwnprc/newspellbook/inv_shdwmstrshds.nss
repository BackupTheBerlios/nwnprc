/*
    Warlock epic feat
    Shadowmaster - Shades spells
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    int nSpellID = GetSpellId();
    
    if(nSpellID == INVOKE_SHADOWMASTER_SUMMON_SHADOW)
        DoRacialSLA(SPELL_SHADES_SUMMON_SHADOW, CasterLvl);
    if(nSpellID == INVOKE_SHADOWMASTER_CONE_OF_COLD)
        DoRacialSLA(SPELL_SHADES_CONE_OF_COLD, CasterLvl);
    if(nSpellID == INVOKE_SHADOWMASTER_FIREBALL)
        DoRacialSLA(SPELL_SHADES_FIREBALL, CasterLvl);
    if(nSpellID == INVOKE_SHADOWMASTER_STONESKIN)
        DoRacialSLA(SPELL_SHADES_STONESKIN, CasterLvl);
    if(nSpellID == INVOKE_SHADOWMASTER_WALL_OF_FIRE)
        DoRacialSLA(SPELL_SHADES_WALL_OF_FIRE, CasterLvl);
}
