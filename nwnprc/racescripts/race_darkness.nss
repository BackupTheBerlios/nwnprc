/*
    Racepack Darkness
*/

#include "prc_alterations"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
    location lTarget = GetSpellTargetLocation();
    int nDuration; 
    if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_TIEFLING) { nDuration = GetHitDice(OBJECT_SELF); }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_PURE_YUAN) { nDuration = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_ABOM_YUAN) { nDuration = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_FEYRI) { nDuration = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_MALE) { nDuration = 3; }
    else if (GetRacialType(OBJECT_SELF) == RACIAL_TYPE_DROW_FEMALE) { nDuration = 3; }
    
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
}
