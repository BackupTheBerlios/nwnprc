void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac1", OBJECT_SELF);
    else
        ExecuteScript("x2_def_heartbeat", OBJECT_SELF);
    ExecuteScript("prc_npc_hb", OBJECT_SELF);
}