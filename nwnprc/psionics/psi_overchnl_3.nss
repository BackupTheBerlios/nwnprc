//::///////////////////////////////////////////////
//:: Overchannel - 3 manifester levels
//:: psi_overchnl_3
//:://////////////////////////////////////////////
/*
    Sets Overchannel to three manifester levels.
    User will manifest as if it had three more
    level in the currently used manifesting class,
    but takes 5d8 damage.
    
    Can only be used by beings with at least 15 HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

const int nLevel = 3;

void main()
{
    object oCaster = OBJECT_SELF;
    if(!GetLocalInt(oCaster, "WildSurge"))
    {
        if(GetHitDice(oCaster) >= 15)
        {
            SetLocalInt(oCaster, "Overchannel", nLevel);
            FloatingTextStringOnCreature("Overchannel Level Three", oCaster, FALSE);
        }
        else
            FloatingTextStringOnCreature("You need to be at least level 15 to overchannel 3 manifester levels", oCaster, FALSE);
    }
    else
        FloatingTextStringOnCreature("You cannot have Overchannel and Wild Surge active at the same time", oCaster, FALSE);
}