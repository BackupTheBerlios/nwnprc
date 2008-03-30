//////////////////////////////////////////////////
// Girallon Windmill Flesh Rip Onhit
// tob_event_girwfr.nss
// Tenjac 10/17/07
//////////////////////////////////////////////////

#include "spinc_common"

void main()
{
        object oSpellOrigin = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject(oSpellOrigin);
        
        int nHits = GetLocalInt(oTarget, "TOB_GIR_WINDMILL_FR");
        nHits ++;
        
        SetLocalInt(oTarget, "TOB_GIR_WINDMILL_FR", nHits);
}