#include "prc_inc_clsfunc"

void main()
{
	object oKiller = GetLastKiller();

    if(GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE)>4)
    {
    	LolthMeat(oKiller);
    }
}