#include "town_shop_inc"
#include "alignment_inc"

void main()
{
    //get the PC
    object oPC = GetPCSpeaker();
    //get the town store to use
    object oTown = GetNearestObjectByTag("TownStore");
    if(!GetIsObjectValid(oTown))
        return;

    int nMarkUp;
    int nMarkDown;

    /*
    int nSkill = ;
    int nLevel = GetLocalInt(oTown, "Level");
    int nSkillDC = d20()+nLevel;
    int nRoll = GetSkillRank(nSkill, oPC)+d20();
    string sMess = "* "+GetStringByStrRef(StringToInt(Get2DAString("skills", "Name", nSkill)));
    if(nRoll > nSkillDC)
        sMess += "Sucessful";
    else
        sMess += "Faliure";
    sMess += " "+IntToString(nRoll)+" vs "+IntToString(nSkillDC)+" DC *";
    FloatingTextStringOnCreature(sMess, oPC);
    int nAdjust = nRoll - nSkillDC;
    nAdjust *= 1;
    nMarkUp -= nAdjust;
    nMarkDown += nAdjust;
    */

    //go shopping
    DoShopping(oPC, oTown, nMarkUp, nMarkDown);
    //advance 8 hours
    SetTime(GetTimeHour()+8, GetTimeMinute(), GetTimeSecond(), GetTimeMillisecond());
}
