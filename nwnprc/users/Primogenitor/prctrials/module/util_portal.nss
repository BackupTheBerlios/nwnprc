void main()
{
    string sTag = GetLocalString(OBJECT_SELF, "DestTag");
    location lDest = GetLocation(GetWaypointByTag(sTag));
    object oPC = GetLastUsedBy();
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionJumpToLocation(lDest));
}
