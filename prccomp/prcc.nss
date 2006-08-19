/*

    Marker script for PRC Companion for:
        PRC
        PRC Companion
        
    This script is called "HakMarker" and when run
    sets certain local variables on the module.
    These variables can be tested against later
    and resolved appropriately
*/

void main()
{
    object oMod = GetModule();
    SetLocalInt(oMod, "Marker_PRC", TRUE);
    SetLocalInt(oMod, "Marker_PRCCompanion", TRUE);
}