void main()
{
    if(GetIsObjectValid(GetMaster(OBJECT_SELF)))
        ExecuteScript("nw_ch_aca", OBJECT_SELF);
    else
        ExecuteScript("x2_def_rested", OBJECT_SELF);
    ExecuteScript("prc_npc_rested", OBJECT_SELF);
}