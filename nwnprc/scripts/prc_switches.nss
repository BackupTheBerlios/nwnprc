void main()
{
    object oPC = OBJECT_SELF;
    SetLocalString(oPC, "DynConv_Script", "prc_switchesc");
    ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
}
