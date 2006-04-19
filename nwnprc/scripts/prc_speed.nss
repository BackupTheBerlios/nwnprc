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
    {
        nNewSpeed = StringToInt(Get2DACache("racialtypes", "Endurance", GetRacialType(oPC)));
        //some races dont have a speed listed
        if(!nNewSpeed)
            nNewSpeed = nCurrentSpeed;
    }    
    //test for armor movement changes    
    if(GetPRCSwitch(PRC_PNP_ARMOR_SPEED))
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        //in an onunequip event the armor is still in the slot
        if(GetLocalInt(oPC,"ONEQUIP")==1)
            oArmor = OBJECT_INVALID;
        int nArmorType = GetArmorType(oArmor);
        if(nArmorType == ARMOR_TYPE_MEDIUM)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.75);
        else if(nArmorType == ARMOR_TYPE_HEAVY)
            nNewSpeed = FloatToInt(IntToFloat(nNewSpeed)*0.666);
    }    
    //scale by PC speed
    if(GetPRCSwitch(PRC_REMOVE_PLAYER_SPEED) 
        && (GetIsPC(oPC)
            || GetMovementRate(oPC) == 0))
    {
        //PCs move at 4.0 NPC "normal" is 3.5
        nCurrentSpeed = FloatToInt(IntToFloat(nCurrentSpeed)*(4.0/3.5));
    }  
    //no change, abort
    if(nNewSpeed == nCurrentSpeed)
        return;
    //get relative change    
    float fSpeedChange = IntToFloat(nNewSpeed)/IntToFloat(nCurrentSpeed);
DoDebug("prc_speed NewSpeed = "+IntToString(nNewSpeed)+" OldSpeed = "+IntToString(nCurrentSpeed)+" SpeedChange = "+FloatToString(fSpeedChange));  
DoDebug("GetMovementRate() = "+IntToString(GetMovementRate(oPC)));
    //get the object thats going to apply the effect
    object oWP = GetObjectByTag("PRC_Speed_WP");
    object oLimbo = GetObjectByTag("HEARTOFCHAOS");
    location lLimbo = GetLocation(oLimbo);
    if(!GetIsObjectValid(oLimbo))
        lLimbo = GetStartingLocation();
    //not valid, create it
    if(!GetIsObjectValid(oWP))
    {
        //has to be a creature so it can be jumped around
        //re-used the 2da cache blueprint since it has no scripts
        oWP = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache", lLimbo, FALSE, "PRC_Speed_WP");
        //make sure the player can never interact with it
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oWP);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oWP);
        SetPlotFlag(oWP, TRUE);
        SetCreatureAppearanceType(oWP, APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
    }
    if(!GetIsObjectValid(oWP))
    {
        DoDebug("PRC_Speed_WP is not valid");
    }
    //remove previous effects
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == oWP
            && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
        {   
            DoDebug("Stripping previous speed effect");
            RemoveEffect(oPC, eTest);
        }    
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
DoDebug("Applying an increase in speed "+IntToString(nChange));
        //must be in same area to apply effect
        if(GetArea(oWP) != GetArea(oPC))
            AssignCommand(oWP, 
                ActionJumpToObject(oPC));
        AssignCommand(oWP, 
            ActionDoCommand(
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(
                        EffectMovementSpeedIncrease(nChange)),
                    oPC)));  
    }
    else if(fSpeedChange < 1.0)
    {
        int nChange = FloatToInt((1.0-fSpeedChange)*100.0);
        if(nChange < 0)
            nChange = 0;
        else if(nChange > 99)
            nChange = 99;
DoDebug("Applying an decrease in speed "+IntToString(nChange));
        //must be in same area to apply effect
        if(GetArea(oWP) != GetArea(oPC))
            AssignCommand(oWP, 
                ActionJumpToObject(oPC));
        AssignCommand(oWP, 
            ActionDoCommand(
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    SupernaturalEffect(
                        EffectMovementSpeedDecrease(nChange)),
                    oPC)));  
    }
}