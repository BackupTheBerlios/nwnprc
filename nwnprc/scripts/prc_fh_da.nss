//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter Death Attack Heartbeat script
    Used the PnP Assassins death attack as reference
    to setup a more PnP style death attack for the
    Foe Hunter.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 12, 2004
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{     
    object oPC = OBJECT_SELF;
    //object oTarget = GetSpellTargetObject();

    // If they are in the middle of a DA or have to wait till times up they are denied
    float fApplyDATime = GetLocalFloat(oPC,"PRC_FH_DEATHATTACK_APPLY");
    if (fApplyDATime > 0.0)
    {
        SendMessageToPC(oPC,"Your are still studying your target wait "+IntToString(FloatToInt(fApplyDATime))+ " seconds before you can perform the death attack");
        return;
    }	

    // Set a variable that tells us we are in the middle of a DA
    // Must study the target for three rounds
    fApplyDATime = RoundsToSeconds(3);
    SetLocalFloat(oPC,"PRC_FH_DEATHATTACK_APPLY", fApplyDATime);
    
    // Kick off a function to count down till they get the DA
    SendMessageToPC(oPC,"You begin to study your target");
    DelayCommand(6.0,ExecuteScript("prc_fh_da_hb", oPC));
}