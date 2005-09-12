void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_acd", OBJECT_SELF);
    else
        ExecuteScript("x2_def_userdef", OBJECT_SELF);
    ExecuteScript("prc_npc_userdef", OBJECT_SELF);
}