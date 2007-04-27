//::///////////////////////////////////////////////
//:: Name      Rapid Assault On Enter
//:: FileName  tob_ft_rpdasslt.nss
//:://////////////////////////////////////////////
/** Benefit: In the first round of combat, your melee 
attacks deal an extra 1d6 points of damage.

Author:    Tenjac
Created:   25.4.2007
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

void main()
{
        object oPC = GetAreaOfEffectCreator();
        object oTarget = GetEnteringObject();
        
        if(GetIsEnemy(oTarget, oPC))
        {
                //if wasn't in combat 6.0f ago
                if()
                {
                        //and is in combat now
                        if()
                        {
                                object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
                                
                                if(!GetIsObjectValid(oItem))
                                {
                                        //Get natural weapon
                                        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
                                }
                                
                                object oItem2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
                                
                                if(!GetIsObjectValid(oItem2))
                                {
                                        //Get natural weapon
                                        oItem2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
                                }
                                
                                //set up item prop
                                itemproperty ipBonus = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_MAGICAL,IP_CONST_DAMAGEBONUS_1d6);
                                
                                //give bonus damage if melee
                                if(!IPGetIsRangedWeapon(oItem);
                                {
                                        
                                        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oItem, 6.0f);
                                }
                                
                                if(!IPGetIsRangedWeapon(oItem2);
                                {
                                        AddItemProperty(DURATION_TYPE_TEMPORARY, ipBonus, oItem2, 6.0f);
                                }
                        }
                }
        }
}

//Possible AoE?  On creature enter give bonus to damage if enemy and if the player 
//has been out of combat for 6 seconds.