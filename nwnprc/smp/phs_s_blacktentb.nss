/*:://////////////////////////////////////////////
//:: Spell Name Black Tentacles: On Exit
//:: Spell FileName PHS_S_BlackTentB
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Exit removes stuff.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Exit - remove effects
    PHS_AOE_OnExitEffects(PHS_SPELL_EVARDS_BLACK_TENTACLES);
}
