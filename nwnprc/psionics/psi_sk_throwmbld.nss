//::///////////////////////////////////////////////
//:: Soulknife: Throw Mindblade
//:: psi_sk_throwmbld
//::///////////////////////////////////////////////
/*
    Sets Mindblade type to ranged, runs the blade
    creation script and starts attacking.
    
    Cannot be used if not already wielding a
    mindblade.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 04.04.2005
//:://////////////////////////////////////////////

#include "psi_inc_soulkn"
#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(GetStringLeft(GetTag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)), 14) != "prc_sk_mblade_")
    {// "You must have a mindblade manifested to use this feat."
        SendMessageToPCByStrRef(oPC, 16824509);
        return;
    }


    // Wipe previous actions
    AssignCommand(oPC, ClearAllActions());

    // Create and queue equipping of the throwable blades
    int nPrevShape = GetPersistantLocalInt(oPC, MBLADE_SHAPE);
    SetPersistantLocalInt(oPC, MBLADE_SHAPE, MBLADE_SHAPE_RANGED);
    ExecuteScript("psi_sk_manifmbld", oPC);

    // Queue attacking
    //DelayCommand(0.2f, AssignCommand(oPC, ActionAttack(oTarget)));
    DelayCommand(0.4f, AssignCommand(oPC, PerformAttackRound(oTarget, oPC, EffectVisualEffect(-1))));

    // Return the old blade setting
    SetPersistantLocalInt(oPC, MBLADE_SHAPE, nPrevShape);
}