//:://////////////////////////////////////////////
//:: Switch-based speed alterations
//:: prc_speed
//:://////////////////////////////////////////////
/** @file
    A script called from EvalPRCFeats() that
    applies optional speed modifications.

     - Racial speed
     - Medium or heavier armor speed reduction
     - Removal of PC speed advantage
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"


void main()
{
    object oPC = OBJECT_SELF;

    // Load current speed as determined by previous iterations. Or in case of first iteration, hardcoded to 30
    int nCurrentSpeed = GetLocalInt(oPC, "PRC_SwitchbasedSpeed");
    if(!nCurrentSpeed)
        nCurrentSpeed = 30;

    //30feet is the default speed
    //rather than try to fudge around biowares differences
    //Ill just scale relative to that
    int nNewSpeed = 30;

    // See if we should alter speed based on race
    if(GetPRCSwitch(PRC_PNP_RACIAL_SPEED))
    {
        nNewSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));

        // Some races do not have speed listed, in that case default to current
        if(!nNewSpeed)
            nNewSpeed = 30;
    }

    // See if we should alter speed based on armor
    if(GetPRCSwitch(PRC_PNP_ARMOR_SPEED))
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        int nCoc = (GetLevelByClass(CLASS_TYPE_COC, oPC));
        //in an onunequip event the armor is still in the slot
        if(GetItemLastUnequipped() == oArmor && GetLocalInt(oPC, "ONEQUIP") == 1)
            oArmor = OBJECT_INVALID;
        int nArmorType = GetArmorType(oArmor);
        if(nArmorType == ARMOR_TYPE_MEDIUM && nCoc < 5)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * 0.75);
        else if(nArmorType == ARMOR_TYPE_HEAVY && nCoc < 5)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * 0.666);
    }

    // See if we should remove PC speed advantage
    if(GetPRCSwitch(PRC_REMOVE_PLAYER_SPEED) &&
       (GetIsPC(oPC) || GetMovementRate(oPC) == 0)
       )
    {
        //PCs move at 4.0 NPC "normal" is 3.5
        nNewSpeed = FloatToInt(IntToFloat(nNewSpeed) * (3.5 / 4.0));
    }

    // In case of no changes
    if(nNewSpeed == nCurrentSpeed)
        return;

    // Only apply the modification in case the PC is in a valid area. Invalid area means log(in|out)
    if(!GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        return;

    // Store new speed for future checks
    SetLocalInt(oPC, "PRC_SwitchbasedSpeed", nNewSpeed);

    // Determine speed change
    float fSpeedChange = (IntToFloat(nNewSpeed) / 30) - 1.0;
    if(DEBUG) DoDebug("prc_speed: NewSpeed = " + IntToString(nNewSpeed) + "; OldSpeed = " + IntToString(nCurrentSpeed) + "; SpeedChange = " + FloatToString(fSpeedChange));
    if(DEBUG) DoDebug("GetMovementRate() = " + IntToString(GetMovementRate(oPC)));

    //get the object thats going to apply the effect
    //this strips previous effects too
    object oWP = GetObjectToApplyNewEffect("WP_SpeedEffect", oPC, TRUE);

    // Speed increase
    if(fSpeedChange > 0.0)
    {
        int nChange = min(99, max(0, FloatToInt(fSpeedChange * 100.0)));
        if(DEBUG) DoDebug("prc_speed: Applying an increase in speed: " + IntToString(nChange));
        AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                               SupernaturalEffect(EffectMovementSpeedIncrease(nChange)),
                                                               oPC
                      )                    )                   );
    }
    // Speed decrease
    else if(fSpeedChange < 0.0)
    {
        int nChange = min(99, max(0, FloatToInt(-fSpeedChange * 100.0)));
        if(DEBUG) DoDebug("prc_speed: Applying an decrease in speed: " + IntToString(nChange));
        AssignCommand(oWP, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                                                               SupernaturalEffect(EffectMovementSpeedDecrease(nChange)),
                                                               oPC
                      )                    )                   );
    }
}