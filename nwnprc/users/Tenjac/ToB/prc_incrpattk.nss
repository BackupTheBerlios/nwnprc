/////////////////////////////////////////////////////////////
// Incorporeal Attack
// prc_incrpattk.nss
/////////////////////////////////////////////////////////////
/* Handles the conversion of attacks into touch attacks for 
incorporeal creatures.
*/

#include "prc_alterations"

void main()
{
        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eNone;
        
        if(IPGetIsRangedWeapon(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))
        
        PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, TRUE, "", "", TRUE, TOUCH_ATTACK_RANGED, FALSE, 0);
                
        
        else PerformAttackRound(oTarget, oPC, eNone, 0.0, 0, 0, 0, TRUE, "", "", TRUE, TOUCH_ATTACK_MELEE, FALSE, 0);
}        