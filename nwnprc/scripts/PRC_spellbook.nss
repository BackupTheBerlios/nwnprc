void main()
{
    object oPC = OBJECT_SELF;
    SetLocalString(oPC, "DynConv_Script", "spellbook");
    ActionStartConversation(oPC, "spellbook", TRUE, FALSE);
}
