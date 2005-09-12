void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_ac5", OBJECT_SELF);
    else
        ExecuteScript("x2_def_attacked", OBJECT_SELF);
    ExecuteScript("prc_npc_attacked", OBJECT_SELF);
}