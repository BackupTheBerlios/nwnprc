////////////////////////////////////////////////
//  Blood Amniote Blood Call Onhit
//  prc_c_baonhit.nss
////////////////////////////////////////////////
/*  Whenever a blood amniote strikes a living 
creature in melee combat, its touch causes the
target's body to expel a portion of its own blood
through the pores. The expelled blood gathers and 
flows across the intervening distance between the
prey and the blood amniote. This attack deals 1d4
points of Constitution damage to the foe.

     If a blood amniote deals as many points of
Constitution damage during its existence as its
full normal hit point total, it self spawns.
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/12/07
////////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oSpellTarget = PRCGetSpellTargetObject(); // On a weapon: The one being hit.
        object oSpellOrigin  = OBJECT_SELF; // On a weapon: The one wielding the weapon. 
        
        //deal 1d4 Con
        ApplyAbilityDamage(oSpellTarget, ABILITY_CONSTITUION, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0);        
}
        
      