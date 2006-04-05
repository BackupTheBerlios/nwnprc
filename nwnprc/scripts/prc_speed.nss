#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    //30feet is the default speed 
    //rather than try to fudge around biowares differences
    //Ill just scale relative to that
    int nCurrentSpeed = 30;
    int nRacialSpeed = 30;
    if(GetPRCSwitch(PRC_PNP_RACIAL_SPEED))
        nRacialSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));
    //no change, abort
    if(nRacialSpeed == nCurrentSpeed)
        return;
    //get relative change    
    float fSpeedChange = IntToFloat(nCurrentSpeed)/IntToFloat(30);
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
        if(nChange > 199)
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
        if(nChange > 99)
            nChange = 99;
        AssignCommand(oWP, 
            ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                SupernaturalEffect(
                    EffectMovementSpeedDecrease(nChange)),
                oPC));  
    }
}