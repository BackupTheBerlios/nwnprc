/*
	race Entangle
*/
#include "prc_alterations"
#include "x2_inc_spellhook"
void main()
{
    effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel;
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PIXIE) { nCasterLevel = 8; }    
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nCasterLevel = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { nCasterLevel = 3; }
    
    int nDuration = 3 + nCasterLevel;
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}

