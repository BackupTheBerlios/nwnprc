//::///////////////////////////////////////////////
//:: Name       Monsterous Spider heartbeat
//:: FileName   ver_spider
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spiders can climb up and down when indoors
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 05/05/06
//:://////////////////////////////////////////////

#include "inc_utility"

void main()
{
    //move 1 turn in 6
    if(d6()==1)
    {
        location lMove = GetLocation(OBJECT_SELF);
        //change lMove to be somewhere within 10m
        lMove = GetRandomCircleLocation(lMove, IntToFloat(Random(10)));
        effect eJump = EffectDisappearAppear(lMove);
        //1-4 rounds later
        float fDur = IntToFloat(Random(18)+6);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eJump, OBJECT_SELF, fDur);
    }
}
