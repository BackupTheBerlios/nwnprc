//:://////////////////////////////////////////////
//:: FileName: "ss_ep_rainoffire"
/*   Purpose: Rain of Fire - AoE spell that lasts 20 hours and does 3d6 points
        of fire damage per round to all in the AoE.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "inc_epicspells"

int VFX_PER_RAIN_OF_FIRE = 100;

void main()
{
    if (!X2PreSpellCastCode())
    {
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, RAINFIR_DC, RAINFIR_S, RAINFIR_XP))
    {
        effect eAOE = EffectAreaOfEffect(VFX_PER_RAIN_OF_FIRE);
        location lTarget = GetLocation(OBJECT_SELF);
        int nDuration = 20;
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,
            eAOE, lTarget, HoursToSeconds(nDuration));
    }
}

