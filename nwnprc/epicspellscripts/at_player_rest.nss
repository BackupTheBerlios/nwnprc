//:://////////////////////////////////////////////
//:: FileName: "at_player_rest"
/*   Purpose: This script should be attached to the Action Taken tab of the
        "I wish to rest" node of the OnPlayerRest conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "nw_i0_spells"
#include "inc_epicspells"

void DoRestingStuff(object oPC);

void RestMeUp(object oPC);

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC,"ForceRest",1);
    DelayCommand(4.0,DeleteLocalInt(oPC,"ForceRest"));

    AssignCommand(oPC, ClearAllActions(FALSE));
    AssignCommand(oPC, ActionRest());
    
    /*
    object oMem = GetFirstFactionMember(oPC, FALSE);
    while (oMem != OBJECT_INVALID)
    {
        if ((!GetIsPC(oMem)) || (GetIsPC(oMem) && oMem == oPC))
            AssignCommand(oMem, ClearAllActions(FALSE));
        if (oMem == oPC)
            AssignCommand(oPC, ActionDoCommand(DoRestingStuff(oPC)));
        else if (GetAssociateType(oMem) == ASSOCIATE_TYPE_HENCHMAN)
            AssignCommand(oMem, ActionDoCommand(DoRestingStuff(oMem)));
        else if (GetAssociateType(oMem) == ASSOCIATE_TYPE_FAMILIAR)
            AssignCommand(oMem, ActionDoCommand(DoRestingStuff(oMem)));
        else if (GetAssociateType(oMem) == ASSOCIATE_TYPE_ANIMALCOMPANION)
            AssignCommand(oMem, ActionDoCommand(DoRestingStuff(oMem)));
        else if (GetAssociateType(oMem) == ASSOCIATE_TYPE_DOMINATED)
            AssignCommand(oMem, ActionDoCommand(DoRestingStuff(oMem)));
        else {}
        oMem = GetNextFactionMember(oPC, FALSE);
    }
    */
    
}

void DoRestingStuff(object oPC)
{
    effect eZzz = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eBlind = EffectBlindness();
    effect eLink = EffectLinkEffects(eZzz, eBlind);

    if (MyPRCGetRacialType(oPC) == RACIAL_TYPE_ELF)  // Elves apparently don't sleep.
    {
        AssignCommand(oPC, ActionPlayAnimation
            (ANIMATION_LOOPING_SIT_CROSS, 1.0, 25.0));
        AssignCommand(oPC, ActionDoCommand(RestMeUp(oPC)));
    }
    else
    {   // Constructs, Oozes, and Undead don't rest.
        if (MyPRCGetRacialType(oPC) != RACIAL_TYPE_CONSTRUCT &&
            MyPRCGetRacialType(oPC) != RACIAL_TYPE_UNDEAD &&
            MyPRCGetRacialType(oPC) != RACIAL_TYPE_OOZE)
        {
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_SIT_CROSS, 1.0, 2.0));
            AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject
                (DURATION_TYPE_TEMPORARY, eLink, oPC, 5.0)));
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0));
            AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject
                (DURATION_TYPE_TEMPORARY, eLink, oPC, 5.0)));
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0));
            AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject
                (DURATION_TYPE_TEMPORARY, eLink, oPC, 5.0)));
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0));
            AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject
                (DURATION_TYPE_TEMPORARY, eLink, oPC, 5.0)));
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0));
            AssignCommand(oPC, ActionPlayAnimation
                (ANIMATION_LOOPING_SIT_CROSS, 1.0, 5.0));
            AssignCommand(oPC, ActionDoCommand(RestMeUp(oPC)));
        }
    }
}

void RestMeUp(object oPC)
{
    FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
    ForceRest(oPC);
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
    {
        ReplenishSlots(oPC);
    }
}
