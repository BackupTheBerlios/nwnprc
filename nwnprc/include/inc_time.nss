/*
This set of functions controlls time for players. Each players individual time ahead
of the server is tracked by a local float TimeAhead which is a second count. 
When recalculate time is called, the clock advances to that of the most behind player.

This system works best with single party modules. If you have multiple parties and player
you may find that when the server catches up it may disorent players for a time.


*/

void AdvanceTimeForPlayer(object oPC, float fSeconds);

void RecalculateTime()
{
    object oPC = GetFirstPC();
    float fLowestAhead = GetLocalFloat(oPC, "TimeAhead");
    while(GetIsObjectValid(oPC))
    {
        if(GetLocalFloat(oPC, "TimeAhead") < fLowestAhead)
            fLowestAhead = GetLocalFloat(oPC, "TimeAhead");
        oPC = GetNextPC();    
    }
    if(fLowestAhead == 0.0)
        return;
    SetTime(GetTimeHour(), GetTimeMinute(), 
        GetTimeSecond()+FloatToInt(fLowestAhead), GetTimeMillisecond());    
    oPC = GetFirstPC();   
    while(GetIsObjectValid(oPC))
    {
        SetLocalFloat(oPC, "TimeAhead", GetLocalFloat(oPC, "TimeAhead")-fLowestAhead);
        oPC = GetNextPC();    
    }     
}


void AdvanceTimeForPlayer(object oPC, float fSeconds)
{
    SetLocalFloat(oPC, "TimeAhead", GetLocalFloat(oPC, "TimeAhead")+fSeconds);
    RecalculateTime();
}