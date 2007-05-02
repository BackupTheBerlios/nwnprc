//::///////////////////////////////////////////////
//:: Name      Devoted Bulwark 
//:: FileName  tob_devote_blwk.nss
//:://////////////////////////////////////////////7
/** If an enemy deals damage to you with a melee 
attack, you gain a +1 morale bonus to your AC until 
the end of the your next turn.
**/
//////////////////////////////////////////////////////
// Author: Tenjac
// Date:   24.4.07
//////////////////////////////////////////////////////

void main()
{
        object oPC = OBJECT_SELF;
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        
        itemproperty ipBulwark = (ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1));
        IPSafeAddItemProperty(oArmor, ipBulwark, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
        
        AddEventScript(oSword, EVENT_ONHIT, "tob_onht_dvtbwk", TRUE, FALSE);
}
        