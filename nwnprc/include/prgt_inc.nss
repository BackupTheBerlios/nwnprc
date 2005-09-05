/*
int    DAMAGE_TYPE_BLUDGEONING  = 1;
int    DAMAGE_TYPE_PIERCING     = 2;
int    DAMAGE_TYPE_SLASHING     = 4;
int    DAMAGE_TYPE_MAGICAL      = 8;
int    DAMAGE_TYPE_ACID         = 16;
int    DAMAGE_TYPE_COLD         = 32;
int    DAMAGE_TYPE_DIVINE       = 64;
int    DAMAGE_TYPE_ELECTRICAL   = 128;
int    DAMAGE_TYPE_FIRE         = 256;
int    DAMAGE_TYPE_NEGATIVE     = 512;
int    DAMAGE_TYPE_POSITIVE     = 1024;
int    DAMAGE_TYPE_SONIC        = 2048;
*/

#include "prgt_inc_trap"
#include "inc_utility"

object CreateTrap(location lLoc, struct trap tTrap);
void DetectPsuedoHB(object oTrap);
void ShowTrap(object oTrap, object oDetector);
void DisarmTrap(object oTrap);
void DoTrapXP(object oTrap, object oTarget, int nEvent);

const float TRAP_SPACING = 2.5;
const int TRAP_EVENT_TRIGGERED = 1;
const int TRAP_EVENT_DISARMED = 2;
const int TRAP_EVENT_RECOVERED = 3;    //this is in addition to being disarmed

object CreateTrap(location lLoc, struct trap tTrap)
{
    effect eDetect = EffectAreaOfEffect(tTrap.nDetectAOE, "prgt_det_ent", "prgt_det_hb", "prgt_det_ext");
    effect eTrap   = EffectAreaOfEffect(tTrap.nTrapAOE, "prgt_trp_ent", "prgt_trp_hb", "prgt_trpt_ext");
    eDetect = SupernaturalEffect(eDetect);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eDetect, lLoc);
    eTrap   = SupernaturalEffect(eTrap);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eTrap,   lLoc);
    //get nearest doest work if the location is exactly the same
    vector vPos = GetPositionFromLocation(lLoc);
    vPos.x += 0.1;
    location lTest = Location(GetAreaFromLocation(lLoc),
                        vPos,
                        GetFacingFromLocation(lLoc));
    object oDetect = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTest, 1);
    object oTrap = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTest, 1);
    if(oTrap == oDetect)
        oTrap = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTest, 2);
    SetLocalObject(oTrap, "Detect", oDetect);
    SetLocalObject(oDetect, "Trap", oTrap);
    SetLocalTrap(oTrap, "TrapSettings", tTrap);
    return oTrap;
}

void ShowTrap(object oTrap, object oDetector)
{
    if(GetLocalInt(oTrap, "Spawned"))
    {
        int nCounter;
        object oRealTrap = GetLocalObject(oTrap, "RealTrap_"+IntToString(nCounter));
        while(GetIsObjectValid(oRealTrap))
        {
            SetTrapDetectedBy(oRealTrap, oDetector);
            nCounter++;
            oRealTrap = GetLocalObject(oTrap, "RealTrap_"+IntToString(nCounter));
        }
        return;
    }
    SetLocalInt(oTrap, "Spawned", TRUE);
    location lLoc = GetLocation(oTrap);
//    float fMaxRadius = 5.0;   //this needs to get the correct radius
    int nTrapAOE = GetLocalTrap(oTrap, "TrapSettings").nTrapAOE;
    float fMaxRadius = StringToFloat(Get2DACache("vfx_persistant", "RADIUS", nTrapAOE));
    float fRadius = fMaxRadius;
    int nCounter = 0;
    string sResRef = GetLocalTrap(oTrap, "TrapSettings").sResRef;
    while(fRadius > 0.0)
    {
        float fDiameter = 2*PI*fRadius;
        int nCount = FloatToInt(fDiameter/TRAP_SPACING);
        float fAngle = 360.0/IntToFloat(nCount);
        float fi;
        location lTest;
        while(fi < 360.0)
        {
            vector vTest = GetPositionFromLocation(lLoc);
            vTest.x += cos(fi)*fRadius;
            vTest.y += sin(fi)*fRadius;
            lTest =  Location(GetAreaFromLocation(lLoc), vTest, GetFacingFromLocation(lLoc));
            object oRealTrap = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, lTest);
            SetTrapDetectedBy(oRealTrap, oDetector);
            SetLocalObject(oTrap, "RealTrap_"+IntToString(nCounter), oRealTrap);
            SetLocalObject(oRealTrap, "Trap", oTrap);
            nCounter++;
            fi += fAngle;
        }
        fRadius -= TRAP_SPACING;
    }
}

void DetectPsuedoHB(object oTrap)
{
    object oPC = OBJECT_SELF;
    if(!GetLocalInt(oPC, "InDetect"))
        return;
    if(GetDetectMode(oPC)!=DETECT_MODE_ACTIVE
        || !LineOfSightObject(oPC, oTrap))
    {
        DelayCommand(6.0, DetectPsuedoHB(oTrap));
        return;
    }
    int nDetectDC = GetLocalTrap(oTrap, "TrapSettings").nDetectDC;
    if(GetIsSkillSuccessful(oPC, SKILL_SEARCH, nDetectDC))
    {
        ShowTrap(oTrap, oPC);
    }
    DelayCommand(6.0, DetectPsuedoHB(oTrap));
}

void TrapPsuedoHB(object oTrap)
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "InTrap") == 0)
        return;
    if(GetCurrentAction(oPC) != ACTION_DISABLETRAP &&
        GetCurrentAction(oPC) != ACTION_EXAMINETRAP &&
        GetCurrentAction(oPC) != ACTION_FLAGTRAP &&
        GetCurrentAction(oPC) != ACTION_RECOVERTRAP)
    {
        //fire the trap
        string sTriggerScript = GetLocalTrap(oTrap, "TrapSettings").sTriggerScript;
        SetLocalObject(oTrap, "Target", oPC);
        ExecuteScript(sTriggerScript, oTrap);
        DoTrapXP(oTrap, oPC, TRAP_EVENT_TRIGGERED);
        //is it one shot?
        object oRealTrap;
        if(GetLocalInt(oTrap, "Spawned"))
        {
            oRealTrap = GetLocalObject(oTrap, "RealTrap_0");
        }
        else
        {
            string sResRef = GetLocalTrap(oTrap, "TrapSettings").sResRef;
            oRealTrap = CreateObject(OBJECT_TYPE_PLACEABLE, sResRef, GetLocation(oTrap));
            DestroyObject(oRealTrap);
        }
        if(GetTrapOneShot(oRealTrap))
            DelayCommand(1.0, DisarmTrap(oTrap));
    }
    else
    {
        DelayCommand(6.0, TrapPsuedoHB(oTrap));
    }
}

void DisarmTrap(object oTrap)
{
    int nCounter;
    object oRealTrap = GetLocalObject(oTrap, "RealTrap_"+IntToString(nCounter));
    while(GetIsObjectValid(oRealTrap))
    {
        DestroyObject(oRealTrap);
        nCounter++;
        oRealTrap = GetLocalObject(oTrap, "RealTrap_"+IntToString(nCounter));
    }
    object oDetect = GetLocalObject(oTrap, "Detect");
    DestroyObject(oDetect);
    DestroyObject(oTrap);
}

void DoTrapXP(object oTrap, object oTarget, int nEvent)
{
    switch(nEvent)
    {
        case TRAP_EVENT_TRIGGERED:
            if(GetLocalString(GetModule(), PRC_PRGT_XP_SCRIPT_TRIGGERED) != "")
                ExecuteScript(PRC_PRGT_XP_SCRIPT_TRIGGERED, oTarget);
            else if(GetPRCSwitch(PRC_PRGT_XP_AWARD_FOR_TRIGGERED))
                GiveXPRewardToParty(oTarget, OBJECT_INVALID, GetLocalTrap(oTrap, "TrapSettings").nCR);
        break;
        case TRAP_EVENT_DISARMED:
            if(GetLocalString(GetModule(), PRC_PRGT_XP_SCRIPT_DISARMED) != "")
                ExecuteScript(PRC_PRGT_XP_SCRIPT_TRIGGERED, oTarget);
            else if(GetPRCSwitch(PRC_PRGT_XP_AWARD_FOR_DISARMED))
                GiveXPRewardToParty(oTarget, OBJECT_INVALID, GetLocalTrap(oTrap, "TrapSettings").nCR);
        break;
        case TRAP_EVENT_RECOVERED:
            if(GetLocalString(GetModule(), PRC_PRGT_XP_SCRIPT_RECOVERED) != "")
                ExecuteScript(PRC_PRGT_XP_SCRIPT_TRIGGERED, oTarget);
            else if(GetPRCSwitch(PRC_PRGT_XP_AWARD_FOR_RECOVERED))
                GiveXPRewardToParty(oTarget, OBJECT_INVALID, GetLocalTrap(oTrap, "TrapSettings").nCR);
        break;
    }
}
