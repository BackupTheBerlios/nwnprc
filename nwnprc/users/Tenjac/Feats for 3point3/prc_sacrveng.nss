//////////////////////////////////////////////////////
// Sacred Vengeance
// prc_sac_veng.nss
//////////////////////////////////////////////////////
/** @file SACRED VENGEANCE [DIVINE]
You can channel energy to deal extra damage against undead in melee.
Prerequisite: Ability to turn undead.
Benefit: As a free action, spend one of your turn undead
attempts to add 2d6 points of damage to all your successful melee
attacks against undead until the end of the current round.
*/
////////////////////////////////////////////////////////
// Tenjac 5/15/08
////////////////////////////////////////////////////////
void main()
{
        object oPC = OBJECT_SELF;
        
        if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        {
                SendMessageToPC(oPC, "You must be able to Turn Undead to use this feat.");
                return;
        }
        
        if(!GetHasFeat(oPC, FEAT_TURN_UNDEAD))
        {
                SendMessageToPC(oPC, "You have no remaining uses of Turn Undead");
                return();
        }
        
        DecrementRemainingFeatUses(oPC, FEAT_TURN_UNDEAD);
        
        itemproperty ipDam = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_2d6);
        
        AddItemProperty(DURATION_TYPE_TEMPORARY, ipDam, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), RoundsToSeconds(1.0f));
        
        object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        
        if(GetIsObjectValid(oLefthand) && 
           GetBaseItemType(oLefthand) != BASE_ITEM_LARGESHIELD && 
           GetBaseItemType(oLefthand) != BASE_ITEM_SMALLSHIELD &&
           GetBaseItemType(oLefthand) != BASE_ITEM_TOWERSHIELD) AddItemProptery(DURATION_TYPE_TEMPORARY, ipDam, oLefthand, RoundsToSeconds(1.0f));
        }
}  