void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ace", OBJECT_SELF);
    else
        ExecuteScript("x2_def_onblocked", OBJECT_SELF);
    ExecuteScript("prc_npc_block", OBJECT_SELF);
}