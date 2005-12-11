/*:://////////////////////////////////////////////
//:: Spell Name Antilife Shell : On Enter
//:: Spell FileName PHS_S_AntilifeSA
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It is a mobile barrier, with a special AOE.

    Basically, if the caster is doing an ACTION_TYPE_MOVE_TO_POINT and someone
    activates the OnEnter script, that creature makes the barrier collapse.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    // Stop if they are not an alive thing, or is plot, or is a DM
    if(GetIsDM(oTarget) || GetPlotFlag(oTarget) || oTarget == oCaster) return;

    // If we are starting still, do not hedge back
    if(GetLocalInt(oCaster, PHS_MOVING_BARRIER_START + IntToString(PHS_SPELL_ANTILIFE_SHELL))) return;

    // Races:
    //    animals, aberrations, dragons, fey, giants, humanoids,
    //    magical beasts, monstrous humanoids, oozes, plants, and vermin,
    // But not:
    //    constructs, elementals, outsiders, or undead
    switch(GetRacialType(oTarget))
    {
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_OUTSIDER:
        case RACIAL_TYPE_INVALID:
        case RACIAL_TYPE_UNDEAD:
            return;
        break;
    }

    // Check if we are moving, and therefore cannot force it agsint soemthing
    // that would be affected!
    vector vVector = GetPosition(oCaster);
    object oArea = GetArea(oCaster);
    DelayCommand(0.1, PHS_MobileAOECheck(oCaster, PHS_SPELL_ANTILIFE_SHELL, vVector, oArea));

    // The target is allowed a Spell resistance and immunity check to force
    // thier way through the barrier
    if(PHS_SpellResistanceCheck(oCaster, oTarget)) return;

    // Make sure they are not immune to spells
    if(PHS_TotalSpellImmunity(oTarget)) return;

    // Distance we need to move them back is going to be 4M away, so out of the
    // AOE.

    // Therefore, this is 4 - Current Distance.
    float fDistance =  4.0 - GetDistanceBetween(oCaster, oTarget);

    // Debug stuff, obviously we'll need to move them at least 1 meter away.
    if(fDistance < 1.0)
    {
        fDistance = 1.0;
    }

    // Move the enterer back from the caster.
    PHS_PerformMoveBack(oCaster, oTarget, fDistance, GetCommandable(oTarget));
}
