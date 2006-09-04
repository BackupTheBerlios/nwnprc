#include "prc_alterations"
#include "inc_utility"
#include "inc_dynconv"

void StartTownConvo(object oPC)
{
    SetCutsceneMode(oPC, TRUE);
    AssignCommand(oPC, 
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, 
            EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), 
            oPC,
            9999.9));
    StartDynamicConversation("town_angband", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE);
}

void main()
{
    object oPC = GetEnteringObject();
    if(!GetIsPC(oPC))
        return;

    if(GetPersistantLocalInt(oPC, "Angband_Enter"))
    {
        //comming back from a mission
        //start the town dynconvo
        StartTownConvo(oPC);
    }
    else
    {
        //new character
        SetPersistantLocalInt(oPC, "Angband_Enter", TRUE);
        //give them enough XP to reach level 5
        int nXP = 5*(5-1)*500;
        if(GetXP(oPC) < nXP)
            SetXP(oPC, nXP);
        //give them some initial gold
        int nGP = 9000 - GetGold(oPC);
        GiveGoldToCreature(oPC, nGP);

        //do the intro cutscene
        //start the town dynconvo
        StartTownConvo(oPC);
    }
}
