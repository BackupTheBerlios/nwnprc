//::///////////////////////////////////////////////
//:: Overchannel - 1 manifester level
//:: psi_overchnl_1
//:://////////////////////////////////////////////
/*
    Sets Overchannel to one manifester level.
    User will manifest as if it had one more
    level in the currently used manifesting class,
    but takes 1d8 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 21.03.2005
//:://////////////////////////////////////////////

const int nLevel = 1;

void main()
{
    object oCaster = OBJECT_SELF;
    if(!GetLocalInt(oCaster, "WildSurge"))
    {
        SetLocalInt(oCaster, "Overchannel", nLevel);
        FloatingTextStringOnCreature("Overchannel Level One", oCaster, FALSE);
    }
    else
        FloatingTextStringOnCreature("You cannot have Overchannel and Wild Surge active at the same time", oCaster, FALSE);
}