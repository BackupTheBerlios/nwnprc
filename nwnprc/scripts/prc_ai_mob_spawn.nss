void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_acani9", OBJECT_SELF);
    else
        ExecuteScript("x2_def_spawn", OBJECT_SELF);
    ExecuteScript("prc_npc_spawn", OBJECT_SELF);
}