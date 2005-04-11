#include "inc_letoscript"
#include "prc_ccc_inc"
#include "inc_encrypt"
#include "prc_inc_switch"

void main()
{

    object oPC = GetEnteringObject();
    if(GetIsDM(oPC))
        return;//dont mess with DMs


    if(!GetPRCSwitch(PRC_CONVOCC_ENABLE))
        return;

    int bBoot;
    //check that its a multiplayer game
    if(GetPCPublicCDKey(oPC) == "")
    {
        SendMessageToPC(oPC, "This module must be hosted as a multiplayer game with NWNX and Letoscript");
        WriteTimestampedLogEntry("This module must be hosted as a multiplayer game with NWNX and Letoscript");
        bBoot = TRUE;
    }

    //check that letoscript is setup correctly
    StackedLetoScript("<FirstName> <LastName>");
    RunStackedLetoScriptOnObject(oPC, "LETOTEST", "SCRIPT", "", FALSE);
    string sResult = GetLocalString(GetModule(), "LetoResult");
    string sName = GetName(oPC);
    if(sResult != sName
        && sResult != sName+" "
        && sResult != " "+sName)
    {
        SendMessageToPC(oPC, "Letoscript is not setup correctly. Please check that you have changed the directory in inc_letoscript to the correct one.");
        WriteTimestampedLogEntry("Letoscript is not setup correctly. Please check that you have changed the directory in inc_letoscript to the correct one.");
        bBoot = TRUE;
    }

    if(bBoot)
    {
        effect eParal = EffectCutsceneParalyze();
        eParal = SupernaturalEffect(eParal);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
        AssignCommand(oPC, DelayCommand(10.0, BootPC(oPC)));
        return;
    }

    string sEncrypt = Encrypt(GetName(oPC));

    //if using XP for new characters, set returning characters tags to encrypted
    //then you can turn off using XP after all characters have logged on.
    if(GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR)
        && GetTag(oPC) != sEncrypt
        && GetXP(oPC) > 0)
    {
        string sScript = "<gff:set 'Tag' <qq:"+sEncrypt+">>";
        SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
    }

    if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || GetTag(oPC) != sEncrypt)
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
        //Take their Gold
        int nAmount = GetGold(oPC);
        if(nAmount > 0)
        {
            AssignCommand(oPC,TakeGoldFromCreature(nAmount,oPC,TRUE));
        }
        //preserve the PCs dignity by giving them clothes
        object oClothes = CreateItemOnObject("nw_cloth022", oPC);
        AssignCommand(oPC, ActionEquipItem(oClothes, INVENTORY_SLOT_CHEST));
        //start the ConvoCC conversation
        SetLocalString(oPC, "DynConv_Script", "prc_ccc");
        DelayCommand(2.5, AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE)));
        //DISABLE FOR DEBUGGING
        DelayCommand(2.0, AssignCommand(oPC, ActionDoCommand(SetCutsceneMode(oPC, TRUE))));
        SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    }
    else
    {
        //its a returning character, dont do anything
    }
}
