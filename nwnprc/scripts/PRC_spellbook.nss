void main()
{
    object oPC = OBJECT_SELF;
    SetLocalString(oPC, "DynConv_Script", "prc_s_spellb");
    ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE);
}
