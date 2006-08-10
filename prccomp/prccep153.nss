/*

    Marker script for PRC Companion for:
        PRC
        CEP153
        
    This script is called "HakMareker" and when run
    sets certain local variables on the module.
    These variables can be tested against later
    and resolved appropriately
*/

void main()
{
    object oMod = GetModule();
    SetLocalInt(oMod, "Marker_PRC", TRUE);
    SetLocalInt(oMod, "Marker_CEP153", TRUE);
}