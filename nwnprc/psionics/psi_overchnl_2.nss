//::///////////////////////////////////////////////
//:: Overchannel - 2 manifester levels
//:: psi_overchnl_2
//:://////////////////////////////////////////////
/*
    Sets Overchannel to two manifester levels.
    User will manifest as if it had two more
    level in the currently used manifesting class,
    but takes 3d8 damage.
    
    Can only be used by beings with at least 8 HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

const int nLevel = 2;

void main()
{
    object oCaster = OBJECT_SELF;
    if(!GetLocalInt(oCaster, "WildSurge"))
    {
        if(GetHitDice(oCaster) >= 8)
        {
            SetLocalInt(oCaster, "Overchannel", nLevel);
            FloatingTextStringOnCreature("Overchannel Level Two", oCaster, FALSE);
        }
        else
            FloatingTextStringOnCreature("You need to be at least level 8 to overchannel 2 manifester levels", oCaster, FALSE);
    }
    else
        FloatingTextStringOnCreature("You cannot have Overchannel and Wild Surge active at the same time", oCaster, FALSE);
}