////////////////////////////////////////////////
//  Necromental Energy Drain Touch Onhit
//  prc_c_nmtouch.nss
////////////////////////////////////////////////
/* Living creatures hit by a necromental's natural
weapon attack gain one negative level. A necromental
can use its energy drain ability once per round, 
regardles of the number of natural weapon attacks
the necromental possesses. The save DC to remove
the negative level 24 hours late is 10 + 1/2 the
necromental's HD.  When a necromental bestows a
negative level on a victim, it gains 5 temporary
hit points (10 on a critical hit). These temporary
hit points last for up to 1 hour.
*/
////////////////////////////////////////////////
// Author: Tenjac
// Date: 3/12/07
////////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oItem = OBJECT_SELF; // The item casting triggering this spellscript
        object oSpellTarget = PRCGetSpellTargetObject(); // The one being hit. 
        object oSpellOrigin = OBJECT_SELF; // The one wielding the weapon.
        
        int nAlreadyUsed = GetLocalInt(oItem, "PRC_NECROMENT_TOUCH_PRIOR_USE");
        
        if(nAlreadyUsed == 1)
        {
                if(DEBUG) DoDebug("prc_c_nmtouch.nss - Abort for prior use in round."
                return;
        }
        
        else
        {
                //Set int
                SetLocalInt(oItem, "PRC_NECROMENT_TOUCH_PRIOR_USE", 1);
                
                //Schedule deletion
                DelayCommand(6.0f, DeleteLocalInt(oItem, "PRC_NECROMENT_TOUCH_PRIOR_USE"));
                
                //Deal level drain
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectNegativeLevel(1), oSpellTarget);
                
                //Heal self for 5
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectTemporaryHitpoints(5), oSpellOrigin);
        }
}
                
        