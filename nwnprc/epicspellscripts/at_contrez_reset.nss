//:://////////////////////////////////////////////
//:: FileName: "at_contrez_reset"
/*   Purpose: Dispels any active Contingent Resurrections cast by oPC.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();
    SetLocalInt(oPC, "nContingentRez", 0);
}
