/////////////////////////////////////////////////
// Magma Burst: On Exit
// tm_s0_epMagmaBuC.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Initial explosion (20d8) reflex save, then AoE of lava (10d8),
// fort save.  If more then 5 rnds in the cloud cumulative, you turn to stone
// as the lava hardens (fort save).
/////////////////////////////////////////////////
// Last Updated: 03/15/2004, Nron Ksr
/////////////////////////////////////////////////

void main()
{
    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    DeleteLocalInt( oTarget, "MagmaBurst" );
}
