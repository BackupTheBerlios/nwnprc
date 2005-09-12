void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac8", OBJECT_SELF);
    else
        ExecuteScript("x2_def_ondisturb", OBJECT_SELF);
    ExecuteScript("prc_npc_disturb", OBJECT_SELF);
}