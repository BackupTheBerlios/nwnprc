//::///////////////////////////////////////////////
//:: Soulknife multi-event handler
//:: psi_sk_event
//::///////////////////////////////////////////////
/*
    Handles Soulknife stuff for events:
    
    OnRest
    - Changes mindblade enhancement to new settings.
    
    OnEquip
    - Handles prevention of equipping anything in
      left hand if using bastard sword without
      Exotic Prof.
    
    OnUnEquip
    - Destroys any mindblades unequipped.
    
    OnUnAquire
    - Destroys any mindblades lost. Should never
      happen, but paranoia is good.
    
    OnDeath
    - Destroy mindblade on death, just in case.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 06.04.2005
//:://////////////////////////////////////////////

#include "inc_eventhook"
#include "psi_inc_soulkn"
//#include "inc_debug"

/*
void DoDestroy(object oItem){
    //DoDebug("DoDestroy running");
    if(GetIsObjectValid(oItem)){
        DestroyObject(oItem);
        AssignCommand(oItem, SetIsDestroyable(TRUE, FALSE, FALSE));
        DelayCommand(0.05f, DoDestroy(oItem));
    }
}
*/

void ForceUnequip(object oPC, object oItem, int nSlot, int bFirst = TRUE)
{
    if(bFirst){
        DelayCommand(0.3, ForceUnequip(oPC, oItem, nSlot, FALSE));
        return;
    }
    if(GetItemInSlot(nSlot, oPC) == oItem)
    {
        AssignCommand(oPC, ActionUnequipItem(oItem));
        DelayCommand(0.1, ForceUnequip(oPC, oItem, nSlot, FALSE));
    }
}

void main()
{
    object oPC;
    int nEvent = GetRunningEvent();
    
    //DoDebug("psi_sk_event running");
    
    if(nEvent == EVENT_ONPLAYERREST_FINISHED)
    {
        //DoDebug("Rest finished, applying new settings");
        oPC = GetLastBeingRested();
        SetPersistantLocalInt(oPC, MBLADE_FLAGS, GetLocalInt(oPC, MBLADE_FLAGS + "_Q"));
        
        // Make the new settings visible by running the manifesting script
        DelayCommand(0.5f, ExecuteScript("psi_sk_manifmbld", oPC));
    }
    else if(nEvent == EVENT_ONPLAYEREQUIPITEM)
    {
        //DoDebug("Equip");
        oPC = GetItemLastEquippedBy();
        object oItem   = GetItemLastEquipped(),
               oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        
        // Wielding the bastard sword with 2 hands
        if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) &&
           GetBaseItemType(oWeapon) == BASE_ITEM_BASTARDSWORD            &&
           !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
        {
            SendMessageToPCByStrRef(oPC, 16824510);
            ForceUnequip(oPC, GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), INVENTORY_SLOT_LEFTHAND);
        }
        /*if(GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD &&
           !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC) &&
           GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824510);
            ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }*/
        
        // Lacking the correct proficiency to wield non-mindblade version of a short sword
        if(GetBaseItemType(oItem) == BASE_ITEM_SHORTSWORD     &&
           GetTag(oItem) != "prc_sk_mblade_ss"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_RIGHTHAND);
            else
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a longsword
        if(GetBaseItemType(oItem) == BASE_ITEM_LONGSWORD      &&
           GetTag(oItem) != "prc_sk_mblade_ls"                &&
           !(GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) ||
             GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_RIGHTHAND);
            else
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a bastard sword
        if(GetBaseItemType(oItem) == BASE_ITEM_BASTARDSWORD   &&
           GetTag(oItem) != "prc_sk_mblade_bs"                &&
           !GetHasFeat(FEAT_WEAPON_PROFICIENCY_EXOTIC, oPC))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_RIGHTHAND);
            else
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }
        // Lacking the correct proficiency to wield non-mindblade version of a throwing axe
        if(GetBaseItemType(oItem) == BASE_ITEM_THROWINGAXE    &&
           GetTag(oItem) != "prc_sk_mblade_th"                &&
           !GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))
        {
            SendMessageToPCByStrRef(oPC, 16824511);
            // Check which slot the weapon got equipped into
            if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC) == oItem)
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_RIGHTHAND);
            else
                ForceUnequip(oPC, oItem, INVENTORY_SLOT_LEFTHAND);
        }
    }
    else if(nEvent == EVENT_ONPLAYERUNEQUIPITEM)
    {
        //DoDebug("Unequip");
        object oItem = GetItemLastUnequipped();
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
            MyDestroyObject(oItem);
    }
    else if(nEvent == EVENT_ONUNAQUIREITEM)
    {
        //DoDebug("Acquire");
        object oItem = GetModuleItemLost();
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
            MyDestroyObject(oItem);
    }
    else if(nEvent == EVENT_ONPLAYERDEATH)
    {
        //DoDebug("Death");
        object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, GetLastBeingDied());
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
            MyDestroyObject(oItem);
        oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, GetLastBeingDied());
        if(GetStringLeft(GetTag(oItem), 14) == "prc_sk_mblade_")
            MyDestroyObject(oItem);
    }
}