/*
    Warlock epic feat
    Master of the Elements summoning
*/
#include "prc_inc_racial"
#include "prc_inc_clsfunc"
#include "inv_inc_invfunc"

void main()
{
    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);

    if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_AIR)
        DoRacialSLA(3197, CasterLvl); //Summon Creature 9 - Air
    if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_EARTH)
        DoRacialSLA(3198, CasterLvl); //Summon Creature 9 - Earth
    if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_FIRE)
        DoRacialSLA(3199, CasterLvl); //Summon Creature 9 - Fire
    if(GetSpellId() == INVOKE_MASTER_OF_ELEMENTS_WATER)
        DoRacialSLA(3200, CasterLvl); //Summon Creature 9 - Water
}
