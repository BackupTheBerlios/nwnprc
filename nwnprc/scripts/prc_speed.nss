#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    //30feet is the default speed 
    //rather than try to fudge around biowares differences
    //Ill just scale relative to that
    int nCurrentSpeed = 30;
    int nNewSpeed = nCurrentSpeed;
    //test for racial movement changes
    if(GetPRCSwitch(PRC_PNP_RACIAL_SPEED))
        nNewSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));
    //test for armor movement changes    
    if(GetPRCSwitch(PRC_PNP_ARMOR_SPEED))
    {
        int nArmorType = GetArmorType(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC));
        if(nArmorType == ARMOR_TYPE_MEDIUM)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.75);
        else if(nArmorType == ARMOR_TYPE_HEAVY)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.666);
    }    
    //scale by PC speed
    if(GetPRCSwitch(PRC_REMOVE_PLAYER_SPEED) && GetIsPC(oPC))
    {
        //PCs move at 4.0 NPC "normal" is 3.5
        nCurrentSpeed = FloatToInt(IntToFloat(nCurrentSpeed)*(4.0/3.5));
    }
DoDebug("prc_speed NewSpeed = "+IntToString(nNewSpeed)+" OldSpeed = "+IntToString(nCurrentSpeed));    
DoDebug("GetMovementRate() = "+IntToString(GetMovementRate(oPC)));
    //no change, abort
    if(nNewSpeed == nCurrentSpeed)
        return;
    //get relative change    
    float fSpeedChange = IntToFloat(nNewSpeed)/IntToFloat(nCurrentSpeed);
    //get the object thats going to apply the effect
    object oWP = GetWaypointByTag("PRC_Speed_WP");
    //not valid, create it
    if(!GetIsObjectValid(oWP))
    {
        object oLimbo = GetObjectByTag("HEARTOFCHAOS");
        location lLimbo = GetLocation(oLimbo);
        if(!GetIsObjectValid(oLimbo))
            lLimbo = GetStartingLocation();
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lLimbo, FALSE, "PRC_Speed_WP");   
    }
    //remove previous effects
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == oWP
            && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }
    //its an increase
    if(fSpeedChange > 1.0)
    {
        int nChange = FloatToInt((fSpeedChange-1.0)*100.0);
        if(nChange < 0)
            nChange = 0;
        else if(nChange > 199)
            nChange = 199;
        AssignCommand(oWP, 
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                SupernaturalEffect(
                    EffectMovementSpeedIncrease(nChange)),
                oPC));  
    }
    else if(fSpeedChange < 0.0)
    {
        int nChange = FloatToInt((1.0-fSpeedChange)*100.0);
        if(nChange < 0)
            nChange = 0;
        else if(nChange > 99)
            nChange = 99;
        AssignCommand(oWP, 
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                SupernaturalEffect(
                    EffectMovementSpeedDecrease(nChange)),
                oPC));  
    }
}