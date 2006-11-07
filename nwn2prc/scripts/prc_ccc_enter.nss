
#include "prc_alterations"
#include "prc_ccc_inc"
#include "inc_letoscript"
#include "inc_encrypt"
#include "x2_inc_switches"

void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void main()
{

    object oPC = GetEnteringObject();
    if(GetIsDM(oPC))
        return;//dont mess with DMs
    if(!GetIsPC(oPC))
        return;//dont run for NPCs


    
    if(!GetPRCSwitch(PRC_CONVOCC_ENABLE))
        return;

    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    
    int bBoot;
    //check that its a multiplayer game
    if(GetPCPublicCDKey(oPC) == "")
    {
        SendMessageToPC(oPC, "This module must be hosted as a multiplayer game with NWNX and Letoscript");
        WriteTimestampedLogEntry("This module must be hosted as a multiplayer game with NWNX and Letoscript");
        bBoot = TRUE;
    }

    //check that letoscript is setup correctly
    string sScript;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        sScript = LetoGet("FirstName")+" "+LetoGet("LastName");
    else
        sScript = LetoGet("FirstName")+"print ' ';"+LetoGet("LastName");
        
    StackedLetoScript(sScript);
    RunStackedLetoScriptOnObject(oPC, "LETOTEST", "SCRIPT", "", FALSE);
    string sResult = GetLocalString(GetModule(), "LetoResult");
    string sName = GetName(oPC);
    if((    sResult != sName
         && sResult != sName+" "
         && sResult != " "+sName)
         )
    {
        SendMessageToPC(oPC, "Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        WriteTimestampedLogEntry("Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        bBoot = TRUE;
    }

    if(bBoot)
    {
        effect eParal = EffectCutsceneParalyze();
        eParal = SupernaturalEffect(eParal);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
        AssignCommand(oPC, DelayCommand(10.0, CheckAndBoot(oPC)));
        return;
    }

    string sEncrypt;
    sEncrypt= Encrypt(oPC);

    //if using XP for new characters, set returning characters tags to encrypted
    //then you can turn off using XP after all characters have logged on.
    if(GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR)
        && GetTag(oPC) != sEncrypt
        && GetXP(oPC) > 0)
    {
        string sScript = LetoSet("Tag", sEncrypt, "string");
        SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
    }
    

    if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
    {
        //first entry
        // Check Equip Items and get rid of them
        int i;
        for(i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            object oEquip = GetItemInSlot(i,oPC);
            if(GetIsObjectValid(oEquip))
            {
                SetPlotFlag(oEquip,FALSE);
                DestroyObject(oEquip);
            }
        }
        // Check general Inventory and clear it out.
        object oItem = GetFirstItemInInventory(oPC);
        while(GetIsObjectValid(oItem))
        {
            SetPlotFlag(oItem,FALSE);
            if(GetHasInventory(oItem))
            {
                object oItem2 = GetFirstItemInInventory(oItem);
                while(GetIsObjectValid(oItem2))
                {
                    object oItem3 = GetFirstItemInInventory(oItem2);
                    while(GetIsObjectValid(oItem3))
                    {
                        SetPlotFlag(oItem3,FALSE);
                        DestroyObject(oItem3);
                        oItem3 = GetNextItemInInventory(oItem2);
                    }
                    SetPlotFlag(oItem2,FALSE);
                    DestroyObject(oItem2);
                    oItem2 = GetNextItemInInventory(oItem);
                }
            }
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oPC);
        }
        //rest them so that they loose cutscene invisible
        //from previous logons
        ForceRest(oPC);
        //Take their Gold
        AssignCommand(oPC,TakeGoldFromCreature(GetGold(oPC),oPC,TRUE));
        //preserve the PCs dignity by giving them clothes
        //no cos they we cant see any tattoos
        //start the ConvoCC conversation
        DelayCommand(10.0, StartDynamicConversation("prc_ccc", oPC, FALSE, FALSE, TRUE));
        //DISABLE FOR DEBUGGING
        if (!DEBUG)
        {
            SetCutsceneMode(oPC, TRUE);
            SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
        }
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    else
    {
        //its a returning character, dont do anything
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    }
}
