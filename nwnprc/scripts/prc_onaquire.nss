//::///////////////////////////////////////////////
//:: OnAcquireItem eventscript
//:: prc_onaquire
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "psi_inc_manifest"

void main()
{
    // Find out the relevant objects
    object oCreature = GetModuleItemAcquiredBy();
    object oItem     = GetModuleItemAcquired();

    // Do not run for some of the PRC special items
    if(GetTag(oItem) == PRC_MANIFESTATION_TOKEN_NAME ||
       GetTag(oItem) == "HideToken"                  ||
       GetResRef(oItem) == "base_prc_skin"
       )
        return;

//if(DEBUG) DoDebug("Running OnAcquireItem, creature = '" + GetName(oCreature) + "' is PC: " + BooleanToString(GetIsPC(oCreature)) + "; Item = '" + GetName(oItem) + "' - '" + GetTag(oItem) + "'");


    //fix for all-beige 1.67 -> 1.68 cloaks
    //gives them a random color
    if(GetBaseItemType(oItem) == BASE_ITEM_CLOAK
        && !GetPRCSwitch(PRC_DYNAMIC_CLOAK_AUTOCOLOUR_DISABLE)
//        && GetItemAppearance(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0) == 1
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1) == 0
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2) == 0
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1) == 0
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2) == 0
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1) == 0
        && GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2) == 0
        && !GetLocalInt(oItem, "CloakDone")
        )
    {
        //pre-1.68 boring bland cloak, colorise it :)
        //move it to temporary storage first
        object oChest = GetObjectByTag("HEARTOFCHAOS");
        DestroyObject(oItem);
        oItem = CopyItem(oItem, oChest, TRUE);
        //set appearance
        //doesnt work yet should do for 1.69
//        DestroyObject(oItem);
//        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, Random(14)+1, TRUE);
        //set colors
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, Random(176), TRUE);
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, Random(176), TRUE);
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, Random(176), TRUE);
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, Random(176), TRUE);
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, Random(176), TRUE);
        DestroyObject(oItem);
        oItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, Random(176), TRUE);
        //move it back
        DestroyObject(oItem);
        oItem = CopyItem(oItem, oCreature, TRUE);
        //mark it as set just to be sure
        SetLocalInt(oItem, "CloakDone", TRUE);
    }

    // This is a resource hog. To work around, we assume that it's not going to cause noticeable issues if
    // racial restrictions are only ever expanded when a PC is involved
    if(GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)) || GetPRCSwitch(PRC_NPC_FORCE_RACE_ACQUIRE))
        ExecuteScript("race_ev_aquire", OBJECT_SELF);

    // Creatures not related to PCs skip this block, contents are irrelevant for them
    if(GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
    {
        if(GetPRCSwitch(PRC_AUTO_IDENTIFY_ON_ACQUIRE))
        {
            if(!GetIdentified(oItem))
            {
                int nLore = GetSkillRank(SKILL_LORE, oCreature);
                int nGP;
                string sMax = Get2DACache("SkillVsItemCost", "DeviceCostMax", nLore);
                int nMax = StringToInt(sMax);
                if (sMax == "")
                    nMax = 120000000;
                // Check for the value of the item first.
                SetIdentified(oItem, TRUE);
                nGP = GetGoldPieceValue(oItem);
                SetIdentified(oItem, FALSE);
                // If oPC has enough Lore skill to ID the item, then do so.
                if(nMax >= nGP)
                {
                    SetIdentified(oItem, TRUE);
                    SendMessageToPC(oCreature, GetStringByStrRef(16826224) + " " + GetName(oItem) + " " + GetStringByStrRef(16826225));
                }
            }
        }

        //rest kits
        if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
            ExecuteScript("sbr_onaquire", OBJECT_SELF);

        //PRC Companion
        //DOA visible dyepot items
        if(GetPRCSwitch(MARKER_PRC_COMPANION))
        {
            if(GetBaseItemType(oItem) == BASE_ITEM_MISCSMALL)
            {
                //x2_it_dyec23
                string sTag = GetTag(oItem);
                if(GetStringLeft(sTag, 9) == "x2_it_dye")
                {
                    //get the color
                    //taken from x2_s3_dyearmour
                    // GZ@2006/03/26: Added new color palette support. Note: Will only work
                    //                if craig updates the in engine functions as well.
                    int nColor     =  0;
                    // See if we find a valid int between 0 and 127 in the last three letters
                    // of the tag, use it as color
                    int nTest      =  StringToInt(GetStringRight(sTag,3));
                    if (nTest > 0 &&
                        nTest < 175 )//magic number, bad!
                        nColor = nTest;
                    else //otherwise, use last two letters, as per legacy HotU
                        nColor = StringToInt(GetStringRight(sTag,2));

                    //use limbo for crafting in
                    object oLimbo = GetObjectByTag("HEARTOFCHAOS");
                    //create the new one with the same tag as the old
                    object oDye = CreateItemOnObject("prccompdye", oLimbo, 1, sTag);
                    //ensure old one is cleaned up
                    DestroyObject(oItem);
                    //if its a metalic dye, modify it to use model 2
                    if(GetStringRight(GetStringLeft(sTag, 10), 1) == "m")
                    {
                        DestroyObject(oDye);
                        oDye = CopyItemAndModify(oDye, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, 2);
                        //metal dye color
                        DestroyObject(oDye);
                        oDye = CopyItemAndModify(oDye, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, nColor);
                    }
                    else
                    {
                        //standard dye
                        DestroyObject(oDye);
                        //cloth and leather use same palettee
                        oDye = CopyItemAndModify(oDye, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, nColor);
                    }
                    //copy the itemprops to cast the dye "spell"
                    itemproperty ipTest = GetFirstItemProperty(oItem);
                    while(GetIsItemPropertyValid(ipTest))
                    {
                        AddItemProperty(DURATION_TYPE_PERMANENT, ipTest, oDye);
                        ipTest = GetNextItemProperty(oItem);
                    }
                    //move it back to the player
                    CopyItem(oDye, oCreature);
                    DestroyObject(oDye);
                }
            }
        }
    }// end if - PC or associate of PC

    // Execute scripts hooked to this event for the creature and item triggering it
    ExecuteAllScriptsHookedToEvent(oCreature, EVENT_ONACQUIREITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACQUIREITEM);
}
